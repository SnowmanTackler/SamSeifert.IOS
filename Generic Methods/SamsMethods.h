//
//  StaticMethods.h
//  R by S
//
//  Created by Sam Seifert on 11/19/14.
//  Copyright (c) 2014 Sam Seifert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define sign(x)  ((((long)(x)) == 0) ? 0 : (1 - 2 * signbit(((long)(x)))))

#define translateX(f) CATransform3DMakeTranslation(f,0,0)
#define translateY(f) CATransform3DMakeTranslation(0,f,0)
#define translateCGX(f) CGAffineTransformMakeTranslation(f,0)
#define translateCGY(f) CGAffineTransformMakeTranslation(0,f)

#define cconst 35.0f
#define NavBarColor(r, g, b) [UIColor colorWithRed:(r - cconst) / (255 - cconst) \
                                             green:(g - cconst) / (255 - cconst) \
                                              blue:(b - cconst) / (255 - cconst) alpha:1]

@interface SamsMethods : NSObject

+ (void) constrainToMatchParent:(UIView *) v top:(BOOL) top bot:(BOOL) bot left:(BOOL) left right:(BOOL) right;
+ (void) constrainToMatchParent:(UIView *) v;
+ (void) constrain:(UIView *) v toParentwithAttribute:(NSLayoutAttribute) att;
+ (void) constrain:(UIView *) v1 to:(UIView *) v2 inside:(UIView *) v withAttribute:(NSLayoutAttribute) att;
+ (void) constrain:(UIView *) v to:(CGRect) r;
+ (NSInteger) daysBetween:(NSDate *) dt1 and:(NSDate *) dt2;

+ (unsigned long long int) folderSize:(NSString *) fp;

@end
