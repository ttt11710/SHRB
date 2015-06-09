//
//  CompletePayViewController.m
//  shrb
//  完成支付
//  Created by PayBay on 15/5/20.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "CompletePayViewController.h"

@interface CompletePayViewController ()
@property (weak, nonatomic) IBOutlet UITextView *payInfoTextView;

@end

@implementation CompletePayViewController

@synthesize isMemberPay;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _payInfoTextView.layer.cornerRadius = 5;
    _payInfoTextView.layer.masksToBounds = YES;
    [self initView];
}

#pragma mark - 初始化UI
- (void)initView
{
   _payInfoTextView.text = self.isMemberPay? @"信息确认\n型号：L款\n日期：2015年5月20日\n单号：89849382403284093\n\n本次消费：200RMB    本次积分35分\n会员余额：2650RMB   会员积分：35分\n\n已收到您的订单，请耐心等待，我们将为您服务":@"信息确认\n型号：L款\n日期：2015年5月20日\n单号：89849382403284093\n\n会员余额：2650RMB   会员积分：35分\n会员卡买单更划算，更优惠哦！\n\n已收到您的订单，请耐心等待，我们将为您服务";
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isMember"]) {
        _payInfoTextView.text = @"信息确认\n型号：L款\n日期：2015年5月20日\n单号：89849382403284093\n\n已收到您的订单，请耐心等待，我们将为您服务";
    }
    
}

#pragma  mark - 完成支付Btn
- (IBAction)finishBtnPressed:(id)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *mainView = [mainStoryboard instantiateViewControllerWithIdentifier:@"MainVC"];
    [mainView setModalPresentationStyle:UIModalPresentationFullScreen];
    [UIApplication sharedApplication].keyWindow.rootViewController = mainView;
}
@end
