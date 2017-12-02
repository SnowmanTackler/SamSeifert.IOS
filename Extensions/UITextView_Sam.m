//
//  UITextView_Sam.m
//
//  Created by Sam Seifert on 4/26/14.
//  Copyright (c) 2014 Sam Seifert. All rights reserved.
//

#import "UITextView_Sam.h"

@implementation UITextView (extensions_sam)

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
