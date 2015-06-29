//
//  UserCouponsViewController.m
//  shrb
//
//  Created by PayBay on 15/6/29.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "UserCouponsViewController.h"

@interface UserCouponsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *couponsImageView;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *ruleLabel;

@end

@implementation UserCouponsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

- (void)initView
{
    self.couponsImageView.image = [UIImage imageNamed:@"官方头像.jpg"];
    self.moneyLabel.text = @"金额：100元";
    self.ruleLabel.text = @"电子券使用规则\n  1、电子抵用券，只可在消费时直接使用，不可把电子券金额转存至会员卡中。支付消费时，会提示使用此类电子券。\n     此类电子券有一定的时效期限，据商家而定。\n  2、电子红包券，是可以把电子券金额转存至会员卡中，且单项操作。电子券转存的会员卡金额不可以体现。";
}

@end
