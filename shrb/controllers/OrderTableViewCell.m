//
//  OrderTableViewCell.m
//  shrb
//
//  Created by PayBay on 15/8/21.
//  Copyright © 2015年 PayBay. All rights reserved.
//

#import "OrderTableViewCell.h"
#import "OrderListModel.h"
#import "Const.h"

@interface OrderTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *storeLogoImageView;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *orderImageView;
@property (weak, nonatomic) IBOutlet UILabel *orderNum;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@end


@implementation OrderTableViewCell


- (void)setModel:(OrderListModel *)model
{
    self.storeLogoImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",model.storeLogoImageView]];
    self.storeNameLabel.text = model.storeNameLabel;
    self.stateLabel.text = model.stateLabel;
    self.orderImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",model.orderImageView]];
    self.orderNum.text = [NSString stringWithFormat:@"订单:%@",model.orderNum];
    self.address.text = [NSString stringWithFormat:@"地址:%@",model.address];
    self.date.text = model.date;
    
    NSMutableAttributedString * attrString;
    if (model.refundmoney.length <= 0) {
        attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"实付金额:%@元",model.moneyLabel]];
        [attrString addAttribute:NSForegroundColorAttributeName value:shrbPink range:NSMakeRange(5, [model.moneyLabel length]+1)];
    }
    else {
        attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"交易金额:%@元  退款金额:%@元", model.moneyLabel , model.refundmoney]];
        [attrString addAttribute:NSForegroundColorAttributeName value:shrbPink range:NSMakeRange(attrString.length-model.refundmoney.length-1, [model.refundmoney length]+1)];
    }
    self.moneyLabel.attributedText = attrString;
    
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
