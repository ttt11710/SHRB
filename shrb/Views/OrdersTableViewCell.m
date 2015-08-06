//
//  ShoppingCartTableViewCell.m
//  shrb
//
//  Created by PayBay on 15/5/20.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "OrdersTableViewCell.h"
#import "Const.h"


static UIButton *_payTypeButton = nil;

NSString *const PAY_CHANGED = @"groupChanged";

@implementation OrdersTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.couponsImageView.layer.cornerRadius = 10;
    self.couponsImageView.layer.masksToBounds = YES;
    
    
    [self.memberBtn addTarget:self action:@selector(payBtnPresed:) forControlEvents:UIControlEventTouchUpInside];
    [self.alipayBtn addTarget:self action:@selector(payBtnPresed:) forControlEvents:UIControlEventTouchUpInside];
    [self.internetbankBtn addTarget:self action:@selector(payBtnPresed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.memberLabelBtn setTitleColor:shrbText forState:UIControlStateNormal];
    [self.memberLabelBtn setTitleColor:shrbPink forState:UIControlStateSelected];
    [self.alipayLabelBtn setTitleColor:shrbText forState:UIControlStateNormal];
    [self.alipayLabelBtn setTitleColor:shrbPink forState:UIControlStateSelected];
    [self.internetbankLabelBtn setTitleColor:shrbText forState:UIControlStateNormal];
    [self.internetbankLabelBtn setTitleColor:shrbPink forState:UIControlStateSelected];

    
}

- (IBAction)payBtnPresed:(UIButton *)sender {
    
    switch (sender.tag) {
        case 0:
            sender = self.memberLabelBtn;
            break;
        case 1:
            sender = self.alipayLabelBtn;
            break;
        case 2:
            sender = self.internetbankLabelBtn;
            break;
            
        default:
            break;
    }
    
    if (_payTypeButton == nil)
    {
        sender.selected = YES;
        _payTypeButton = sender;
    }
    
    else if (_payTypeButton != nil && _payTypeButton == sender)
    {
        sender.selected = YES;
    }
    
    else if (_payTypeButton != sender && _payTypeButton != nil)
    {
        _payTypeButton.selected = NO;
        sender.selected = YES;
        _payTypeButton = sender;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PAY_CHANGED object:sender];

    //  tag = sender.tag;
    
}


- (IBAction)payLabelBtnPresed:(UIButton *)sender {
    
    if (_payTypeButton == nil)
    {
        sender.selected = YES;
        _payTypeButton = sender;
    }
    
    else if (_payTypeButton != nil && _payTypeButton == sender)
    {
        sender.selected = YES;
    }
    
    else if (_payTypeButton != sender && _payTypeButton != nil)
    {
        _payTypeButton.selected = NO;
        sender.selected = YES;
        _payTypeButton = sender;
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:PAY_CHANGED object:sender];

    //  tag = sender.tag;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
