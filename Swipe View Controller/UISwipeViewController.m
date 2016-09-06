//
//  SwipeViewController.m
//  BarkBuddy
//
//  Created by Sam Seifert on 12/16/14.
//  Copyright (c) 2014 Sam Seifert. All rights reserved.
//

#import "UISwipeViewController.h"
#import "SamsMethods.h"

#define SwipeDurationTime 0.66f

@interface UISwipeViewController ()
{
    CGFloat _ViewControllerPan;
}

@property (weak) UIViewController * _pvc; // Previous View Controller
@property (weak) UIViewController * _cvc; // Current View Controller
@property (weak) UIViewController * _nvc; // Next View Controller

@end

@implementation UISwipeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tabBar.hidden = YES;
    
    id bvc = [self.viewControllers firstObject];
    
    self._ViewControllerIndex = 0;
    self._SwipeViewControllers = [[NSMutableArray alloc] initWithArray:self.viewControllers];
    [self._SwipeViewControllers removeObjectAtIndex:0];
    
    [self setViewControllers:@[bvc]];
    [self initGestureRecognizers];
    
    self._bvc = bvc;
    self._cvc = [self._SwipeViewControllers objectAtIndex:self._ViewControllerIndex];
    self._nvc = self._ViewControllerIndex + 1 < self._SwipeViewControllers.count ?
        [self._SwipeViewControllers objectAtIndex:self._ViewControllerIndex + 1] : nil;
    self._pvc = self._ViewControllerIndex > 0 ?
        [self._SwipeViewControllers objectAtIndex:self._ViewControllerIndex - 1] : nil;

}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    id bvc = [self.viewControllers firstObject];
    id cvc = [self._SwipeViewControllers objectAtIndex:0];

    [bvc addChildViewController:cvc];
    [[bvc view] addSubview:[cvc view]];
    [[bvc view] sendSubviewToBack:[cvc view]];
    [self newViewsAdded];
    
    [self pushFinish];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) initGestureRecognizers
{
    UIPanGestureRecognizer * p = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                         action:@selector(gesturePan:)];
    [self.view addGestureRecognizer:p];
    
    UISwipeGestureRecognizer * sr = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(gestureSwipeR:)];
    
    sr.direction = UISwipeGestureRecognizerDirectionRight;
    sr.numberOfTouchesRequired = 1;
    
    [self.view addGestureRecognizer:sr];
    
    UISwipeGestureRecognizer * sl = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(gestureSwipeL:)];
    
    sl.direction = UISwipeGestureRecognizerDirectionLeft;
    sl.numberOfTouchesRequired = 1;
    
    [self.view addGestureRecognizer:sl];
}

