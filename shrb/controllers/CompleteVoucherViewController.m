//
//  CompleteVoucherViewController.m
//  shrb
//  完成充值
//  Created by PayBay on 15/5/21.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "CompleteVoucherViewController.h"
#import "CardTableViewController.h"
#import <DCAnimationKit/UIView+DCAnimationKit.h>
#import <CRToast.h>

@interface CompleteVoucherViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *cardImageView;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *integralLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardNumberLabel;
@property (weak, nonatomic) IBOutlet UITextView *recordTextView;

@end

@implementation CompleteVoucherViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initView];
    
}

- (void)initView
{
    self.cardImageView.image = [UIImage imageNamed:@"官方头像"];
    self.moneyLabel.text = @"金额：1000元";
    self.integralLabel.text = @"积分：10000分";
    self.cardNumberLabel.text = @"卡号：6789674329589432";
    self.recordTextView.text = @"2015年5月20日     PM15:47\n完成一次100元的充值交易";
    
//    //动画
//    NSDictionary *options = @{
//                              kCRToastImageKey : [UIImage imageNamed:@"官方头像"],
//                              kCRToastTextAlignmentKey:@(NSTextAlignmentLeft),
//                              kCRToastTextKey:@"充值完成",
//                              kCRToastFontKey:[UIFont boldSystemFontOfSize:18.0],
//                              kCRToastNotificationTypeKey : @(CRToastTypeNavigationBar),
//                              kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
//                              kCRToastBackgroundColorKey : [UIColor colorWithRed:255.0/255.0 green:100.0/255.0 blue:93.0/255.0 alpha:1],
//                              kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
//                              kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeGravity),
//                              kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionLeft),
//                              kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionRight)
//                              };
//    
//    [CRToastManager showNotificationWithOptions:options
//                                completionBlock:^{
//                                    
//                                }];
}

#pragma  mark - 完成充值Btn
- (IBAction)completeVoucherBtnPressed:(id)sender {
    
    
    NSString *QRPay =  [[NSUserDefaults standardUserDefaults] stringForKey:@"QRPay"];
    
    //超市或者点餐扫码
    if ([QRPay isEqualToString:@"SupermarketOrOrder"]) {
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
    //超市扫码
    else if ([QRPay isEqualToString:@"SupermarketNewStore"]) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:NO];
    }
    //卡包扫描和充值
    else if ([QRPay isEqualToString:@"Card"]){
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:NO];
    }
    //超市或者点餐充值
    else if ([QRPay isEqualToString:@"SupermarketOrOrderVoucher"]) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-4] animated:YES];
    }
}

@end
