//
//  GiveCouponsViewController.m
//  shrb
//  赠送电子券
//  Created by PayBay on 15/6/8.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "GiveCouponsViewController.h"

@interface GiveCouponsViewController ()

@end

@implementation GiveCouponsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

#pragma  mark - UI初始化
- (void)initView
{
    self.couponsImageView.image = [UIImage imageNamed:@"官方头像"];
    self.moneyLabel.text = @"200RMB";
    self.descriptionTextView.text = @"使用期限2015.01.01——2016.05.20\n送好友\n好友接收到电子券，就可以凭券消费。。。\n转送方式\n以连接的方式，直接通过短信、微信、QQ、微博等发给指定好友即可。";
}
@end
