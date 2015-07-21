//
//  ReceiveCardTableViewCell.m
//  shrb
//
//  Created by PayBay on 15/6/30.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "ReceiveCouponsTableViewCell.h"
#import "CouponsModel.h"
#import "NSString+AttributedStyle.h"


@interface ReceiveCouponsTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *couponsImageView;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@end

@implementation ReceiveCouponsTableViewCell

- (void)setModel:(CouponsModel *)model
{
    self.couponsImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",model.couponsImage]];
    
    NSString *string = [NSString stringWithFormat:@"总金额：%@元",model.money];
    
    self.moneyLabel.attributedText = [string createrAttributedStringWithStyles:
                                      @[
                                        [ForeGroundColorStyle withColor:[UIColor redColor] range:NSMakeRange(4, model.money.length)],
                                        [FontStyle withFont:[UIFont systemFontOfSize:18.f] range:NSMakeRange(4, model.money.length)]
                                        ]];

    
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
