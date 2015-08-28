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
#import <BFPaperButton/BFPaperButton.h>
#import "Const.h"
#import "TBUser.h"
#import <UIImageView+WebCache.h>

@interface CompleteVoucherViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *cardImageView;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *integralLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardNumberLabel;
@property (weak, nonatomic) IBOutlet UITextView *recordTextView;

@property (weak, nonatomic) IBOutlet BFPaperButton *completeVoucherBtn;

@property (nonatomic, strong) NSMutableDictionary *dataDic;

@end

@implementation CompleteVoucherViewController

@synthesize cardNo;
@synthesize merchId;


- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadData];
}


- (void)loadData
{
    self.dataDic = [[NSMutableDictionary alloc] init];
    
    NSString *url2=[baseUrl stringByAppendingString:@"/card/v1.0/findCardDetail?"];
    [self.requestOperationManager GET:url2 parameters:@{@"userId":[TBUser currentUser].userId,@"token":[TBUser currentUser].token,@"merchId":self.merchId,@"cardNo":self.cardNo} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        self.dataDic = responseObject[@"data"];
        [self initView];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:++++%@",error.localizedDescription);
    }];
}
- (void)initView
{
    [self.cardImageView sd_setImageWithURL:[NSURL URLWithString:self.dataDic[@"cardImgUrl"]] placeholderImage:[UIImage imageNamed:@"官方头像"]];
    self.moneyLabel.text = [NSString stringWithFormat:@"金额:￥%@",self.dataDic[@"amount"]];
    self.integralLabel.text = [NSString stringWithFormat:@"积分:%@分",self.dataDic[@"score"]];
    self.cardNumberLabel.text = [NSString stringWithFormat:@"卡号:%@",self.cardNo];
    self.recordTextView.text = @"2015年5月20日     PM15:47\n完成一次100元的充值交易";
    
    [self.completeVoucherBtn setBackgroundColor:shrbPink];
    
    
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
    //首页购物车
    else if ([QRPay isEqualToString:@"HotFocusShoppingCard"]) {
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
