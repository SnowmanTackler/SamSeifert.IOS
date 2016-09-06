//
//  SplitSegue.h
//  R by S
//
//  Created by Sam Seifert on 2/7/15.
//  Copyright (c) 2015 Sam Seifert. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^alertViewAction)(void);

@interface CustomAlertViewButton : NSObject

- (id) initWithAction:(alertViewAction) a andName:(NSString*) nm;
@property (strong) alertViewAction _alertViewAction;
@property (strong) NSString * _text;

@end

@interface CustomAlertView : UIViewController

+ (void) showCustomAlertViewWithMessage:(NSString *) mg
                             andButtons:(NSArray *) bs
                       onViewController:(UIViewController *) vc;

+ (void) showCustomAlertViewWithMessage:(NSString *) mg
                             andButtons:(NSArray *) bs
                       onViewController:(UIViewController *) vc
                              withTitle:(NSString *) ti;

+ (void) showCustomAlertViewWithMessage:(NSString *) mg
                       onViewController:(UIViewController *) vc;

@end

@interface UIView (CustomAlertView)

- (void) slideUp:(NSNumber *) duration;

@end
