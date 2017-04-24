//
//  sdgadsgasdg.m
//
//  Created by Sam Seifert on 4/26/14.
//  Copyright (c) 2014 Sam Seifert. All rights reserved.
//

#import "Extensions.h"

@implementation UILabel (TCCustomFont)

- (NSString *) fontName
{
    return self.font.fontName;
}

- (void) setFontName:(NSString *) fontName
{
    self.font = [UIFont fontWithName:fontName size:self.font.pointSize];
}

- (void) setFontSizeToFillHeight
{
    if (self.text == nil) return;
    
    NSInteger font_height = 8;
    
    CGSize ns = CGSizeZero;
    
    while (ns.height < self.frame.size.height)
    {
        font_height ++;
        ns = [self.text sizeWithAttributes: @{NSFontAttributeName:[UIFont fontWithName:self.font.fontName size:font_height]}];
    }
    
    font_height--;
    
    self.font = [UIFont fontWithName:self.font.fontName size:font_height];
}

@end

@implementation UIButton (TCCustomFont)

- (NSString *) fontName
{
    return self.titleLabel.font.fontName;
}

- (void) setFontName:(NSString *) fontName
{
    self.titleLabel.font = [UIFont fontWithName:fontName size:self.titleLabel.font.pointSize];
}

@end

@implementation NSDate (missingFunctions)

+ (NSDate *) dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:year];
    [components setMonth:month];
    [components setDay:day];
    return [calendar dateFromComponents:components];
}

@end

@implementation UIViewController (missingFunctions)

- (void) pushBack
{
    [[self navigationController] popViewControllerAnimated:YES];
}

- (IBAction) pushBack:(UIBarButtonItem *)sender
{
    [self pushBack];
}

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


@end

@implementation UIScrollView (missingFunctions)

- (void) tapWith:(UITapGestureRecognizer *) recognizer;
{
    if (self.zoomScale > self.minimumZoomScale)
    {
        [self setZoomScale:self.minimumZoomScale animated:YES];
    }
    else
    {
        CGPoint touch = [recognizer locationInView:recognizer.view];
        
        CGSize scrollViewSize = self.bounds.size;
        
        CGFloat w = scrollViewSize.width / self.maximumZoomScale;
        CGFloat h = scrollViewSize.height / self.maximumZoomScale;
        CGFloat x = touch.x-(w/2.0);
        CGFloat y = touch.y-(h/2.0);
        
        [self zoomToRect:CGRectMake(x, y, w, h) animated:YES];
    }
}


@end
