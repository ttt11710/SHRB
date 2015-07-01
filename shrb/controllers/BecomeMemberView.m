//
//  BecomeMemberView.m
//  shrb
//
//  Created by PayBay on 15/7/1.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "BecomeMemberView.h"
#import "Const.h"

@implementation BecomeMemberView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
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
    
    UITextField *telephoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(telephoneLabel.frame.size.width+4, telephoneLabel.frame.origin.y, 150, 30)];
    telephoneTextField.borderStyle = UITextBorderStyleBezel;
    [self addSubview:telephoneTextField];
    
    UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, telephoneLabel.frame.origin.y + telephoneLabel.frame.size.height+4, 50, 30)];
    [passwordLabel setText:@"密码"];
    [passwordLabel setTextColor:[UIColor blackColor]];
    [passwordLabel setFont:[UIFont systemFontOfSize:16]];
    [self addSubview:passwordLabel];
    
    UITextField *passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(passwordLabel.frame.size.width+4, passwordLabel.frame.origin.y, 150, 30)];
    passwordTextField.borderStyle = UITextBorderStyleBezel;
    passwordTextField.secureTextEntry = YES;
    [self addSubview:passwordTextField];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(0, passwordLabel.frame.origin.y + passwordLabel.frame.size.height+8, 200, 44);
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTintColor:[UIColor clearColor]];
    [sureBtn setBackgroundColor:shrbPink];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:sureBtn];
    
}
@end
