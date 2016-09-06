//
//  SwipeViewController.h
//  BarkBuddy
//
//  Created by Sam Seifert on 12/16/14.
//  Copyright (c) 2014 Sam Seifert. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISwipeViewController : UITabBarController

- (void) pushForwardIfYouCan;
- (void) skipTo:(NSInteger) dex;

@property NSInteger _ViewControllerIndex;

@property (strong) NSMutableArray * _SwipeViewControllers;

@property (weak) UIViewController * _bvc; // Base View Controller

@end



/*
@protocol UISwipeViewControllerChild <NSObject>

@required - (void) newViewsAdded;
@required - (BOOL) canAdvance;
@required - (BOOL) canReverse;
@required - (void) setViewProgress:(CGFloat) f;
@required - (void) setViewProgress:(CGFloat) f
                            timing:(CAMediaTimingFunction *) tf
                             start:(CFTimeInterval) start_t
                          duration:(CFTimeInterval) duration;

@end
*/