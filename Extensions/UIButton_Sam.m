//
//  UIButton_Sam.m
//
//  Created by Sam Seifert on 4/26/14.
//  Copyright (c) 2014 Sam Seifert. All rights reserved.
//

#import "UIButton_Sam.h"

@implementation UIButton (extensions_sam)

- (NSString *) fontName
{
    return self.titleLabel.font.fontName;
}

- (void) setFontName:(NSString *) fontName
{
    self.titleLabel.font = [UIFont fontWithName:fontName size:self.titleLabel.font.pointSize];
}

@end