- (void) gesturePan:(UIPanGestureRecognizer *) recognizer
{
    self._pvc.view.userInteractionEnabled = NO;
    self._cvc.view.userInteractionEnabled = NO;
    self._nvc.view.userInteractionEnabled = NO;
    
    CGPoint translation = [recognizer translationInView:self.view];
    [recognizer setTranslation:CGPointZero inView:self.view];
    
    CGFloat this_width = self.view.frame.size.width;
 
    if ([recognizer state] == UIGestureRecognizerStateEnded)
    {
        if ([self canAdvance] && (-_ViewControllerPan > this_width / 4))
        {
            [self pushForward:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]
                     duration:SwipeDurationTime * (1 - (ABS(_ViewControllerPan) / this_width))];
        }
        else if ([self canReverse] && (_ViewControllerPan > this_width / 4))
        {
            [self pushBackward:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]
                      duration:SwipeDurationTime * (1 - (ABS(_ViewControllerPan) / this_width))];
        }
        else
        {
            [self pushZero:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]
                  duration:SwipeDurationTime * 2 * (ABS(_ViewControllerPan) / this_width)];
        }
    }
    else
    {
        id bvc = self._bvc;
        id pvc = self._pvc;
        id cvc = self._cvc;
        id nvc = self._nvc;
        
        CGFloat dead_pan_mutliplier = 100; // higher number will prevent swiping past limits harder
        
        if (translation.x < 0) // Forward
        {
            if (_ViewControllerPan + translation.x < 0) // Actually Passed Zero Point
            {
                if ([self canAdvance])
                {
                    _ViewControllerPan += translation.x;
                    if ([[nvc view] superview] == nil)
                    {
                        [bvc addChildViewController:nvc];
                        [[bvc view] addSubview:[nvc view]];
                        [[bvc view] sendSubviewToBack:[nvc view]];
                        [[bvc view] sendSubviewToBack:[cvc view]]; // ordering consistent when swiping forward or back
                        [self setFinishForwardBackward:self._nvc];
                        [self newViewsAdded];
                    }
                }
                else _ViewControllerPan += translation.x /
                    (1 + dead_pan_mutliplier * ABS(_ViewControllerPan / this_width));
            }
            else _ViewControllerPan += translation.x;
        }
        else if (translation.x > 0) // Backward
        {
            if (_ViewControllerPan + translation.x > 0) // Actually Passed Zero Point
            {
                if ([self canReverse])
                {
                    _ViewControllerPan += translation.x;
                    if ([[pvc view] superview] == nil)
                    {
                        [bvc addChildViewController:pvc];
                        [[bvc view] addSubview:[pvc view]];
                        [[bvc view] sendSubviewToBack:[pvc view]];
                        [self setFinishForwardBackward:self._bvc];
                        [self newViewsAdded];
                    }
                }
                else _ViewControllerPan += translation.x /
                    (1 + dead_pan_mutliplier * ABS(_ViewControllerPan / this_width));
            }
            else _ViewControllerPan += translation.x;            
        }
        
        _ViewControllerPan = MIN( this_width, _ViewControllerPan);
        _ViewControllerPan = MAX(-this_width, _ViewControllerPan);

        [pvc view].layer.transform = translateX(_ViewControllerPan - this_width);
        [cvc view].layer.transform = translateX(_ViewControllerPan);
        [nvc view].layer.transform = translateX(_ViewControllerPan + this_width);
        
        CGFloat progress = _ViewControllerPan / this_width;
        
        [self setViewProgress:progress];

        if ([pvc respondsToSelector:@selector(setViewProgress:)]) [pvc setViewProgress:progress - 1];
        if ([cvc respondsToSelector:@selector(setViewProgress:)]) [cvc setViewProgress:progress];
        if ([nvc respondsToSelector:@selector(setViewProgress:)]) [nvc setViewProgress:progress + 1];
    }
}

- (void) pushForwardIfYouCan
{
    [self gestureSwipeL:nil];
}

- (void) gestureSwipeL:(UISwipeGestureRecognizer *) recognizer
{
    if ([self canAdvance])
    {
        if (self._nvc.view.superview == nil)
        {
            
            [self._bvc addChildViewController:self._nvc];
            [self._bvc.view addSubview:self._nvc.view];
            [self._bvc.view sendSubviewToBack:self._nvc.view];
            [self._bvc.view sendSubviewToBack:self._cvc.view]; // ordering is consistent whether swiping forward or back
            [self setFinishForwardBackward:self._nvc];
            
            id nvc = self._nvc;
            CGFloat this_width = self.view.frame.size.width;
            CGFloat progress = _ViewControllerPan / this_width;
            [self._nvc view].layer.transform = translateX(_ViewControllerPan + this_width);
            if ([nvc respondsToSelector:@selector(setViewProgress:)]) [nvc setViewProgress:progress + 1];

            [self newViewsAdded];
        }
        
        [self pushForward:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]
                 duration:SwipeDurationTime];
    }
}

- (void) gestureSwipeR:(UISwipeGestureRecognizer *) recognizer
{
    if ([self canReverse])
    {
        if (self._pvc.view.superview == nil)
        {
            [self._bvc addChildViewController:self._pvc];
            [self._bvc.view addSubview:self._pvc.view];
            [self._bvc.view sendSubviewToBack:self._pvc.view];
            [self setFinishForwardBackward:self._pvc];

            id pvc = self._pvc;
            CGFloat this_width = self.view.frame.size.width;
            CGFloat progress = _ViewControllerPan / this_width;
            [self._nvc view].layer.transform = translateX(_ViewControllerPan - this_width);
            if ([pvc respondsToSelector:@selector(setViewProgress:)]) [pvc setViewProgress:progress - 1];
            
            [self newViewsAdded];
        }

        [self pushBackward:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]
                  duration:SwipeDurationTime];
    }
}

