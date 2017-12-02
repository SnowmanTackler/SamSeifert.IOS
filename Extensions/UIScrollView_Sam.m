//
//  UIScrollView_Sam.m
//
//  Created by Sam Seifert on 4/26/14.
//  Copyright (c) 2014 Sam Seifert. All rights reserved.
//

#import "UIScrollView_Sam.h"

@implementation UIScrollView (extensions_sam)

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

