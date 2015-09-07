//
//  UserCouponsViewController.m
//  shrb
//
//  Created by PayBay on 15/6/29.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "UserCouponsViewController.h"
#import "Const.h"
#import "SVProgressShow.h"

@interface UserCouponsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *couponsImageView;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *ruleLabel;

@property (weak, nonatomic) IBOutlet UIButton *userBtn;
@end

@implementation UserCouponsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

- (void)viewDidLayoutSubviews {
    self.userBtn.layer.cornerRadius = 4;
    self.userBtn.layer.masksToBounds = YES;
}

- (void)initView
{
    self.couponsImageView.image = [UIImage imageNamed:@"McDonaldsLogo"];
    NSString *string = @"￥100RMB";
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:251.0/255.0 green:102.0/255.0 blue:49.0/255.0 alpha:1] range:NSMakeRange(0, string.length)];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:34] range:NSMakeRange(1, string.length-1)];
    self.moneyLabel.attributedText = attrString;
    
    if (IsiPhone4s) {
        self.ruleLabel.font = [UIFont systemFontOfSize:15];
    }
    self.ruleLabel.text = @"电子券使用规则\n    1、电子抵用券，只可在消费时直接使用，不可把电子券金额转存至会员卡中。支付消费时，会提示使用此类电子券。\n       此类电子券有一定的时效期限，据商家而定。\n    2、电子红包券，是可以把电子券金额转存至会员卡中，且单项操作。电子券转存的会员卡金额不可以体现。";
    
    [self.userBtn setBackgroundColor:shrbPink];
}

- (IBAction)userBtnPressed:(id)sender {
    
    [SVProgressShow showSuccessWithStatus:@"转存成功!"];
    
}


@end
