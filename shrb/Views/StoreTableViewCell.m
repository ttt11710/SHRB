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


@interface StoreTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *tradeImageView;
@property (weak, nonatomic) IBOutlet UILabel *tradeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tradeDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *MemberLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end


@implementation StoreTableViewCell

- (void)setModel:(TradeModel *)model
{
    self.tradeNameLabel.text = model.tradeName;
    self.tradeImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",model.tradeImage]];
    
    self.tradeDescriptionLabel.text = model.tradeDescription;
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@ 原价￥%@",model.memberPrice,model.originalPrice]];
    
    [attrString addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(model.memberPrice.length + 2, model.originalPrice.length+3)];//删除线
    [attrString addAttribute:NSForegroundColorAttributeName value:shrbPink range:NSMakeRange(0, model.memberPrice.length + 1)];
    [attrString addAttribute:NSForegroundColorAttributeName value:shrbLightText range:NSMakeRange(model.memberPrice.length + 2, model.originalPrice.length+3)];
    
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, model.memberPrice.length + 1)];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(model.memberPrice.length + 2, model.originalPrice.length+3)];
    
    self.priceLabel.attributedText = attrString;
}

- (void)awakeFromNib {
    // Initialization code
    self.tradeImageView.layer.cornerRadius = 10;
    self.tradeImageView.layer.masksToBounds = YES;
    self.tradeImageView.layer.borderColor = shrbPink.CGColor;
    self.tradeImageView.layer.borderWidth = 1;
    
    self.MemberLabel.layer.cornerRadius = 12;
    self.MemberLabel.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