- (void) newViewsAdded
{
    id bvc = self._bvc;
    if ([bvc respondsToSelector:@selector(newViewsAdded)])
        [bvc newViewsAdded];
}

- (BOOL) canAdvance // prototype for child view controllers
{
    BOOL b = self._nvc != nil;
    id cvc = self._cvc;
    if ([cvc respondsToSelector:@selector(canAdvance)]) b &= [cvc canAdvance];
    return b;
}

- (BOOL) canReverse // prototype for child view controllers
{
    BOOL b = self._pvc != nil;
    id cvc = self._cvc;
    if ([cvc respondsToSelector:@selector(canReverse)]) b &= [cvc canReverse];
    return b;
}

- (void) setViewProgress:(CGFloat) f // prototype {1 is coming in from front, -1 is coming in from back}
{
    id idvc = self._bvc;
    if ([idvc respondsToSelector:@selector(setViewProgress:)])
        [idvc setViewProgress:f];
    
}

- (void) setViewProgress:(CGFloat) f
                  timing:(CAMediaTimingFunction *) tf
                   start:(CFTimeInterval) start_t
                   duration:(CFTimeInterval) duration
{
    id idvc = self._bvc;
    if ([idvc respondsToSelector:@selector(setViewProgress:timing:start:duration:)])
        [idvc setViewProgress:f timing:tf start:start_t duration:duration];
    else if ([idvc respondsToSelector:@selector(setViewProgress:)])
        [idvc setViewProgress:f];
}

#define start_time (CACurrentMediaTime() - 0.01f)
- (void) pushBackward:(CAMediaTimingFunction *) tf
             duration:(CFTimeInterval) duration
{
    if (!self.view.userInteractionEnabled) return;
    self.view.userInteractionEnabled = NO;
    CFTimeInterval start_t = start_time;
    
    if (self._pvc)
    {
        UIView * v = [self._pvc view];
        CABasicAnimation * animation = [CABasicAnimation animation];
        animation.keyPath = @"transform.translation.x";
        animation.fromValue = @(v.layer.transform.m41);
        animation.toValue = @(0);
        animation.beginTime = start_t;
        animation.duration = duration;
        animation.timingFunction = tf;
        [v.layer addAnimation:animation forKey:@"basic"];
        [v.layer setTransform:CATransform3DMakeTranslation(0, 0, 0)];
        
        id idvc = self._pvc;
        if ([idvc respondsToSelector:@selector(setViewProgress:timing:start:duration:)])
            [idvc setViewProgress:0 timing:tf start:start_t duration:duration];
        else if ([idvc respondsToSelector:@selector(setViewProgress:)])
            [idvc setViewProgress:0];
    }
    
    if (self._cvc)
    {
        UIView * v = [self._cvc view];
        CABasicAnimation * animation = [CABasicAnimation animation];
        animation.keyPath = @"transform.translation.x";
        animation.fromValue = @(v.layer.transform.m41);
        animation.toValue = @(self.view.frame.size.width);
        animation.beginTime = start_t;
        animation.duration = duration;
        animation.timingFunction = tf;
        [v.layer addAnimation:animation forKey:@"basic"];
        [v.layer setTransform:CATransform3DMakeTranslation(self.view.frame.size.width, 0, 0)];
        
        id idvc = self._cvc;
        if ([idvc respondsToSelector:@selector(setViewProgress:timing:start:duration:)])
            [idvc setViewProgress:1 timing:tf start:start_t duration:duration];
        else if ([idvc respondsToSelector:@selector(setViewProgress:)])
            [idvc setViewProgress:1];
    }
    
    [self setViewProgress:1 timing:tf start:start_t duration:duration];
    [self performSelector:@selector(pushBackEnd) withObject:nil afterDelay:duration];
}

