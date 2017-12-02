//
//  UILabel_Sam.m
//
//  Created by Sam Seifert on 4/26/14.
//  Copyright (c) 2014 Sam Seifert. All rights reserved.
//

#import "UILabel_Sam.h"

@implementation UILabel (extensions_sam)

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

    // Change to quick search!

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
