//
//  BecomeMemberView.m
//  shrb
//
//  Created by PayBay on 15/7/1.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "SuperBecomeMemberView.h"
#import "Const.h"
#import "SVProgressShow.h"
#import "ProductTableViewController.h"

static SuperBecomeMemberView *g_SuperBecomeMemberView = nil;

@interface SuperBecomeMemberView () <UITextFieldDelegate>
{
    UITextField *_telephoneTextField;
    UITextField *_passwordTextField;
}

@end
@implementation SuperBecomeMemberView


+ (SuperBecomeMemberView *)shareSuperBecomeMemberView
{
    return g_SuperBecomeMemberView;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        g_SuperBecomeMemberView = self;
        
        [self initView];
    }
    return self ;
}

- (void)initView
{
    UILabel *cardNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [cardNumLabel setText:@"会员号"];
    [cardNumLabel setTextColor:[UIColor blackColor]];
    [cardNumLabel setFont:[UIFont systemFontOfSize:16]];
    [self addSubview:cardNumLabel];
    
    UITextField *cardNumTextField = [[UITextField alloc] initWithFrame:CGRectMake(cardNumLabel.frame.size.width+4, 0, 150, 30)];
    cardNumTextField.placeholder = @"265842365122";
    cardNumTextField.borderStyle = UITextBorderStyleBezel;
    [self addSubview:cardNumTextField];
    
    UILabel *telephoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, cardNumLabel.frame.origin.y + cardNumLabel.frame.size.height+4, 50, 30)];
    [telephoneLabel setText:@"手机号"];
    [telephoneLabel setTextColor:[UIColor blackColor]];
    [telephoneLabel setFont:[UIFont systemFontOfSize:16]];
    [self addSubview:telephoneLabel];
    
    _telephoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(telephoneLabel.frame.size.width+4, telephoneLabel.frame.origin.y, 150, 30)];
    _telephoneTextField.borderStyle = UITextBorderStyleBezel;
    _telephoneTextField.delegate = self;
    [self addSubview:_telephoneTextField];
    
    UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, telephoneLabel.frame.origin.y + telephoneLabel.frame.size.height+4, 50, 30)];
    [passwordLabel setText:@"密码"];
    [passwordLabel setTextColor:[UIColor blackColor]];
    [passwordLabel setFont:[UIFont systemFontOfSize:16]];
    [self addSubview:passwordLabel];
    
    _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(passwordLabel.frame.size.width+4, passwordLabel.frame.origin.y, 150, 30)];
    _passwordTextField.borderStyle = UITextBorderStyleBezel;
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.delegate = self;
    [self addSubview:_passwordTextField];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(0, passwordLabel.frame.origin.y + passwordLabel.frame.size.height+8, 204, 44);
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTintColor:[UIColor clearColor]];
    [sureBtn setBackgroundColor:shrbPink];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.layer.cornerRadius = 4;
    sureBtn.layer.masksToBounds = YES;
    [sureBtn addTarget:self action:@selector(becomeMemberBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sureBtn];
    
}

- (void)textFieldResignFirstResponder
{
    [_telephoneTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
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
        [[ProductTableViewController shareProductTableViewController] becomeMember];
    });
}

@end
