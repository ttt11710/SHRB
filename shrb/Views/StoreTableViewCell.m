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

@interface StoreTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *tradeImageView;
@property (weak, nonatomic) IBOutlet UILabel *tradeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end


@implementation StoreTableViewCell

- (void)setModel:(TradeModel *)model
{
    self.tradeNameLabel.text = model.tradeName;
    self.tradeImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",model.tradeImage]];
    
    NSString *string = [NSString stringWithFormat:@"会员价：%@元  原价：%@元",model.memberPrice,model.originalPrice];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
//    [attributedString addAttribute:NSForegroundColorAttributeName
//                             value:[UIColor redColor]
//                             range:NSMakeRange(4, 5)];
//    
//    [attributedString addAttribute:NSFontAttributeName
//                             value:[UIFont systemFontOfSize:18.f]
//                             range:NSMakeRange(4, 5)];
    
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:[UIColor redColor]
                             range:NSMakeRange(4, 2)];
    
    [attributedString addAttribute:NSFontAttributeName
                             value:[UIFont systemFontOfSize:18.f]
                             range:NSMakeRange(4, 2)];

    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:[UIColor redColor]
                             range:NSMakeRange(12, 2)];
    
    [attributedString addAttribute:NSFontAttributeName
                             value:[UIFont systemFontOfSize:18.f]
                             range:NSMakeRange(12, 2)];
    
    self.priceLabel.attributedText = attributedString;
}

- (void)awakeFromNib {
    // Initialization code
    self.tradeImageView.layer.cornerRadius = 10;
    self.tradeImageView.layer.masksToBounds = YES;
    self.tradeImageView.layer.borderColor = shrbPink.CGColor;
    self.tradeImageView.layer.borderWidth = 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
