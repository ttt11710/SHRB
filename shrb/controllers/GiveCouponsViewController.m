//
//  GiveCouponsViewController.m
//  shrb
//  赠送电子券
//  Created by PayBay on 15/6/8.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "GiveCouponsViewController.h"
#import "SVProgressShow.h"

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
    self.moneyLabel.text = @"金额：200RMB";
    self.descriptionTextView.text = @"使用期限\n2015.01.01——2016.05.20\n\n送好友\n好友接收到电子券，就可以凭券消费。。。\n\n转送方式\n以链接的方式，直接通过短信、微信、QQ、微博等发给指定好友即可。";
}

- (IBAction)giveCouponsBtnPressed:(id)sender {
    
    double delayInSeconds = 1;
    [SVProgressShow showWithStatus:@"赠送中..."];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    
    UIButton *button = (UIButton *)sender;
    switch (button.tag) {
        case 1:
            //短信
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [SVProgressShow showSuccessWithStatus:@"短信赠送成功！"];
            });
            break;
        case 2:
            //微信
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [SVProgressShow showSuccessWithStatus:@"微信赠送成功！"];
            });
            break;
        case 3:
            //QQ
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [SVProgressShow showSuccessWithStatus:@"QQ赠送成功！"];
            });
            
            break;
        case 4:
            //微博
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [SVProgressShow showSuccessWithStatus:@"微博赠送成功！"];
            });
            break;
        default:
            break;
    }
    
    
    
}



@end
