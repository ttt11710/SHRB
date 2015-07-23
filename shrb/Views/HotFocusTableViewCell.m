//
//  HotMembersTableViewCell.m
//  shrb
//
//  Created by PayBay on 15/5/20.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "HotFocusTableViewCell.h"
#import "UIColor+BFPaperColors.h"
#import "HotFocusModel.h"
#import "Const.h"
#import <QuartzCore/CoreAnimation.h>


@interface myImageView : UIImageView
{
    NSInteger  _currentInt;
    NSMutableArray *_imageArr;
  //  CAGradientLayer *_gradientLayer;
  //  UIView *_containerView;
    CGRect _oldframe;
}
@property(assign, readwrite, nonatomic)NSInteger currentInt;
@property(readwrite, nonatomic)NSMutableArray *imageArr;

@end

@implementation myImageView


- (void)setCurrentInt:(NSInteger)currentInt
{
    _currentInt = currentInt;
}

- (void)initImageArr
{
    _imageArr = [[NSMutableArray alloc] init];
    
}

- (void)beginAnimation
{
//    _gradientLayer = [CAGradientLayer layer];
//    _gradientLayer.frame = CGRectMake(0, 0,screenWidth*2 , 250);
//    _gradientLayer.colors = @[(__bridge id)[UIColor blackColor].CGColor,
//                             (__bridge id)[UIColor colorWithWhite:0.1 alpha:0.8].CGColor,
//                             (__bridge id)[UIColor blackColor].CGColor,
//                             ];
//    _gradientLayer.locations = @[@(0.4),@(0.5),@(0.6)];
//    _gradientLayer.startPoint = CGPointMake(0, 0);
//    _gradientLayer.endPoint = CGPointMake(1, 0);
//    
//    
//    _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,screenWidth*2 , 250)];
//    [_containerView.layer addSublayer:_gradientLayer];
//    
//    if (IsIOS8) {
//       // self.maskView = _containerView;
//        _oldframe= _containerView.frame;
//        _oldframe.origin.x -=screenWidth;
//        _containerView.frame = _oldframe;
//        
//    }

    
    self.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[_imageArr objectAtIndex:_currentInt]]];
    
    [self timeForShowImage];
}


- (void)timeForShowImage
{
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(nextImage) object:nil];
    [self performSelector:@selector(nextImage)
               withObject:nil
               afterDelay:(arc4random() % 3)+3];
}

- (void)nextImage
{
    _currentInt++;
    if (_currentInt == [_imageArr count]) {
        _currentInt = 0;
    }
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[_imageArr objectAtIndex:_currentInt]]];
    CABasicAnimation *contentsAnimation = [CABasicAnimation animationWithKeyPath:@"contents"];
    contentsAnimation.fromValue = self;
    contentsAnimation.toValue = (__bridge id)(image.CGImage);
    contentsAnimation.duration = 1.f;
    contentsAnimation.delegate = self;
    contentsAnimation.fillMode=kCAFillModeForwards;
    contentsAnimation.removedOnCompletion = NO;
    [self.layer addAnimation:contentsAnimation forKey:nil];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self timeForShowImage];
}

@end


@interface HotFocusTableViewCell () 
{
    NSMutableArray *_arr;
    NSMutableArray *_imageArr;
}

@property (weak, nonatomic) IBOutlet UIView *shadowView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *storeLabelImage;

@end
@implementation HotFocusTableViewCell

- (void)setModel:(HotFocusModel *)model
{
//    // load all the frames of our animation
    _arr = [[NSMutableArray alloc] init];
    for (NSString *str in model.images) {
        [_arr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%@",str]]];
    }
    _imageArr = [[NSMutableArray alloc] init];
    for (NSString *str in model.images) {
        [_imageArr addObject:str];
    }
    
    self.descriptionLabel.text = model.simpleStoreDetail;
    
    self.storeLabelImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",model.storeLabel]];
    self.storeLabelImage.contentMode = UIViewContentModeCenter;
//    
//    
//    self.hotImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",_imageArr[0]]];
//
//    self.hotImageView.animationImages = [_arr copy];
//    
//    // all frames will execute in 1.75 seconds
//    self.hotImageView.animationDuration = (arc4random() % 10) + 10;
//    // repeat the annimation forever
//    self.hotImageView.animationRepeatCount = 0;
    
    
    
    
    self.hotImageView.currentInt = 0;
    [self.hotImageView initImageArr];
    self.hotImageView.imageArr = _imageArr;
    [self.hotImageView beginAnimation];
    
    
    
}


- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];   // THIS IS NECESSARY!
    [self customSetup];
}

- (void)customSetup
{
    self.shadowView.layer.cornerRadius = 5;
    self.shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.shadowView.layer.shadowOffset = CGSizeMake(2,2);
    self.shadowView.layer.shadowOpacity = 0.5;
    self.shadowView.layer.shadowRadius = 2.0;
    
    self.hotImageView.layer.cornerRadius = 5;
    self.hotImageView.layer.masksToBounds = YES;
    
    self.usesSmartColor = NO;
    self.tapCircleDiameter = bfPaperTableViewCell_tapCircleDiameterFull;
    self.rippleFromTapLocation = YES;
    self.backgroundFadeColor = [UIColor colorWithWhite:1 alpha:0.2f];
    self.letBackgroundLinger = YES;
    
    self.tapCircleColor = [UIColor colorWithRed:253.0/255.0 green:99.0/255.0 blue:93.0/255.0 alpha:0.5];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
