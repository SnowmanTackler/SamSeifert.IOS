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

@implementation UITextView (missingFunctions)

- (NSString *) fontName
{
    return self.font.fontName;
}

- (void) setFontName:(NSString *) fontName
{
    self.font = [UIFont fontWithName:fontName size:self.font.pointSize];
}

- (void) centerVerticallyWithMinInsets:(UIEdgeInsets)minInsets shouldScroll:(BOOL)force_scroll_to_zero
{
    // verfied contentSize includes textContainerInset on 2017/11/01
    CGFloat text_height = self.contentSize.height - self.textContainerInset.top - self.textContainerInset.bottom;
    
    NSInteger space_bottom = minInsets.bottom;
    NSInteger space_top = minInsets.top; // Including Extra Status Bar (20)
    
    CGFloat dif = self.frame.size.height - (text_height + space_top + space_bottom);
    
    if (dif > 0) // This code will center text vertically if it's small enough
    {
        space_top += dif / 2;
        space_bottom += dif / 2;
    }
    
    UIEdgeInsets s = UIEdgeInsetsMake(space_top, minInsets.left, space_bottom, minInsets.right);
    
    if (force_scroll_to_zero || !UIEdgeInsetsEqualToEdgeInsets(s, self.textContainerInset)) // Only update if new!
    {
        [self setContentOffset:CGPointZero animated:NO];
        [self setTextContainerInset:s];
        // [tv scrollRangeToVisible:NSMakeRange(0, 0)];
    }
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

