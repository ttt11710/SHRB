//
//  PayOrderTableViewCell.m
//  shrb
//
//  Created by PayBay on 15/6/29.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "PayOrderTableViewCell.h"

@implementation PayOrderTableViewCell

- (void)awakeFromNib {
    
    self.orderImageView.layer.cornerRadius = 5;
    self.orderImageView.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
