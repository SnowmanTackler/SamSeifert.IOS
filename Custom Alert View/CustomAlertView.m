//
//  SplitSegue.m
//  R by S
//
//  Created by Sam Seifert on 2/7/15.
//  Copyright (c) 2015 Sam Seifert. All rights reserved.
//

#import "CustomAlertView.h"
#import "SamsMethods.h"
#import "Defines.h"

#ifdef CatMash
#define BackColor ColorPrimaryDark
#define FrontColor [UIColor whiteColor]
#else
#define BackColor [UIColor blackColor]
#define FrontColor [UIColor whiteColor]
#endif

@implementation CustomAlertViewButton

- (id) initWithAction:(alertViewAction) a andName:(NSString*) nm
{
    if (self = [super init])
    {
        self._alertViewAction = a;
        self._text = nm;
        return self;
    }
    return nil;
}

@end

@interface CustomAlertView ()

@property (weak, nonatomic) IBOutlet UILabel * _UILabel;
@property (weak, nonatomic) IBOutlet UIToolbar * _UIToolbar;

@property (weak, nonatomic) IBOutlet UIView * _UIViewSnapper;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint * _NSLayoutConstraintHeight;
@property (weak, nonatomic) IBOutlet UIView * _UIViewBack;

@property (strong, nonatomic) NSArray * _NSArrayButtons;
@property (strong, nonatomic) NSMutableAttributedString * _NSStringMessage;
@end

@implementation CustomAlertView

- (id) initWithArray:(NSArray *) arg andText:(NSString *) text andTitle:(NSString *) ti
{
    if (self = [super init])
    {
        if (ti == nil)
        {
            NSDictionary * di = @{NSFontAttributeName : PrimaryLightFontWithSize(16)};
            self._NSStringMessage =  [[NSMutableAttributedString alloc] initWithString:text
                                                                     attributes:di];
        }
        else
        {
            NSString * c = [NSString stringWithFormat:@"%@\n\n%@", ti, text];
            NSDictionary * di = @{NSFontAttributeName : PrimaryLightFontWithSize(16)};
            self._NSStringMessage =  [[NSMutableAttributedString alloc] initWithString:c
                                                                            attributes:di];
            [self._NSStringMessage addAttribute:NSFontAttributeName
                                          value:PrimaryBoldFontWithSize(24)
                                          range:NSMakeRange(0, ti.length)];
/*            [self._NSStringMessage addAttribute:NSFontAttributeName
                                          value:PrimaryLightFontWithSize(24)
                                          range:NSMakeRange(ti.length + 1, 1)];*/

        }
        self._NSArrayButtons = arg;
        return self;
    }
    return nil;
}

- (UIBarButtonItem *) getSpacerBarButtonItem
{
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                         target:nil
                                                         action:nil];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view setFrame:[UIScreen mainScreen].bounds];
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
    CGRect r = [self._NSStringMessage boundingRectWithSize:CGSizeMake(self._UILabel.frame.size.width, CGFLOAT_MAX)
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
    
    self._NSLayoutConstraintHeight.constant = ceilf(self._NSLayoutConstraintHeight.constant + r.size.height - self._UILabel.frame.size.height);
    
    self._UILabel.attributedText = self._NSStringMessage;
}


- (void) viewDidLoad
{
    [super viewDidLoad];
    
    self._UILabel.text = nil;
    self._UILabel.textColor = [UIColor whiteColor];
    self._UIToolbar.tintColor = BackColor;
    self._UIViewBack.layer.cornerRadius = LinearizeScreenSizeI(5, 10);
    self._UIViewBack.clipsToBounds = YES;
    self._UIViewBack.backgroundColor = ColorPrimary;
    self.view.backgroundColor = [BackColor colorWithAlphaComponent:0.85f];
    
    NSMutableArray * buttons = [[NSMutableArray alloc] init];
    
    [buttons addObject:[self getSpacerBarButtonItem]];
    
    NSInteger tagg = 0;
    for (CustomAlertViewButton * cavb in self._NSArrayButtons)
    {
        if (tagg > 0)
        {
            [buttons addObject:[self getSpacerBarButtonItem]];
            [buttons addObject:[self getSpacerBarButtonItem]];
        }
        
        UIBarButtonItem * uibbi = [[UIBarButtonItem alloc] initWithTitle:cavb._text
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(barButtonPressed:)];
        uibbi.tag = tagg;
        [buttons addObject:uibbi];
        tagg ++;
    }

    [buttons addObject:[self getSpacerBarButtonItem]];
    
    [self._UIToolbar setItems:buttons];
}

- (void) barButtonPressed:(UIBarButtonItem *) butt
{
    CABasicAnimation * animation = [CABasicAnimation animation];
    animation.keyPath = @"opacity";
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.fillMode = kCAFillModeBackwards;
    animation.removedOnCompletion = YES;
    animation.fromValue = @(1);
    animation.toValue = @(0);
    animation.duration = 0.2f;
    [self.view.layer addAnimation:animation forKey:@"mk"];
    self.view.layer.opacity = 0;

    CustomAlertViewButton * cavb = [self._NSArrayButtons objectAtIndex:butt.tag];

    [self performSelector:@selector(disappearWithButton:) withObject:cavb afterDelay:0.2f];
}

