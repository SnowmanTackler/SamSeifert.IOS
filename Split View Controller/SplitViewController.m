//
//  UITableViewControllerSplit.m
//  BarkBuddy
//
//  Created by Sam Seifert on 1/21/15.
//  Copyright (c) 2015 Sam Seifert. All rights reserved.
//

#import "SplitViewControllerParent.h"
#import "SplitViewController.h"
#import "SamsMethods.h"

@interface SplitViewController ()

@property BOOL _BoolShowBar;
@property BOOL _BoolAnimateInOut;

@end


@implementation SplitViewController

- (id) init
{
    if ((self = [super init])) [self OnInitialize];
    return self;
}

- (void) awakeFromNib
{
    [super awakeFromNib];
    [self OnInitialize];
}

- (void) OnInitialize
{
    self._BoolShowBar = NO;
}

- (CGFloat) getSidebarWidth { return 0; }
- (void) shouldNotSidebarInAndOut { }
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    id fvc = self.viewControllers.firstObject;
    if ([fvc respondsToSelector:@selector(setupInitial)]) [fvc setupInitial];
    else if (isIpadOrBigger)
    {
        CGFloat w = [UIScreen mainScreen].bounds.size.width;
        CGFloat h = [UIScreen mainScreen].bounds.size.height;
        CGFloat dif = ABS(w - h);
        
        id uivc = [self.viewControllers firstObject];
        if ([uivc respondsToSelector:@selector(getSidebarWidth)]) dif = [uivc getSidebarWidth];
        if ([uivc respondsToSelector:@selector(shouldNotSidebarInAndOut)])
        {
            self._NSLayoutConstraintEmbedWidth.constant = w - dif;
            self._NSLayoutConstraintTranslateWidth.constant = w;
            self._NSLayoutConstraintSidebarWidth.constant = dif - (1 / [UIScreen mainScreen].scale);
        }
        else
        {
            self._NSLayoutConstraintTranslateWidth.constant = dif + w;
            self._NSLayoutConstraintSidebarWidth.constant = dif - (1 / [UIScreen mainScreen].scale);
            self._ParentView.layer.transform = translateX(dif);
            self._BoolShowBar = YES;
        }
    }
}

- (void) splitViewControllerShouldDisplayOnMain {}
- (void) setupViewController:(UIViewController *) vc animated:(BOOL) b
{
    if (
        (self._ChildViewController == nil) ||
        (
         (
          [vc isKindOfClass:[UITableViewController class]] ||
          [vc isKindOfClass:[UICollectionView class]]
         ) && (
          ![vc respondsToSelector:@selector(splitViewControllerShouldDisplayOnMain)])
         )
        )
    {
        [self pushViewController:vc animated:b];
    }
    else
    {
        if (self._BoolShowBar) [self pullOutSide:nil];
        [self._ChildViewController setViewControllers:@[vc] animated:NO];

        if ([vc respondsToSelector:@selector(shouldNotSidebarInAndOut)])
        {
            vc.navigationItem.leftBarButtonItem = nil;            
        }
        else
        {
            [vc.navigationItem.leftBarButtonItem setTarget:self];
            [vc.navigationItem.leftBarButtonItem setAction:@selector(pullOutSide:)];
            [self._ChildViewController.viewControllers.firstObject navigationItem].leftBarButtonItem.enabled = !isSideways;
        }
    }
}

- (IBAction)handlePan:(UIPanGestureRecognizer *) recognizer
{
    CGPoint translation = [recognizer translationInView:self.view.superview];
    [recognizer setTranslation:CGPointZero inView:self.view.superview];
        
    if (self._ParentView.frame.size.width > self._ParentView.frame.size.height) return;

    CGFloat w = self.view.frame.size.width;
    
    CALayer * dlay = self._ParentView.layer.presentationLayer;

    if ([recognizer state] == UIGestureRecognizerStateEnded)
    {
        self._BoolShowBar = dlay.transform.m41 < w / 2;
        [self pullOutSide:nil];
    }
    else
    {
        CGFloat next = MAX(0, MIN(w, translation.x + dlay.transform.m41));        
        self._ParentView.layer.transform = CATransform3DMakeTranslation(next, 0, 0);
    }
}

- (IBAction)pullOutSide:(UIBarButtonItem *)sender
{
    CGFloat tttt = 6;
    CALayer * dlay = self._ParentView.layer.presentationLayer;
    CGFloat from = dlay.transform.m41;
    CATransform3D t = CATransform3DIdentity;
    CABasicAnimation * animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.translation.x";
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.fillMode = kCAFillModeBackwards;
    animation.removedOnCompletion = YES;

    if (isSideways)
    {
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.fromValue = @(0);
        animation.toValue = @(self.view.frame.size.width / 10);
        animation.duration = 0.1f;
        animation.autoreverses = YES;
        [self._ChildViewController.view.layer addAnimation:animation forKey:@"mk"];
        self._ChildViewController.view.layer.transform = t;
        return;
    }
    else
    {
        self._BoolShowBar = !self._BoolShowBar;
        if (self._BoolShowBar)
        {
            CGFloat to = self.view.frame.size.width;
            CGFloat time = ABS(to - from) / (tttt * self.view.frame.size.width);
            animation.fromValue = @(from);
            animation.toValue = @(to);
            animation.duration = time;
            t = CATransform3DMakeTranslation(self.view.frame.size.width, 0, 0);
        }
        else
        {
            CGFloat to = 0;
            CGFloat time = ABS(to - from) / (tttt * self.view.frame.size.width);
            animation.fromValue = @(from);
            animation.toValue = @(to);
            animation.duration = time;
        }
    }
    
    animation.duration += 0.1f;
    [self._ParentView.layer addAnimation:animation forKey:@"mk"];
    self._ParentView.layer.transform = t;
}

- (void) viewWillTransitionToSize:(CGSize) size
        withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>) coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    if (size.width > size.height)
    {
        [self._ChildViewController.viewControllers.firstObject navigationItem].leftBarButtonItem.enabled = NO;
        if (self._BoolShowBar)
        {
            [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
             {
                 self._ParentView.layer.transform = CATransform3DIdentity;
             } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
                 self._BoolShowBar = NO;
             }];
        }
    }
    else
    {
        [self._ChildViewController.viewControllers.firstObject navigationItem].leftBarButtonItem.enabled = YES;
    }
    
}

@end
