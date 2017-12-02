//
//  DictionarySegue.m
//  Read by Sound
//
//  Created by Sam Seifert on 2/8/15.
//  Copyright (c) 2015 Sam Seifert. All rights reserved.
//

#import "FadeInSegue.h"
#import "SamsMethods.h"

@implementation FadeInSegue

- (void) perform
{
    UIView * uiv = [self.destinationViewController view];
    CABasicAnimation * animation = [CABasicAnimation animation];
    animation.keyPath = @"opacity";
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.fillMode = kCAFillModeBackwards;
    animation.removedOnCompletion = YES;
    animation.fromValue = @(0);
    animation.toValue = @(1);
    animation.duration = 0.25f;
    [uiv.layer addAnimation:animation forKey:@"mk"];
    
    UIView * parent = [self.sourceViewController view];
    while (parent.superview) parent = parent.superview;
    [parent addSubview:uiv];
    [SamsMethods constrainToMatchParent:uiv top:YES bot:YES left:YES right:YES];
    [self.sourceViewController addChildViewController:self.destinationViewController];    
}

@end