- (void) pushBackEnd
{
    [self._cvc.view removeFromSuperview];
    [self._cvc removeFromParentViewController];
    self._ViewControllerIndex--;
    self._nvc = self._cvc;
    self._cvc = self._pvc;
    self._pvc = self._ViewControllerIndex > 0 ?
    [self._SwipeViewControllers objectAtIndex:self._ViewControllerIndex - 1] : nil;
    [self pushFinish];
}

- (void) pushZero:(CAMediaTimingFunction *) tf
         duration:(CFTimeInterval) duration
{
    if (!self.view.userInteractionEnabled) return;
    self.view.userInteractionEnabled = NO;
    CFTimeInterval start_t = start_time;
    
    if (self._pvc)
    {
        UIView * v = [self._pvc view];
        CABasicAnimation * animation = [CABasicAnimation animation];
        animation.keyPath = @"transform.translation.x";
        animation.fromValue = @(v.layer.transform.m41);
        animation.toValue = @(-self.view.frame.size.width);
        animation.beginTime = start_t;
        animation.duration = duration;
        animation.timingFunction = tf;
        [v.layer addAnimation:animation forKey:@"basic"];
        [v.layer setTransform:CATransform3DMakeTranslation(- self.view.frame.size.width, 0, 0)];
        
        id idvc = self._pvc;
        if ([idvc respondsToSelector:@selector(setViewProgress:timing:start:duration:)])
            [idvc setViewProgress:-1 timing:tf start:start_t duration:duration];
        else if ([idvc respondsToSelector:@selector(setViewProgress:)])
            [idvc setViewProgress:-1];
    }
    
    if (self._cvc)
    {
        UIView * v = [self._cvc view];
        CABasicAnimation * animation = [CABasicAnimation animation];
        animation.keyPath = @"transform.translation.x";
        animation.fromValue = @(v.layer.transform.m41);
        animation.toValue = @(0);
        animation.beginTime = start_t;
        animation.duration = duration;
        animation.timingFunction = tf;
        [v.layer addAnimation:animation forKey:@"basic"];
        [v.layer setTransform:CATransform3DMakeTranslation(0, 0, 0)];

        id idvc = self._cvc;
        if ([idvc respondsToSelector:@selector(setViewProgress:timing:start:duration:)])
            [idvc setViewProgress:0 timing:tf start:start_t duration:duration];
        else if ([idvc respondsToSelector:@selector(setViewProgress:)])
            [idvc setViewProgress:0];
    }
    
    if (self._nvc)
    {
        UIView * v = [self._nvc view];
        CABasicAnimation * animation = [CABasicAnimation animation];
        animation.keyPath = @"transform.translation.x";
        animation.fromValue = @(v.layer.transform.m41);
        animation.toValue = @(self.view.frame.size.width);
        animation.beginTime = start_t;
        animation.duration = duration;
        animation.timingFunction = tf;
        [v.layer addAnimation:animation forKey:@"basic"];
        [v.layer setTransform:CATransform3DMakeTranslation(self.view.frame.size.width, 0, 0)];

        id idvc = self._nvc;
        if ([idvc respondsToSelector:@selector(setViewProgress:timing:start:duration:)])
            [idvc setViewProgress:1 timing:tf start:start_t duration:duration];
        else if ([idvc respondsToSelector:@selector(setViewProgress:)])
            [idvc setViewProgress:1];
    }
    
    [self setViewProgress:0 timing:tf start:start_t duration:duration];
    [self performSelector:@selector(pushZeroEnd) withObject:nil afterDelay:duration];
}

- (void) pushZeroEnd
{
    id pvc = self._pvc;
    id nvc = self._nvc;
    
    [[nvc view] removeFromSuperview];
    [nvc removeFromParentViewController];
    [[pvc view] removeFromSuperview];
    [pvc removeFromParentViewController];
    [self pushFinish];
}

