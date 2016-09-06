//
//  StaticMethods.m
//  R by S
//
//  Created by Sam Seifert on 11/19/14.
//  Copyright (c) 2014 Sam Seifert. All rights reserved.
//

#import "SamsMethods.h"

@implementation SamsMethods

+ (void) constrainToMatchParent:(UIView *) v top:(BOOL) top bot:(BOOL) bot left:(BOOL) left right:(BOOL) right
{
    v.translatesAutoresizingMaskIntoConstraints = NO;
    if (top) [SamsMethods constrain:v toParentwithAttribute:NSLayoutAttributeTop];
    if (bot) [SamsMethods constrain:v toParentwithAttribute:NSLayoutAttributeBottom];
    if (left) [SamsMethods constrain:v toParentwithAttribute:NSLayoutAttributeLeft];
    if (right) [SamsMethods constrain:v toParentwithAttribute:NSLayoutAttributeRight];
}

+ (void) constrainToMatchParent:(UIView *) v
{
    [SamsMethods constrainToMatchParent:v top:YES bot:YES left:YES right:YES];
}


+ (void) constrain:(UIView *) v toParentwithAttribute:(NSLayoutAttribute) att
{
    [SamsMethods constrain:v to:[v superview] inside:[v superview] withAttribute:att];
}

+ (void) constrain:(UIView *) v1 to:(UIView *) v2 inside:(UIView *) v withAttribute:(NSLayoutAttribute) att
{
    [v addConstraint:[NSLayoutConstraint constraintWithItem:v1
                                                  attribute:att
                                                  relatedBy:NSLayoutRelationEqual
                                                     toItem:v2
                                                  attribute:att
                                                 multiplier:1.0f
                                                   constant:0]];
}

+ (void) constrain:(UIView *) v to:(CGRect) r
{
    v.translatesAutoresizingMaskIntoConstraints = NO;
    
    [v setFrame:r];
    
    [[v superview] addConstraint:[NSLayoutConstraint constraintWithItem:v
                                                              attribute:NSLayoutAttributeLeft
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:[v superview]
                                                              attribute:NSLayoutAttributeLeft
                                                             multiplier:1.0f
                                                               constant:r.origin.x]];
    
    [[v superview] addConstraint:[NSLayoutConstraint constraintWithItem:v
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:[v superview]
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1.0f
                                                               constant:r.origin.y]];
    
    [v addConstraint:[NSLayoutConstraint constraintWithItem:v
                                                  attribute:NSLayoutAttributeWidth
                                                  relatedBy:NSLayoutRelationEqual
                                                     toItem:nil
                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                 multiplier:1
                                                   constant:r.size.width]];
    
    [v addConstraint:[NSLayoutConstraint constraintWithItem:v
                                                  attribute:NSLayoutAttributeHeight
                                                  relatedBy:NSLayoutRelationEqual
                                                     toItem:nil
                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                 multiplier:1
                                                   constant:r.size.height]];
}

+ (NSInteger) daysBetween:(NSDate *)dt1 and:(NSDate *)dt2 {
    NSUInteger unitFlags = NSCalendarUnitDay;
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents * components = [calendar components:unitFlags fromDate:dt1 toDate:dt2 options:0];
    return [components day];
}

+ (unsigned long long int)folderSize:(NSString *) fp
{
    NSArray * fa = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:fp error:nil];
    NSEnumerator * fe = [fa objectEnumerator];
    NSString * fn;
    unsigned long long int fileSize = 0;
    
    while (fn = [fe nextObject]) {
        NSDictionary * fileDictionary = [[NSFileManager defaultManager] attributesOfItemAtPath:[fp stringByAppendingPathComponent:fn] error:nil];
        fileSize += [fileDictionary fileSize];
    }
    
    return fileSize;
}

@end
