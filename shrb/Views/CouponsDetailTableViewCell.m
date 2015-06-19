//
//  CouponsDetailTableViewCell.m
//  shrb
//
//  Created by PayBay on 15/6/8.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "CouponsDetailTableViewCell.h"
#import "CouponsModel.h"

@interface CouponsDetailTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *couponsImageView;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *expirationDateLabel;


@end
@implementation CouponsDetailTableViewCell

- (void)setModel:(CouponsModel *)model
{
    self.couponsImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",model.couponsImage]];
    self.moneyLabel.text = [NSString stringWithFormat:@"金额：%@RMB",model.money];
    self.expirationDateLabel.text = [NSString stringWithFormat:@"截止日期：%@",model.expirationDate];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
