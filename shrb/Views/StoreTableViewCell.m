//
//  CouponsTableViewCell.m
//  shrb
//
//  Created by PayBay on 15/5/20.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "StoreTableViewCell.h"

@implementation StoreTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.couponsImageView.layer.cornerRadius = 10;
    self.couponsImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
