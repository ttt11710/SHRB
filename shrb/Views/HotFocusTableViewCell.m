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
#import "SVProgressShow.h"
#import "Store.h"

@interface HotFocusTableViewCell () 
{
    NSMutableArray *_arr;
    NSMutableArray *_imageArr;
}


@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;


@end
@implementation HotFocusTableViewCell

- (void)setModel:(Store *)model
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
    
//    self.usesSmartColor = NO;
//    self.tapCircleDiameter = bfPaperTableViewCell_tapCircleDiameterFull;
//    self.rippleFromTapLocation = YES;
//    self.backgroundFadeColor = [UIColor colorWithWhite:1 alpha:0.2f];
//    self.letBackgroundLinger = YES;
//    
//    self.tapCircleColor = [UIColor colorWithRed:253.0/255.0 green:99.0/255.0 blue:93.0/255.0 alpha:0.5];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
