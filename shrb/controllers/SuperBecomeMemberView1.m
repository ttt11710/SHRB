//
//  SuperBecomeMemberView1.m
//  shrb
//
//  Created by PayBay on 15/7/2.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "SuperBecomeMemberView1.h"
#import "Const.h"
#import "SVProgressShow.h"
#import "ProductViewController.h"
#import "JVFloatLabeledTextField.h"

static SuperBecomeMemberView1 *g_SuperBecomeMemberView = nil;
static  int Num = 0 ;

@interface SuperBecomeMemberView1 () <UITextFieldDelegate>
{
    UILabel *_cardNumLabel;
    UITextField *_cardNumTextField;
    
    UILabel *_telephoneLabel;
    UITextField *_telephoneTextField;
    
    UILabel *_passwordLabel;
    UITextField *_passwordTextField;
    
    UIButton *_verificationCodeBtn;
    UITextField *_verificationCodeTextField;
    
    UIButton *_sureBtn;
}

@end
@implementation SuperBecomeMemberView1


+ (SuperBecomeMemberView1 *)shareSuperBecomeMemberView
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
    _cardNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [_cardNumLabel setText:@"会员号"];
    [_cardNumLabel setTextColor:shrbText];
    [_cardNumLabel setFont:[UIFont systemFontOfSize:16]];
    [self addSubview:_cardNumLabel];
    
    _cardNumTextField = [[UITextField alloc] initWithFrame:CGRectMake(_cardNumLabel.frame.size.width+4, 0, 150, 30)];
    _cardNumTextField.placeholder = @"265842365122";
    _cardNumTextField.borderStyle = UITextBorderStyleBezel;
    [self addSubview:_cardNumTextField];
    
    _telephoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _cardNumLabel.frame.origin.y + _cardNumLabel.frame.size.height+4, 50, 30)];
    [_telephoneLabel setText:@"手机号"];
    [_telephoneLabel setTextColor:shrbText];
    [_telephoneLabel setFont:[UIFont systemFontOfSize:16]];
    [self addSubview:_telephoneLabel];
    
    _telephoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(_telephoneLabel.frame.size.width+4, _telephoneLabel.frame.origin.y, 150, 30)];
    _telephoneTextField.borderStyle = UITextBorderStyleBezel;
    _telephoneTextField.delegate = self;
    [self addSubview:_telephoneTextField];

    _passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _telephoneLabel.frame.origin.y + _telephoneLabel.frame.size.height+4, 50, 30)];
    [_passwordLabel setText:@"密码"];
    [_passwordLabel setTextColor:shrbText];
    [_passwordLabel setFont:[UIFont systemFontOfSize:16]];
    [self addSubview:_passwordLabel];
    
    _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(_passwordLabel.frame.size.width+4, _passwordLabel.frame.origin.y, 150, 30)];
    _passwordTextField.borderStyle = UITextBorderStyleBezel;
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.delegate = self;
    [self addSubview:_passwordTextField];
    
    
    _verificationCodeTextField= [[UITextField alloc] initWithFrame:CGRectMake(0, _passwordLabel.frame.origin.y + _passwordLabel.frame.size.height+4, 120, 30)];
    _verificationCodeTextField.borderStyle = UITextBorderStyleBezel;
    _verificationCodeTextField.secureTextEntry = YES;
    _verificationCodeTextField.delegate = self;
    [self addSubview:_verificationCodeTextField];
    
    _verificationCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _verificationCodeBtn.frame = CGRectMake(_verificationCodeTextField.frame.size.width+4, _verificationCodeTextField.frame.origin.y, 80, 30);
    [_verificationCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_verificationCodeBtn setTintColor:[UIColor clearColor]];
    [_verificationCodeBtn setBackgroundColor:shrbPink];
    [_verificationCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _verificationCodeBtn.font = [UIFont systemFontOfSize:14.f];
    _verificationCodeBtn.layer.cornerRadius = 8;
    _verificationCodeBtn.layer.masksToBounds = YES;
    [_verificationCodeBtn addTarget:self action:@selector(giveVerificationCodeBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_verificationCodeBtn];

    
    _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _sureBtn.frame = CGRectMake(0, _verificationCodeTextField.frame.origin.y + _verificationCodeTextField.frame.size.height+8, 204, 44);
    [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_sureBtn setTintColor:[UIColor clearColor]];
    [_sureBtn setBackgroundColor:shrbPink];
    [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _sureBtn.layer.cornerRadius = _sureBtn.frame.size.height/2;
    _sureBtn.layer.masksToBounds = YES;
    [_sureBtn addTarget:self action:@selector(becomeMemberBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_sureBtn];
    
    for (UIView *view in self.subviews) {
        view.alpha = 0;
    }
    
}

#pragma mark textfield的deletage事件
//键盘即将显示的时候回调
//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    UITableView *tableView;
//    if(IsIOS7)
//    {
//        tableView = (UITableView *)self.superview.superview.superview.superview;
//    }
//    else
//    {
//        tableView=(UITableView *)self.superview.superview.superview;
//    }
//
//    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
//
//        tableView.superview.layer.transform = CATransform3DIdentity;
//
//    } completion:^(BOOL finished) {
//
//
//    }];
//
////    if (textField == _passwordTextField) {
////        self.superview.superview.layer.transform = CATransform3DTranslate(self.superview.superview.layer.transform, 0, -200, 0);
////    }
//}
//键盘即将消失的时候回调
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    UITableView *tableView;
    if(IsIOS7)
    {
        tableView = (UITableView *)self.superview.superview.superview.superview;
    }
    else
    {
        tableView=(UITableView *)self.superview.superview.superview;
    }

    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{

        tableView.superview.layer.transform = CATransform3DIdentity;

    } completion:^(BOOL finished) {


    }];

//    self.superview.superview.layer.transform = CATransform3DIdentity;
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
    
    CGRect bounds = _sureBtn.bounds;
    bounds.size.width = 44 ; // bounds.size.height;
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        _sureBtn.bounds = bounds;
        

    } completion:^(BOOL finished) {
        
        [_sureBtn setTitle:@"" forState:UIControlStateNormal];
        [_sureBtn setBackgroundImage:[UIImage imageNamed:@"Oval"] forState:UIControlStateNormal];
        [self ballAnimation];
        
    }];
}


