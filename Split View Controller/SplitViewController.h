//
//  UITableViewControllerSplit.h
//  BarkBuddy
//
//  Created by Sam Seifert on 1/21/15.
//  Copyright (c) 2015 Sam Seifert. All rights reserved.
//

/*
 * This class will only be allocated on isIpadOrBigger
 */

#import <UIKit/UIKit.h>

@interface SplitViewController : UINavigationController

@property (weak, nonatomic) UIView * _ParentView;
@property (weak, nonatomic) UINavigationController * _ChildViewController;
@property (weak, nonatomic) NSLayoutConstraint * _NSLayoutConstraintSidebarWidth;
@property (weak, nonatomic) NSLayoutConstraint * _NSLayoutConstraintTranslateWidth;
@property (weak, nonatomic) NSLayoutConstraint * _NSLayoutConstraintEmbedWidth;

- (void) setupViewController:(UIViewController *) vc animated:(BOOL) b;
- (IBAction)handlePan:(UIPanGestureRecognizer *) recognizer;

- (void) setBackButton:(UIBarButtonItem *) b;

@end

@interface UIViewController (SplitViewControllerHelpers)

- (SplitViewController *) splitViewController;

@end

