//
//  CouponsDetailTableViewCell.m
//  shrb
//
//  Created by PayBay on 15/6/8.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "CouponsDetailTableViewCell.h"
#import "CouponsModel.h"
#import "NSString+AttributedStyle.h"
#import "Const.h"

@interface CouponsDetailTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *redPacketImageView;
@property (weak, nonatomic) IBOutlet UIImageView *couponsImageView;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *expirationDateLabel;


@property (weak, nonatomic) IBOutlet UIButton *giveFriendsOnlyBtn;


@end
@implementation CouponsDetailTableViewCell

- (void)setModel:(CouponsModel *)model
{
    self.couponsImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",model.couponsImage]];
    
    NSString *string = [NSString stringWithFormat:@"￥%@RMB",model.money];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:251.0/255.0 green:102.0/255.0 blue:49.0/255.0 alpha:1] range:NSMakeRange(0, string.length)];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:34] range:NSMakeRange(1, string.length-1)];
    self.moneyLabel.attributedText = attrString;

    
    self.expirationDateLabel.text = [NSString stringWithFormat:@"有效期至:%@",model.expirationDate];
    
    if (!model.canUse) {
        [self.userCouponBtn setTitleColor:shrbLightText forState:UIControlStateNormal];
        self.userCouponBtn.userInteractionEnabled = NO;
        self.redPacketImageView.hidden = YES;
    }
    else {
        [self.userCouponBtn setTitleColor:shrbText forState:UIControlStateNormal];
        self.userCouponBtn.userInteractionEnabled = YES;
        self.redPacketImageView.hidden = NO;
    }
}

- (void)awakeFromNib {
    
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
