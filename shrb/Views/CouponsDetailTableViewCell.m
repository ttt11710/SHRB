//
//  CouponsDetailTableViewCell.m
//  shrb
//
//  Created by PayBay on 15/6/8.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "CouponsDetailTableViewCell.h"
#import "CouponsModel.h"

@interface CouponsDetailTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *couponsImageView;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *expirationDateLabel;

@property (weak, nonatomic) IBOutlet UIButton *giveFriendsBtn;

@property (weak, nonatomic) IBOutlet UIButton *giveFriendsOnlyBtn;


@end
@implementation CouponsDetailTableViewCell

- (void)setModel:(CouponsModel *)model
{
    self.couponsImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",model.couponsImage]];
    self.moneyLabel.text = [NSString stringWithFormat:@"金额：%@RMB",model.money];
    self.expirationDateLabel.text = [NSString stringWithFormat:@"截止日期：%@",model.expirationDate];
    
    if (model.canUse) {
        self.giveFriendsOnlyBtn.hidden = YES;
        self.giveFriendsBtn.hidden = NO;
        self.userCouponBtn.hidden = NO;
    }
    else {
        self.giveFriendsBtn.hidden = YES;
        self.userCouponBtn.hidden = YES;
        self.giveFriendsOnlyBtn.hidden = NO;
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
