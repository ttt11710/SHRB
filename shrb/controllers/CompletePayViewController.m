//
//  CompletePayViewController.m
//  shrb
//  完成支付
//  Created by PayBay on 15/5/20.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "CompletePayViewController.h"
#import "LazyFadeInView.h"
#import "SVProgressShow.h"
#import <DCAnimationKit/UIView+DCAnimationKit.h>
#import "Const.h"

@interface CompletePayViewController ()
@property (weak, nonatomic) IBOutlet LazyFadeInView *payInfoView;
@property (weak, nonatomic) IBOutlet UILabel *completePayLabel;

@end

@implementation CompletePayViewController

@synthesize isMemberPay;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    [self.completePayLabel swing:nil];
}

#pragma mark - 初始化UI
- (void)initView
{
    self.payInfoView.text = self.isMemberPay? @"信息确认\n型号：L款\n日期：2015年5月20日\n单号：89849382403284093\n\n本次消费：200RMB    本次积分35分\n会员余额：2650RMB   会员积分：35分\n\n已收到您的订单，请耐心等待，我们将为您服务":@"信息确认\n型号：L款\n日期：2015年5月20日\n单号：89849382403284093\n\n会员余额：2650RMB   会员积分：35分\n会员卡买单更划算，更优惠哦！\n\n已收到您的订单，请耐心等待，我们将为您服务";
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isMember"]) {
        self.payInfoView.text = @"信息确认\n型号：L款\n日期：2015年5月20日\n单号：89849382403284093\n\n已收到您的订单，请耐心等待，我们将为您服务";
    }

}

#pragma  mark - 完成支付Btn
- (IBAction)finishBtnPressed:(id)sender {
    
    //等待一定时间后执行
    [SVProgressShow showSuccessWithStatus:@"到店领取宝贝吧！"];
    double delayInSeconds = 1.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [SVProgressShow dismiss];
        ////跳转到指定页面
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
    });
}
@end