- (void)ballAnimation
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        _sureBtn.layer.transform = CATransform3DRotate(_sureBtn.layer.transform, M_PI/2, 0, 0, 1);
        
    } completion:^(BOOL finished) {
        Num ++ ;
        if (Num >= 10) {
            
            [_sureBtn setTitle:@"确认" forState:UIControlStateNormal];
            [_sureBtn setBackgroundImage:nil forState:UIControlStateNormal];
            _sureBtn.layer.transform = CATransform3DIdentity;
            
         //   [self.layer removeAllAnimations];
            
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                
                CGRect bounds = _sureBtn.bounds;
                bounds.size.width = 204 ;
                _sureBtn.bounds = bounds;
                
            } completion:^(BOOL finished) {
                
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isMember"];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isMember"];
                
                [SVProgressShow showSuccessWithStatus:@"会员卡生成成功！"];
                double delayInSeconds = 1;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [SVProgressShow dismiss];
                    // [[ProductTableViewController shareProductTableViewController] becomeMember];
                    [[ProductViewController shareProductViewController] becomeMember];
                    Num = 0 ;
                });
                
            }];
        }
        else {
          [self ballAnimation];
        }
    }];
}

//            [_sureBtn setTitle:@"确认" forState:UIControlStateNormal];
//            [_sureBtn setBackgroundImage:nil forState:UIControlStateNormal];
//            
//            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
//                
//                        CGRect bounds = _sureBtn.bounds;
//                        bounds.size.width = 204 ;
//                        _sureBtn.bounds = bounds;
//                
//            } completion:^(BOOL finished) {
//                
//                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isMember"];
//                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isMember"];
//                
//                [SVProgressShow showWithStatus:@"会员卡生成中..."];
//                double delayInSeconds = 1;
//                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//                    [SVProgressShow dismiss];
//                    // [[ProductTableViewController shareProductTableViewController] becomeMember];
//                    [[ProductViewController shareProductViewController] becomeMember];
//}];
//            }];
//        }
//        [self ballAnimation];
//    }];

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

- (void)showView
{
//    UILabel *_cardNumLabel;
//    UITextField *_cardNumTextField;
//    
//    UILabel *_telephoneLabel;
//    UITextField *_telephoneTextField;
//    
//    UILabel *_passwordLabel;
//    UITextField *_passwordTextField;
//    
//    UIButton *_verificationCodeBtn;
//    UITextField *_verificationCodeTextField;
//    
//    UIButton *_sureBtn;

    
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
    
        _cardNumLabel.alpha = 1;
        _cardNumTextField.alpha = 1;
    
    } completion:^(BOOL finished) {
        
    }];
    [UIView animateWithDuration:0.4 delay:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        _telephoneLabel.alpha = 1;
        _telephoneTextField.alpha = 1;
        
    } completion:^(BOOL finished) {
        
    }];
    [UIView animateWithDuration:0.4 delay:0.4 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        _passwordLabel.alpha = 1;
        _passwordTextField.alpha = 1;
        
    } completion:^(BOOL finished) {
        
    }];
    [UIView animateWithDuration:0.4 delay:0.6 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        _verificationCodeBtn.alpha = 1;
        _verificationCodeTextField.alpha = 1;
        
    } completion:^(BOOL finished) {
        
    }];
    [UIView animateWithDuration:0.4 delay:0.8 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        _sureBtn.alpha = 1;
        
    } completion:^(BOOL finished) {
        
    }];

}
@end

