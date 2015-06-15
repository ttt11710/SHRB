//
//  CompleteVoucherViewController.m
//  shrb
//  完成充值
//  Created by PayBay on 15/5/21.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "CompleteVoucherViewController.h"
#import "CardTableViewController.h"

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
    
    self.cardImageView.image = [UIImage imageNamed:@"官方头像"];
    self.moneyLabel.text = @"金额：1000元";
    self.integralLabel.text = @"积分：10000分";
    self.cardNumberLabel.text = @"卡号：6789674329589432";
    self.recordTextView.text = @"2015年5月20日     PM15:47\n完成一次100元的充值交易";
    
}

#pragma  mark - 完成Btn
- (IBAction)completeVoucherBtnPressed:(id)sender {
    
    //等待一定时间后执行
    double delayInSeconds = 0.3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //跳转到指定页面
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
    });
}

@end
