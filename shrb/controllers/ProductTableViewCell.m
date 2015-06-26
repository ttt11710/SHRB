//
//  ProductTableViewCell.m
//  shrb
//
//  Created by PayBay on 15/6/26.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "ProductTableViewCell.h"
#import "ProductModel.h"
#import <BFPaperButton.h>
#import "Const.h"

@interface ProductTableViewCell ()


@property (weak, nonatomic) IBOutlet UILabel *saveMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet BFPaperButton *signInBtn;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *integralLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardNumberLabel;


@end
@implementation ProductTableViewCell

- (void)setModel:(ProductModel *)model
{
    self.tradeImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",model.tradeImage]];
    
    self.saveMoneyLabel.text = [NSString stringWithFormat:@"省￥%@元",model.saveMoney];
    self.descriptionLabel.text = model.tradeDescription;
    self.moneyLabel.text = [NSString stringWithFormat:@"金额：%@元",model.money];
    self.integralLabel.text = [NSString stringWithFormat:@"积分：%@",model.integral];
    self.cardNumberLabel.text = [NSString stringWithFormat:@"卡号：%@",model.cardNumber];

}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.tradeImageView.layer.cornerRadius = 10;
    self.tradeImageView.layer.masksToBounds = YES;
}

#pragma mark - 蒙版效果
- (void)addBlurViewView:(UIView *)view
{
    if (IsIOS8) {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurEffectView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        blurEffectView.frame = CGRectMake(0, view.frame.size.width-45, view.frame.size.width, 45);
        [view insertSubview:blurEffectView atIndex:0];
    }
    else{
        UIView *blurEffectView = [[UIView alloc] init];
        blurEffectView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        blurEffectView.frame = CGRectMake(0, view.frame.size.height-45, view.frame.size.width, 45);
        [view insertSubview:blurEffectView atIndex:0];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
