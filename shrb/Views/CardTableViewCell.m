//
//  CardTableViewCell.m
//  shrb
//
//  Created by PayBay on 15/5/20.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "CardTableViewCell.h"

@implementation CardTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.backView.layer.cornerRadius = 10;
    self.backView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
