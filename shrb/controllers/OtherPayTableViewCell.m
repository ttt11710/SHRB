//
//  OtherPayTableViewCell.m
//  shrb
//
//  Created by PayBay on 15/6/29.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "OtherPayTableViewCell.h"
#import "Const.h"


@interface OtherPayTableViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *internetbankBtn;
@property (weak, nonatomic) IBOutlet UIButton *alipayBtn;


@end

@implementation OtherPayTableViewCell

- (void)awakeFromNib {
    
    [self.internetbankBtn setBackgroundColor:shrbPink];
    [self.alipayBtn setBackgroundColor:shrbPink];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
