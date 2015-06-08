//
//  HotDetailTableViewCell.m
//  shrb
//
//  Created by PayBay on 15/5/19.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "HotDetailTableViewCell.h"

@implementation HotDetailTableViewCell

- (void)awakeFromNib {
    self.detailTextView.text = @"优惠详情介绍";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
