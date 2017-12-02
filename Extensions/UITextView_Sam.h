//
//  UITextView_Sam.h
//
//  Created by Sam Seifert on 4/26/14.
//  Copyright (c) 2014 Sam Seifert. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (extensions_sam)

@property (nonatomic, copy) NSString * fontName;
- (void) centerVerticallyWithMinInsets:(UIEdgeInsets)minInsets shouldScroll:(BOOL)force_scroll_to_zero;

@end