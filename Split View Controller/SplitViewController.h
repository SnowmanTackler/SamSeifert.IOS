//
//  UITableViewControllerSplit.h
//  BarkBuddy
//
//  Created by Sam Seifert on 1/21/15.
//  Copyright (c) 2015 Sam Seifert. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SplitViewControllerRoot <NSObject>

@required - (void) setupInitial;

@end

@interface SplitViewController : UINavigationController

@property (weak, nonatomic) UIView * _ParentView;
@property (weak, nonatomic) UINavigationController * _ChildViewController;
@property (weak, nonatomic) NSLayoutConstraint * _NSLayoutConstraintSidebarWidth;
@property (weak, nonatomic) NSLayoutConstraint * _NSLayoutConstraintTranslateWidth;
@property (weak, nonatomic) NSLayoutConstraint * _NSLayoutConstraintEmbedWidth;

- (void) setupViewController:(UIViewController *) vc animated:(BOOL) b;
- (IBAction)handlePan:(UIPanGestureRecognizer *) recognizer;

@end
