//
//  ReceiveCardTableViewCell.m
//  shrb
//
//  Created by PayBay on 15/6/30.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "ReceiveCouponsTableViewCell.h"
#import "CouponsModel.h"


@interface ReceiveCouponsTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *couponsImageView;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@end

@implementation ReceiveCouponsTableViewCell

- (void)setModel:(CouponsModel *)model
{
    self.couponsImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",model.couponsImage]];
    self.moneyLabel.text = [NSString stringWithFormat:@"总金额：%@元",model.money];
    self.numberLabel.text = [NSString stringWithFormat:@"%@张",model.count];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