- (void) disappearWithButton:(CustomAlertViewButton *) cavb
{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    if (cavb._alertViewAction) cavb._alertViewAction();
}

+ (void) showCustomAlertViewWithMessage:(NSString *) mg
                             andButtons:(NSArray *) bs
                       onViewController:(UIViewController *) vc
{
    [CustomAlertView showCustomAlertViewWithMessage:mg
                                         andButtons:bs
                                   onViewController:vc
                                          withTitle:nil];
}

+ (void) showCustomAlertViewWithMessage:(NSString *) mg
                             andButtons:(NSArray *) bs
                       onViewController:(UIViewController *) vc
                              withTitle:(NSString *) ti
{
    if (vc == nil) vc = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    if (vc == nil) return;
    while (vc.parentViewController) vc = vc.parentViewController;
    
    CustomAlertView * cav = [[CustomAlertView alloc] initWithArray:bs andText:mg andTitle:ti];
    
    CABasicAnimation * animation = [CABasicAnimation animation];
    animation.keyPath = @"opacity";
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.fillMode = kCAFillModeBackwards;
    animation.removedOnCompletion = YES;
    animation.fromValue = @(0);
    animation.toValue = @(1);
    animation.duration = 0.2f;
    [cav.view.layer addAnimation:animation forKey:@"mk"];    

    [vc.view addSubview:cav.view];
    [SamsMethods constrainToMatchParent:cav.view top:YES bot:YES left:YES right:YES];
    [vc addChildViewController:cav];
}

+ (void) showCustomAlertViewWithMessage:(NSString *) mg onViewController:(UIViewController *) vc
{
    CGFloat slide_duration = 0.2f;
    CGFloat show_duration = 3.0f;
    
    if (vc == nil) vc = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    if (vc == nil) return;
    while (vc.parentViewController) vc = vc.parentViewController;
    
    UIView * v = [[UIView alloc] init];
    v.backgroundColor = ColorPrimaryDark;
    UILabel * l = [[UILabel alloc] init];
    l.numberOfLines = 0;
    l.translatesAutoresizingMaskIntoConstraints = NO;
    l.font = PrimaryLightFontWithSize(14);
    l.minimumScaleFactor = 8.0f / l.font.pointSize;
    l.adjustsFontSizeToFitWidth = YES;
    l.textColor = [UIColor whiteColor];
    l.textAlignment = NSTextAlignmentCenter;
    l.text = mg;

    CABasicAnimation * animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.translation.y";
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.fillMode = kCAFillModeBackwards;
    animation.removedOnCompletion = YES;
    animation.fromValue = @(-VertialSpaceBelowNavBar);
    animation.toValue = @(0);
    animation.duration = slide_duration;
    [v.layer addAnimation:animation forKey:@"mk"];
    
    [v addSubview:l];
    [vc.view addSubview:v];
    [SamsMethods constrainToMatchParent:v top:YES bot:NO left:YES right:YES];
    
    [v addConstraint:[NSLayoutConstraint constraintWithItem:v
                                                   attribute:NSLayoutAttributeHeight
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:nil
                                                   attribute:NSLayoutAttributeNotAnAttribute
                                                  multiplier:1
                                                    constant:VertialSpaceBelowNavBar]];

    [v addConstraint:[NSLayoutConstraint constraintWithItem:l
                                                  attribute:NSLayoutAttributeLeading
                                                  relatedBy:NSLayoutRelationEqual
                                                     toItem:v
                                                  attribute:NSLayoutAttributeLeading
                                                 multiplier:1
                                                   constant:10]];

    [v addConstraint:[NSLayoutConstraint constraintWithItem:v
                                                  attribute:NSLayoutAttributeTrailing
                                                  relatedBy:NSLayoutRelationEqual
                                                     toItem:l
                                                  attribute:NSLayoutAttributeTrailing
                                                 multiplier:1
                                                   constant:10]];
    
    [v addConstraint:[NSLayoutConstraint constraintWithItem:l
                                                  attribute:NSLayoutAttributeTop
                                                  relatedBy:NSLayoutRelationEqual
                                                     toItem:v
                                                  attribute:NSLayoutAttributeTop
                                                 multiplier:1
                                                   constant:25]];
    
    [v addConstraint:[NSLayoutConstraint constraintWithItem:v
                                                  attribute:NSLayoutAttributeBottom
                                                  relatedBy:NSLayoutRelationEqual
                                                     toItem:l
                                                  attribute:NSLayoutAttributeBottom
                                                 multiplier:1
                                                   constant:5]];

    [v performSelector:@selector(slideUp:) withObject:@(slide_duration) afterDelay:show_duration + slide_duration];
}

@end

@implementation UIView (CustomAlertView)

- (void) slideUp:(NSNumber *) duration

{
    CABasicAnimation * animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.translation.y";
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.fillMode = kCAFillModeBoth;
    animation.removedOnCompletion = NO;
    animation.fromValue = @(0);
    animation.toValue = @(-VertialSpaceBelowNavBar);
    animation.duration = duration.floatValue;
    [self.layer addAnimation:animation forKey:@"mk"];

    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:duration.floatValue];
}

@end

