//
//  BecomeMemberView.m
//  shrb
//
//  Created by PayBay on 15/7/1.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "BecomeMemberView.h"
#import "OrdersViewController.h"
#import "Const.h"
#import "SVProgressShow.h"

static BecomeMemberView *g_BecomeMemberView = nil;

@interface BecomeMemberView () <UITextFieldDelegate>
{
    
    UITextField *_telephoneTextField;
    UITextField *_verificationCodeTextField;
    UITextField *_passwordTextField;
}

@end
@implementation BecomeMemberView


+ (BecomeMemberView *)shareBecomeMemberView
{
    return g_BecomeMemberView;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        g_BecomeMemberView = self;
        
        [self initView];
    }
    return self ;
}

- (void)initView
{
    UILabel *cardNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [cardNumLabel setText:@"会员号"];
    [cardNumLabel setTextColor:[UIColor colorWithRed:78.0/255.0 green:78.0/255.0 blue:78.0/255.0 alpha:1]];
    [cardNumLabel setFont:[UIFont systemFontOfSize:16]];
    [self addSubview:cardNumLabel];
    
    UITextField *cardNumTextField = [[UITextField alloc] initWithFrame:CGRectMake(cardNumLabel.frame.size.width+4, 0, 150, 30)];
    cardNumTextField.placeholder = @"265842365122";
    cardNumTextField.borderStyle = UITextBorderStyleBezel;
    [self addSubview:cardNumTextField];
    
    UILabel *telephoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, cardNumLabel.frame.origin.y + cardNumLabel.frame.size.height+4, 50, 30)];
    [telephoneLabel setText:@"手机号"];
    [telephoneLabel setTextColor:[UIColor colorWithRed:78.0/255.0 green:78.0/255.0 blue:78.0/255.0 alpha:1]];
    [telephoneLabel setFont:[UIFont systemFontOfSize:16]];
    [self addSubview:telephoneLabel];
    
    _telephoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(telephoneLabel.frame.size.width+4, telephoneLabel.frame.origin.y, 150, 30)];
    _telephoneTextField.borderStyle = UITextBorderStyleBezel;
    _telephoneTextField.delegate = self;
    [self addSubview:_telephoneTextField];
    
    UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, telephoneLabel.frame.origin.y + telephoneLabel.frame.size.height+4, 50, 30)];
    [passwordLabel setText:@"密码"];
    [passwordLabel setTextColor:[UIColor colorWithRed:78.0/255.0 green:78.0/255.0 blue:78.0/255.0 alpha:1]];
    [passwordLabel setFont:[UIFont systemFontOfSize:16]];
    [self addSubview:passwordLabel];
    
    _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(passwordLabel.frame.size.width+4, passwordLabel.frame.origin.y, 150, 30)];
    _passwordTextField.borderStyle = UITextBorderStyleBezel;
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.delegate = self;
    [self addSubview:_passwordTextField];
    
    _verificationCodeTextField= [[UITextField alloc] initWithFrame:CGRectMake(0, passwordLabel.frame.origin.y + passwordLabel.frame.size.height+4, 120, 30)];
    _verificationCodeTextField.borderStyle = UITextBorderStyleBezel;
    _verificationCodeTextField.secureTextEntry = YES;
    _verificationCodeTextField.delegate = self;
    [self addSubview:_verificationCodeTextField];
    
    UIButton *verificationCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    verificationCodeBtn.frame = CGRectMake(_verificationCodeTextField.frame.size.width+4, _verificationCodeTextField.frame.origin.y, 80, 30);
    [verificationCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [verificationCodeBtn setTintColor:[UIColor clearColor]];
    [verificationCodeBtn setBackgroundColor:shrbPink];
    [verificationCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    verificationCodeBtn.font = [UIFont systemFontOfSize:14.f];
    verificationCodeBtn.layer.cornerRadius = 8;
    verificationCodeBtn.layer.masksToBounds = YES;
    [verificationCodeBtn addTarget:self action:@selector(giveVerificationCodeBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:verificationCodeBtn];

    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(0, _verificationCodeTextField.frame.origin.y + _verificationCodeTextField.frame.size.height+8, 204, 44);
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTintColor:[UIColor clearColor]];
    [sureBtn setBackgroundColor:shrbPink];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.layer.cornerRadius = 4;
    sureBtn.layer.masksToBounds = YES;
    [sureBtn addTarget:self action:@selector(becomeMemberBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sureBtn];
    
}

#pragma mark textfield的deletage事件
//键盘即将显示的时候回调
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [[OrdersViewController shareOrdersViewController]addTap];
    UITableView *tableView;
    if(IsIOS7)
    {
        tableView = (UITableView *)self.superview.superview.superview;
    }
    else
    {
        tableView=(UITableView *)self.superview.superview;
    }
    
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        tableView.superview.layer.transform = CATransform3DTranslate(tableView.superview.layer.transform, 0, -200, 0);
        
    } completion:^(BOOL finished) {
        
        
    }];
}
//键盘即将消失的时候回调
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    UITableView *tableView;
    if(IsIOS7)
    {
        tableView = (UITableView *)self.superview.superview.superview;
    }
    else
    {
        tableView=(UITableView *)self.superview.superview;
    }
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        tableView.superview.layer.transform = CATransform3DIdentity;
        
    } completion:^(BOOL finished) {
        
        
    }];
    
}

#pragma mark - 单击键盘return键回调
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_telephoneTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
    [_verificationCodeTextField resignFirstResponder];
    return YES;
}

- (void)textFieldResignFirstResponder
{
    [_telephoneTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
    [_verificationCodeTextField resignFirstResponder];

}

#pragma mark - 成为会员
- (void)becomeMemberBtnPressed {
    
    //跳转到指定页面
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isMember"];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isMember"];
    
    [SVProgressShow showWithStatus:@"会员卡生成中..."];
    double delayInSeconds = 1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [SVProgressShow dismiss];
        [[OrdersViewController shareOrdersViewController] UpdateTableView];
    });
}

#pragma mark - 发送验证码
- (void)giveVerificationCodeBtnPressed
{
    [SVProgressShow showSuccessWithStatus:@"您的验证码是：869563"];
    double delayInSeconds = 1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [SVProgressShow dismiss];
    });
}
@end
