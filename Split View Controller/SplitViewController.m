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

@property (weak, nonatomic) UIBarButtonItem * _BackButton;

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

- (bool) isSetupAsIpad
{
    //  This is only set by parent when isIpadOrBigger
    return self._ChildViewController != nil;
}

- (CGFloat) splitViewController_IWantSidebarWithWidth { return 0; } // Unsure why this is here, not in Read by Sound
- (void) splitViewController_IDontWantSidebar { }
- (void) splitViewController_IShouldDisplayOnMain {} // A VC implementing this method will be on main page of iPAD
- (void) splitViewController_IAmBeingRemoved {}
- (UIBarButtonItem *) splitViewController_IHaveCustomBackButton { return nil; } // If this returns nil, you must use the splitViewController method in the childs view did load to set the parrent setBackButton


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self isSetupAsIpad])
    {
        CGFloat w = [UIScreen mainScreen].bounds.size.width;
        CGFloat h = [UIScreen mainScreen].bounds.size.height;
        CGFloat dif = ABS(w - h);
        
        id uivc = [self.viewControllers firstObject];
        if ([uivc respondsToSelector:@selector(splitViewController_IWantSidebarWithWidth)])
            dif = [uivc splitViewController_IWantSidebarWithWidth];
        
        if ([uivc respondsToSelector:@selector(splitViewController_IDontWantSidebar)])
        {
            self._NSLayoutConstraintEmbedWidth.constant = w - dif;
            self._NSLayoutConstraintTranslateWidth.constant = w;
            self._NSLayoutConstraintSidebarWidth.constant = dif - (1 / [UIScreen mainScreen].scale);
        }
        else
        {
            self._NSLayoutConstraintTranslateWidth.constant = dif + w;
            self._NSLayoutConstraintSidebarWidth.constant = dif - (1 / [UIScreen mainScreen].scale);
            
            // Pull out sidebar
            if (!isSideways)
            {
                self._ParentView.layer.transform = translateX(dif);
                self._BoolShowBar = YES;
            }
        }
    }
}

+ (void) tellAllChildrenTheyAreBeingRemovedRecursively:(UIViewController *) uivc
{
    for (id child in uivc.childViewControllers)
        [SplitViewController tellAllChildrenTheyAreBeingRemovedRecursively:child];
    
    if ([uivc respondsToSelector:@selector(splitViewController_IAmBeingRemoved)])
        [((id)uivc) splitViewController_IAmBeingRemoved];
}

- (void) setupViewController:(UIViewController *) vc animated:(BOOL) b
{
    if ((![self isSetupAsIpad]) || // on a phone
        (
         (
          [vc isKindOfClass:[UITableViewController class]] ||
          [vc isKindOfClass:[UICollectionView class]]
         ) && (
          ![vc respondsToSelector:@selector(splitViewController_IShouldDisplayOnMain)])
         )
        )
    {
        [self pushViewController:vc animated:b];
    }
    else
    {
        [SplitViewController tellAllChildrenTheyAreBeingRemovedRecursively:self._ChildViewController];

        if (self._BoolShowBar) [self pullOutSide:nil];
        [self._ChildViewController setViewControllers:@[vc] animated:NO];

        [self setBackButton:nil];
        
        if ([vc respondsToSelector:@selector(splitViewController_IDontWantSidebar)])
        {
            vc.navigationItem.leftBarButtonItem = nil;
        }
        else if ([vc respondsToSelector:@selector(splitViewController_IHaveCustomBackButton)])
        {
            UIBarButtonItem * uibbi = [((id)vc) splitViewController_IHaveCustomBackButton];
            [self setBackButton:uibbi];
            // Doing it this way makes sure all children are layed out before calling didFinishAutoLayout,
            // This way if the view isn't set until viewDidLoad we can grab it.
        }
        else
        {
            [self setBackButton:vc.navigationItem.leftBarButtonItem];
        }
    }
}

- (void) setBackButton:(UIBarButtonItem *) b // nullable
{
    if (![self isSetupAsIpad]) return; // Don't care for iphone

    [self._BackButton setAction:nil];
    [self._BackButton setTarget:nil];
 
     self._BackButton = b;
    
    [self._BackButton setTarget:self];
    [self._BackButton setAction:@selector(pullOutSide:)];
    [self._BackButton setEnabled:!isSideways];
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
        /*
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.fromValue = @(0);
        animation.toValue = @(self.view.frame.size.width / 10);
        animation.duration = 0.1f;
        animation.autoreverses = YES;
        [self._ChildViewController.view.layer addAnimation:animation forKey:@"mk"];
        self._ChildViewController.view.layer.transform = t;
        return;
         */
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

    if (![self isSetupAsIpad]) return; // Don't care for iphone
    
    if (size.width > size.height)
    {
        [self._BackButton setEnabled:NO];
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
        [self._BackButton setEnabled:YES];
        [self._ChildViewController.viewControllers.firstObject navigationItem].leftBarButtonItem.enabled = YES;
    }    
}

@end



@implementation UIViewController (SplitViewControllerHelpers)

- (SplitViewController *) splitViewController
{
    UIViewController * uivc = self;
    
    while (uivc != nil)
    {
        if ([uivc isKindOfClass:[SplitViewController class]])
        {
            return (id) uivc;
        }
        else if ([uivc isKindOfClass:[SplitViewControllerParent class]])
        {
            return [((SplitViewControllerParent*) uivc) getSplitViewController];
        }
        else uivc = [uivc parentViewController];
    }
    
    return nil;
}

@end
