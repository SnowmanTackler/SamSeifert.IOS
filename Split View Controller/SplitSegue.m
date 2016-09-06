//
//  SplitSegue.m
//  R by S
//
//  Created by Sam Seifert on 2/7/15.
//  Copyright (c) 2015 Sam Seifert. All rights reserved.
//

#import "SplitSegue.h"
#import "SplitViewController.h"

@implementation SplitSegue

- (void) perform
{
    id ncv = [self.sourceViewController navigationController];
    [ncv setupViewController:self.destinationViewController animated:!self._BoolInstant];
}

@end
