//
//  StaticMethods.h
//  R by S
//
//  Created by Sam Seifert on 11/19/14.
//  Copyright (c) 2014 Sam Seifert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// THIS METHOD FAILS FOR UNSIGNED NUMBERS (unsigned - signed)
#define sign(x) (((x) > 0) - ((x) < 0))


#define translateX(f) CATransform3DMakeTranslation(f,0,0)
#define translateY(f) CATransform3DMakeTranslation(0,f,0)
#define translateCGX(f) CGAffineTransformMakeTranslation(f,0)
#define translateCGY(f) CGAffineTransformMakeTranslation(0,f)

#define NavBarColor(r, g, b) [UIColor colorWithRed:(r - 35) / (255 - 35) \
                                             green:(g - 35) / (255 - 35) \
                                              blue:(b - 35) / (255 - 35) alpha:1]

