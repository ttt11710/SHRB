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

@interface HotFocusTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *hotImageView;
@property (weak, nonatomic) IBOutlet UIButton *memberBtn;

@end
@implementation HotFocusTableViewCell

- (void)setModel:(HotFocusModel *)model
{
    [self.memberBtn setTitle:model.status forState:UIControlStateNormal];
    self.hotImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",model.storeName]];
}

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];   // THIS IS NECESSARY!
    [self customSetup];
}

- (void)customSetup
{
    // Even though defaults values are cool, I'm setting all of the customizable options here as an example:
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
