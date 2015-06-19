//
//  CardTableViewCell.m
//  shrb
//
//  Created by PayBay on 15/5/20.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "CardTableViewCell.h"
#import "CardModel.h"

@interface CardTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIImageView *memberCardImageView;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *integralLabel;

@end
@implementation CardTableViewCell

- (void)setModel:(CardModel *)model
{
    self.memberCardImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",model.memberCardImage]];
    self.moneyLabel.text = [NSString stringWithFormat:@"金额：%@元",model.money];
    self.cardNumberLabel.text = [NSString stringWithFormat:@"卡号：%@",model.cardNumber];
    self.integralLabel.text =[NSString stringWithFormat:@"积分：%@",model.integral];
}

- (void)awakeFromNib {
    // Initialization code
    self.backView.layer.cornerRadius = 10;
    self.backView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
