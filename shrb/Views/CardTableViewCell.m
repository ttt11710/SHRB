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

@property (weak, nonatomic) IBOutlet UIView *shadowView;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
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
    self.integralLabel.text =[NSString stringWithFormat:@"积分：%@分",model.integral];
    self.backImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",model.backCardImage]];
}

- (void)awakeFromNib {
    // Initialization code
    
    
    self.shadowView.layer.cornerRadius = 10;
    self.shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.shadowView.layer.shadowOffset = CGSizeMake(2,2);
    self.shadowView.layer.shadowOpacity = 0.5;
    self.shadowView.layer.shadowRadius = 2.0;
    
    self.backImageView.layer.cornerRadius = 10;
    self.backImageView.layer.masksToBounds = YES;
    
    self.memberCardImageView.layer.cornerRadius = 10;
    self.memberCardImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