- (void) pushForward:(CAMediaTimingFunction *) tf
            duration:(CFTimeInterval) duration
{
    if (!self.view.userInteractionEnabled) return;
    self.view.userInteractionEnabled = NO;
    CFTimeInterval start_t = start_time;
    
    if (self._cvc)
    {
        UIView * v = [self._cvc view];
        CABasicAnimation * animation = [CABasicAnimation animation];
        animation.keyPath = @"transform.translation.x";
        animation.fromValue = @(v.layer.transform.m41);
        animation.toValue = @(-self.view.frame.size.width);
        animation.beginTime = start_t;
        animation.duration = duration;
        animation.timingFunction = tf;
        [v.layer addAnimation:animation forKey:@"basic"];
        [v.layer setTransform:CATransform3DMakeTranslation(-self.view.frame.size.width, 0, 0)];
        
        id idvc = self._cvc;
        if ([idvc respondsToSelector:@selector(setViewProgress:timing:start:duration:)])
            [idvc setViewProgress:-1 timing:tf start:start_t duration:duration];
        else if ([idvc respondsToSelector:@selector(setViewProgress:)])
            [idvc setViewProgress:-1];
    }
    
    if (self._nvc)
    {
        UIView * v = [self._nvc view];
        CABasicAnimation * animation = [CABasicAnimation animation];
        animation.keyPath = @"transform.translation.x";
        animation.fromValue = @(v.layer.transform.m41);
        animation.toValue = @(0);
        animation.beginTime = start_t;
        animation.duration = duration;
        animation.timingFunction = tf;
        [v.layer addAnimation:animation forKey:@"basic"];
        [v.layer setTransform:CATransform3DMakeTranslation(0, 0, 0)];
        
        id idvc = self._nvc;
        if ([idvc respondsToSelector:@selector(setViewProgress:timing:start:duration:)])
            [idvc setViewProgress:0 timing:tf start:start_t duration:duration];
        else if ([idvc respondsToSelector:@selector(setViewProgress:)])
            [idvc setViewProgress:0];
    }
    
    [self setViewProgress:-1 timing:tf start:start_t duration:duration];
    [self performSelector:@selector(pushForwardEnd) withObject:nil afterDelay:duration];
}

- (void) pushForwardEnd
{
    [self._cvc.view removeFromSuperview];
    [self._cvc removeFromParentViewController];
    self._ViewControllerIndex++;
    self._pvc = self._cvc;
    self._cvc = self._nvc;
    self._nvc = self._ViewControllerIndex + 1 < self._SwipeViewControllers.count ?
    [self._SwipeViewControllers objectAtIndex:self._ViewControllerIndex + 1] : nil;
    [self pushFinish];
}

- (void) pushFinish
{
    self._pvc.view.userInteractionEnabled = YES;
    self._cvc.view.userInteractionEnabled = YES;
    self._nvc.view.userInteractionEnabled = YES;
    self.view.userInteractionEnabled = YES;
    _ViewControllerPan = 0;
    [self setFinishForward:(self._SwipeViewControllers.count - self._ViewControllerIndex - 1)
               andBackward:(self._ViewControllerIndex)];
}

- (void) setFinishForward:(NSInteger) f andBackward:(NSInteger) b
{
    [self setFinishForwardBackward:self._bvc];
    [self setFinishForwardBackward:self._pvc];
    [self setFinishForwardBackward:self._cvc];
    [self setFinishForwardBackward:self._nvc];
}

- (void) setFinishForwardBackward:(id) idvc
{
    if ([idvc respondsToSelector:@selector(setFinishForward:andBackward:)])
        [idvc setFinishForward:(self._SwipeViewControllers.count - self._ViewControllerIndex - 1)
                   andBackward:(self._ViewControllerIndex)];
    
}

- (void) skipTo:(NSInteger) dex
{
    self._ViewControllerIndex = dex;
    self._nvc = self._ViewControllerIndex + 1 < self._SwipeViewControllers.count ?
    [self._SwipeViewControllers objectAtIndex:self._ViewControllerIndex + 1] : nil;
}



@end
