//
//  MODropAlertView.m
//  MODropAlertDemo
//
//  Created by Ahn JungMin on 2014. 7. 1..
//  Copyright (c) 2014년 Ahn JungMin. All rights reserved.
//

#import "MODropAlertView.h"
#import "UIImage+ImageEffects.h"

static NSString* kAlertOKButtonNormalColor = @"#5677fc";
static NSString* kAlertOKButtonHighlightColor = @"#2a36b1";
static NSString* kAlertCancelButtonNormalColor = @"#e51c23";
static NSString* kAlertCancelButtonHighlightColor = @"#b0120a";

@implementation MODropAlertView {
  
@private
    UIImageView *backgroundView;
    UIView *alertView;
    DropAlertViewType kType;
    blk successBlockCallback;
    blk failureBlockCallback;
}

#pragma mark - Initialized Drop Alert Methods
- (instancetype)initDropAlertWithmovieView:(UIView *)movieView
{
    _movieView = [[UIView alloc] init];
    _movieView = movieView;
    self = [super init];
    if (self) {
        [self initDropAlert];
    }
    return self;
}

- (void)initDropAlert
{
    self.frame = self.movieView.frame;
    self.opaque = YES;
    self.backgroundColor = [UIColor clearColor];
    
    [self makeBackgroundBlur];
    [self makeAlertPopupView];
    
    [self moveAlertPopupView];
}

#pragma mark - View Layout Methods
- (void)makeBackgroundBlur
{
    backgroundView = [[UIImageView alloc]initWithFrame:self.movieView.frame];
    
    UIImage *image = [UIImage convertViewToImage];
    UIImage *blurSnapshotImage = nil;
    blurSnapshotImage = [image applyBlurWithRadius:5.0
                                         tintColor:[UIColor colorWithWhite:0.2
                                                                     alpha:0.7]
                             saturationDeltaFactor:1.8
                                         maskImage:nil];
    
    backgroundView.image = blurSnapshotImage;
    backgroundView.alpha = 0;
    
    [self addSubview:backgroundView];
}

- (void)makeAlertPopupView
{
    CGRect frame = _movieView.frame;
    CGRect screen = self.movieView.frame;
    
    alertView = [[UIView alloc]initWithFrame:frame];
    
    alertView.center = CGPointMake(CGRectGetWidth(screen)/2, CGRectGetHeight(screen)/2);
    
    alertView.layer.masksToBounds = YES;
    alertView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:1.0f];
    alertView.layer.borderColor = [UIColor colorWithRed:249.0/255.0 green:72.0/255.0 blue:119.0/255.0 alpha:1].CGColor;
    alertView.layer.borderWidth = 2;

    [alertView addSubview:_movieView];
    [self addSubview:alertView];
}

#pragma mark - View Animation Methods
- (void)moveAlertPopupView
{
    CGRect screen = self.movieView.frame;
    CATransform3D move = CATransform3DIdentity;
    CGFloat initAlertViewYPosition = (CGRectGetHeight(screen) + CGRectGetHeight(alertView.frame)) / 2;
    
    move = CATransform3DMakeTranslation(0, -initAlertViewYPosition, 0);
    move = CATransform3DRotate(move, 40 * M_PI/180, 0, 0, 1.0f);
    
    alertView.layer.transform = move;
}

- (void)show
{
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
    
    if( [self.delegate respondsToSelector:@selector(alertViewWillAppear:)] ) {
        [self.delegate alertViewWillAppear:self];
    }
    
    [self showAnimation];
}

- (void)showAnimation
{
    [UIView animateWithDuration:0.3f animations:^{
        backgroundView.alpha = 1.0f;
    }];
    
    
    [UIView animateWithDuration:1.0f
                          delay:0.0f
         usingSpringWithDamping:0.4f
          initialSpringVelocity:0.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         CATransform3D init = CATransform3DIdentity;
                         alertView.layer.transform = init;
                         
                     }
                     completion:^(BOOL finished) {
                         if( [self.delegate respondsToSelector:@selector(alertViewDidAppear:)] && finished) {
                             [self.delegate alertViewDidAppear:self];
                         }
                     }];
}

- (void)dismiss:(DropAlertButtonType)buttonType
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(alertViewWilldisappear:buttonType:)] ) {
        [self.delegate alertViewWilldisappear:self buttonType:buttonType];
    }
    [self dismissAnimation:buttonType];
}

- (void)dismissAnimation:(DropAlertButtonType)buttonType
{
    blk cb;
    switch (buttonType) {
        case DropAlertButtonOK:
            successBlockCallback ? cb = successBlockCallback: nil;
            break;
        case DropAlertButtonFail:
            failureBlockCallback ? cb = failureBlockCallback: nil;
        default:
            break;
    }
    [UIView animateWithDuration:0.8f
                          delay:0.0f
         usingSpringWithDamping:1.0f
          initialSpringVelocity:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         CGRect screen = self.movieView.frame;
                         CATransform3D move = CATransform3DIdentity;
                         CGFloat initAlertViewYPosition = CGRectGetHeight(screen);
                         
                         move = CATransform3DMakeTranslation(0, initAlertViewYPosition, 0);
                         move = CATransform3DRotate(move, -40 * M_PI/180, 0, 0, 1.0f);
                         alertView.layer.transform = move;
                         
                         backgroundView.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                         if (cb) {
                             cb();
                         }
                         else if (self.delegate && [self.delegate respondsToSelector:@selector(alertViewDidDisappear:buttonType:)] && finished) {
                             [self.delegate alertViewDidDisappear:self buttonType:buttonType];
                         }
                     }];
    
}

#pragma mark - Util Methods
- (CGRect)mainScreenFrame
{
    return [UIScreen mainScreen].bounds;
}

- (void)setShadowLayer:(CALayer *)layer
{
    layer.shadowOffset = CGSizeMake(1, 1);
    layer.shadowRadius = 0.6;
    layer.shadowOpacity = 0.3;
}

- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

@end