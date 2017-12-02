//
//  UILabel_CustomFont.h
//
//  Created by Sam Seifert on 4/26/14.
//  Copyright (c) 2014 Sam Seifert. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (extensions_sam)

- (void) constrainToMatchParent_top:(BOOL) top bot:(BOOL) bot left:(BOOL) left right:(BOOL) right;
- (void) constrainToMatchParent;
- (void) constrainToParentwithAttribute:(NSLayoutAttribute) att;
- (void) constrainTo:(UIView *) v2 inside:(UIView *) v withAttribute:(NSLayoutAttribute) att;
- (void) constrainTo:(CGRect) r;

@end
