//
//  UILabel_CustomFont.h
//
//  Created by Sam Seifert on 4/26/14.
//  Copyright (c) 2014 Sam Seifert. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (TCCustomFont)

@property (nonatomic, copy) NSString* fontName;

- (void) setFontSizeToFillHeight;

@end

@interface UIButton (TCCustomFont)

@property (nonatomic, copy) NSString * fontName;

@end

@interface NSDate (missingFunctions)

+ (NSDate *) dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;

@end

@interface UIViewController (missingFunctions)

- (void) pushBack;
- (IBAction) pushBack:(UIBarButtonItem *)sender;
- (void) displayActivityViewController:(UIActivityViewController *) activityVC fromView:(UIBarButtonItem *) v;

@end

@interface UIScrollView (missingFunctions)

- (void) tapWith:(UITapGestureRecognizer *) recognizer;

@end