//
//  OrderListTableViewCell.m
//  shrb
//
//  Created by PayBay on 15/6/16.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "OrderListTableViewCell.h"
#import "OrderListModel.h"

@interface OrderListTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *storeLogoImageView;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *orderImageView;
@property (weak, nonatomic) IBOutlet UILabel *orderNum;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@end

@implementation OrderListTableViewCell

- (void)setModel:(OrderListModel *)model
{
    self.storeLogoImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",model.storeLogoImageView]];
    self.storeNameLabel.text = model.storeNameLabel;
    self.stateLabel.text = model.stateLabel;
    self.orderImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",model.orderImageView]];
    self.orderNum.text = [NSString stringWithFormat:@"订单:%@",model.orderNum];
    self.address.text = [NSString stringWithFormat:@"地址:%@",model.address];
    self.date.text = model.date;
    self.moneyLabel.text = [NSString stringWithFormat:@"实付金额:%@元",model.moneyLabel];
}


- (void)awakeFromNib {
    // Initialization code
    
    [OrderListTableViewCell class];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
