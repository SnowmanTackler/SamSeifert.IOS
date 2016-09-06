//
//  UITableViewControllerSplitParent.h
//  Read by Sound
//
//  Created by Sam Seifert on 2/8/15.
//  Copyright (c) 2015 Sam Seifert. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SplitViewControllerParent : UIViewController

#define ScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define ScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define isIpadOrBigger ([UIScreen mainScreen].bounds.size.width >= 768)
#define isSideways UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)

- (UINavigationController *) getLeftmostNavController;

@end
