//
//  UIViewController_Sam.m
//
//  Created by Sam Seifert on 4/26/14.
//  Copyright (c) 2014 Sam Seifert. All rights reserved.
//

#import "UIViewController_Sam.h"

@implementation UIViewController (extensions_sam)

- (void) pushBack
{
    [[self navigationController] popViewControllerAnimated:YES];
}

- (IBAction) pushBack:(UIBarButtonItem *)sender
{
    [self pushBack];
}

/*
- (void) displayActivityViewController:(UIActivityViewController *) activityVC fromView:(UIBarButtonItem *) v
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        [self presentViewController:activityVC animated:YES completion:nil];
    }
    else
    {
        // Change Rect to position Popover
        UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:activityVC];

        if (v)
        {
            [popup presentPopoverFromBarButtonItem:v permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
        else
        {
            [popup presentPopoverFromRect:CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/4, 0, 0)
                                   inView:self.view
                 permittedArrowDirections:UIPopoverArrowDirectionAny
                                 animated:YES];
        }
    }
}
 */


@end
