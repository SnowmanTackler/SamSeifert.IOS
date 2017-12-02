//
//  UIViewController_Sam.m
//
//  Created by Sam Seifert on 4/26/14.
//  Copyright (c) 2014 Sam Seifert. All rights reserved.
//

#import "UIViewController_Sam.h"

@implementation UIView (extensions_sam)

- (void) constrainToMatchParent_top:(BOOL) top bot:(BOOL) bot left:(BOOL) left right:(BOOL) right
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    if (top) [self constrainToParentwithAttribute:NSLayoutAttributeTop];
    if (bot) [self constrainToParentwithAttribute:NSLayoutAttributeBottom];
    if (left) [self constrainToParentwithAttribute:NSLayoutAttributeLeft];
    if (right) [self constrainToParentwithAttribute:NSLayoutAttributeRight];
}

- (void) constrainToMatchParent
{
    [self constrainToMatchParent_top:YES bot:YES left:YES right:YES];
}

- (void) constrainToParentwithAttribute:(NSLayoutAttribute) att
{
    [self constrainTo:[self superview] inside:[self superview] withAttribute:att];
}

- (void) constrainTo:(UIView *) v2 inside:(UIView *) v withAttribute:(NSLayoutAttribute) att
{
    [v addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                  attribute:att
                                                  relatedBy:NSLayoutRelationEqual
                                                     toItem:v2
                                                  attribute:att
                                                 multiplier:1.0f
                                                   constant:0]];
}

- (void) constrainTo:(CGRect) r
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self setFrame:r];
    
    UIView * soup = [self superview];
    [soup addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:soup
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0f
                                                      constant:r.origin.x]];
    
    [soup addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:soup
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0f
                                                      constant:r.origin.y]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1
                                                   constant:r.size.width]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1
                                                      constant:r.size.height]];
}

@end
