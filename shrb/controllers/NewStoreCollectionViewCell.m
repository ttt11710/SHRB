//
//  NewStoreCollectionViewCell.m
//  shrb
//
//  Created by PayBay on 15/7/27.
//  Copyright © 2015年 PayBay. All rights reserved.
//

#import "NewStoreCollectionViewCell.h"
#import "TradeModel.h"
#import "Const.h"
#import "NSString+AttributedStyle.h"

@interface NewStoreCollectionViewCell ()


@end


@implementation NewStoreCollectionViewCell




- (void)setModel:(TradeModel *)model
{
    self.tradeNameLabel.text = model.tradeName;
    self.tradeImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",model.tradeImage]];
    
    self.memberPriceLabel.text = [NSString stringWithFormat:@"会员价:￥%@",model.memberPrice];
    self.originalPriceLabel.text = [NSString stringWithFormat:@"原价:￥%@",model.originalPrice];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:self.originalPriceLabel.text];
     [attrString addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, [self.originalPriceLabel.text length])];//删除线
    [attrString addAttribute:NSStrikethroughColorAttributeName value:shrbText range:NSMakeRange(0, [self.originalPriceLabel.text length])];
    self.originalPriceLabel.attributedText = attrString;
}


- (void)awakeFromNib {
    // Initialization code
  //  self.tradeImageView.layer.cornerRadius = 10;
  //  self.tradeImageView.layer.masksToBounds = YES;
  //  self.tradeImageView.layer.borderColor = shrbPink.CGColor;
  //  self.tradeImageView.layer.borderWidth = 1;
    
    self.memberPriceLabel.textColor = [UIColor colorWithRed:235.0/255.0 green:76.0/255.0 blue:72.0/255.0 alpha:1];
}


@end
