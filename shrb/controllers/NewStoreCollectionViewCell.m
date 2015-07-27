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
    
    NSString *string = [NSString stringWithFormat:@"会员价:%@元  原价:%@元",model.memberPrice,model.originalPrice];
    
    self.priceLabel.attributedText = [string createrAttributedStringWithStyles:
                                      @[
                                        [ForeGroundColorStyle withColor:[UIColor redColor] range:NSMakeRange(4, model.memberPrice.length)],
                                        [ForeGroundColorStyle withColor:[UIColor redColor] range:NSMakeRange(12, model.originalPrice.length)],
                                        [FontStyle withFont:[UIFont systemFontOfSize:17.f] range:NSMakeRange(4, model.memberPrice.length)],
                                        [FontStyle withFont:[UIFont systemFontOfSize:17.f] range:NSMakeRange(12, model.originalPrice.length)]
                                        ]];
}


- (void)awakeFromNib {
    // Initialization code
  //  self.tradeImageView.layer.cornerRadius = 10;
  //  self.tradeImageView.layer.masksToBounds = YES;
  //  self.tradeImageView.layer.borderColor = shrbPink.CGColor;
  //  self.tradeImageView.layer.borderWidth = 1;
}


@end
