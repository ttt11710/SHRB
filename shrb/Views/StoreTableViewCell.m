//
//  CouponsTableViewCell.m
//  shrb
//
//  Created by PayBay on 15/5/20.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "StoreTableViewCell.h"
#import "TradeModel.h"
#import "Const.h"
#import "NSString+AttributedStyle.h"
#import "OrderModel.h"
#import "CallBackButton.h"


@interface StoreTableViewCell ()

@end


@implementation StoreTableViewCell

- (void)setModel:(TradeModel *)model
{
    self.tradeNameLabel.text = model.tradeName;
//    self.tradeImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",model.tradeImage]];
    
    self.tradeImageView.image = [UIImage imageNamed:@"官方头像"];
    
    self.tradeDescriptionLabel.text = model.tradeDescription;
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@ 原价￥%@",model.memberPrice,model.originalPrice]];
    
    [attrString addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(model.memberPrice.length + 2, model.originalPrice.length+3)];//删除线
    [attrString addAttribute:NSForegroundColorAttributeName value:shrbPink range:NSMakeRange(0, model.memberPrice.length + 1)];
    [attrString addAttribute:NSForegroundColorAttributeName value:shrbLightText range:NSMakeRange(model.memberPrice.length + 2, model.originalPrice.length+3)];
    
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, model.memberPrice.length + 1)];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(model.memberPrice.length + 2, model.originalPrice.length+3)];
    
    self.priceLabel.attributedText = attrString;
    
    [self.afterSaleButton setupBlock];
}

- (void)setOrderModel:(OrderModel *)orderModel
{
    self.tradeNameLabel.text = orderModel.tradeName;
    self.tradeImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",orderModel.tradeImage]];
    
    self.tradeDescriptionLabel.text = orderModel.tradeDescription;
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@ 原价￥%@",orderModel.memberPrice,orderModel.originalPrice]];
    
    [attrString addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(orderModel.memberPrice.length + 2, orderModel.originalPrice.length+3)];//删除线
    [attrString addAttribute:NSForegroundColorAttributeName value:shrbPink range:NSMakeRange(0, orderModel.memberPrice.length + 1)];
    [attrString addAttribute:NSForegroundColorAttributeName value:shrbLightText range:NSMakeRange(orderModel.memberPrice.length + 2, orderModel.originalPrice.length+3)];
    
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, orderModel.memberPrice.length + 1)];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(orderModel.memberPrice.length + 2, orderModel.originalPrice.length+3)];
    
    self.priceLabel.attributedText = attrString;
    
    self.amountTextField.text =  orderModel.amount;
    self.moneyLabel.text = [NSString stringWithFormat:@"￥%@",orderModel.money];
}

- (void)awakeFromNib {
    // Initialization code
    self.tradeImageView.layer.cornerRadius = 10;
    self.tradeImageView.layer.masksToBounds = YES;
    self.tradeImageView.layer.borderColor = shrbPink.CGColor;
    self.tradeImageView.layer.borderWidth = 1;
    
    self.MemberLabel.layer.cornerRadius = 12;
    self.MemberLabel.layer.masksToBounds = YES;
    
    self.afterSaleButton.layer.cornerRadius = 4;
    self.afterSaleButton.layer.masksToBounds = YES;
    self.afterSaleButton.layer.borderColor = shrbPink.CGColor;
    self.afterSaleButton.layer.borderWidth = 1;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
