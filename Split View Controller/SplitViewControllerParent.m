//
//  UITableViewControllerSplitParent.m
//  Read by Sound
//
//  Created by Sam Seifert on 2/8/15.
//  Copyright (c) 2015 Sam Seifert. All rights reserved.
//

#import "SplitViewControllerParent.h"
#import "SplitViewController.h"
#import "SamsMethods.h"

@interface SplitViewControllerParent ()

@property (weak, nonatomic) IBOutlet UIView * _UIContainerView;
@property (weak, nonatomic) IBOutlet UIView * _UITranslateView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint * _NSLayoutConstraintTrailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint * _NSLayoutConstraintLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint * _NSLayoutConstraintLeadingTranslate;

@property (weak, nonatomic) UINavigationController * _LeftNavController;

@end

@implementation SplitViewControllerParent

- (UINavigationController *) getLeftmostNavController
{
    [self view]; // Initiate View
    return self._LeftNavController;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"embed"])
    {
        if isIpadOrBigger
        {
            CGFloat w = MIN(self.view.frame.size.width, self.view.frame.size.height);
            CGFloat h = MAX(self.view.frame.size.width, self.view.frame.size.height);
            CGFloat dif = h - w;
                        
            UINavigationController * uinc = [[UINavigationController alloc] init];
            [self._UITranslateView addSubview:uinc.view];
            [self addChildViewController:uinc];
            [SamsMethods constrainToMatchParent:uinc.view top:YES bot:YES left:NO right:YES];
            
            NSLayoutConstraint * nslcew = [NSLayoutConstraint constraintWithItem:uinc.view
                                                                       attribute:NSLayoutAttributeWidth
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                      multiplier:1
                                                                        constant:w];
            [uinc.view addConstraint:nslcew];
            
            uinc.view.backgroundColor = [UIColor whiteColor];
            self._UITranslateView.backgroundColor = [UIColor lightGrayColor];
            
            [self._UITranslateView removeConstraint:self._NSLayoutConstraintLeading];
            [self._UITranslateView removeConstraint:self._NSLayoutConstraintTrailing];
            [self.view removeConstraint:self._NSLayoutConstraintLeadingTranslate];
            
            NSLayoutConstraint * nslctw = [NSLayoutConstraint constraintWithItem:self._UITranslateView
                                                                       attribute:NSLayoutAttributeWidth
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                      multiplier:1
                                                                        constant:h];
            [self._UITranslateView addConstraint:nslctw];
            
            [self._UITranslateView addConstraint:[NSLayoutConstraint constraintWithItem:self._UITranslateView
                                                                              attribute:NSLayoutAttributeLeading
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self._UIContainerView
                                                                              attribute:NSLayoutAttributeLeading
                                                                             multiplier:1
                                                                               constant:0]];
            
            NSLayoutConstraint * nslcsw = [NSLayoutConstraint constraintWithItem:self._UIContainerView
                                                                     attribute:NSLayoutAttributeWidth
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:1
                                                                      constant:dif - (1 / [UIScreen mainScreen].scale)];
            [self._UIContainerView addConstraint:nslcsw];
            SplitViewController * child = segue.destinationViewController;
            UIPanGestureRecognizer * uipgr = [[UIPanGestureRecognizer alloc] initWithTarget:child
                                                                                     action:@selector(handlePan:)];

            [uinc.navigationBar addGestureRecognizer:uipgr];
            child._ChildViewController = uinc;
            child._ParentView = self._UITranslateView;
            child._NSLayoutConstraintSidebarWidth = nslcsw;
            child._NSLayoutConstraintTranslateWidth = nslctw;
            child._NSLayoutConstraintEmbedWidth = nslcew;
        }
        else
        {
            self._UITranslateView.backgroundColor = [UIColor whiteColor];
        }
        
        self._LeftNavController = segue.destinationViewController;
    }    
}

@end
