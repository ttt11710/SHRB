//
//  RegisteringStoreMemberViewController.m
//  shrb
//
//  Created by PayBay on 15/8/17.
//  Copyright © 2015年 PayBay. All rights reserved.
//

#import "RegisteringStoreMemberViewController.h"
#import "Const.h"
#import "SVProgressShow.h"

@interface RegisteringStoreMemberViewController ()

@property (weak, nonatomic) IBOutlet UINavigationBar *navigate;
@property (weak, nonatomic) IBOutlet UITextField *telephoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *giveVerificationCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *becomeMemberBtn;


@end

@implementation RegisteringStoreMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)viewDidLayoutSubviews
{
    self.giveVerificationCodeBtn.layer.borderColor = shrbPink.CGColor;
    self.giveVerificationCodeBtn.layer.borderWidth = 1;
    self.giveVerificationCodeBtn.layer.cornerRadius = 4;
    self.giveVerificationCodeBtn.layer.masksToBounds = YES;
    
    self.becomeMemberBtn.backgroundColor = shrbPink;
    self.becomeMemberBtn.layer.cornerRadius = 4;
    self.becomeMemberBtn.layer.masksToBounds = YES;
    
    if (IsiPhone4s) {
        self.navigate.frame = CGRectMake(0, 0, screenWidth, 64);
    }
}
#pragma mark - 返回上一页
- (IBAction)goBackView:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 键盘即将显示的时候回调
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(IsiPhone4s)
    {
        if (textField == self.passwordTextField) {
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                
                self.view.layer.transform =CATransform3DMakeTranslation(0, -50, 0);
                
            } completion:^(BOOL finished) {
                
            }];
        }
        else {
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                
                self.view.layer.transform = CATransform3DIdentity;
                
            } completion:^(BOOL finished) {
                
            }];
        }
    }
}

#pragma mark - 键盘即将消失的时候回调
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(IsiPhone4s)
    {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            self.view.layer.transform = CATransform3DIdentity;
            
        } completion:^(BOOL finished) {
            
        }];
    }
}

#pragma mark - 单击键盘return键回调
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self textFieldResignFirstResponder];
    return YES;
}

#pragma mark - 键盘失去响应
- (void)textFieldResignFirstResponder
{
    [self.telephoneTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.verificationCodeTextField resignFirstResponder];
}

#pragma mark - 点击界面键盘失去响应
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if ([[touches anyObject]view]!=self.telephoneTextField||[[touches anyObject]view]!= self.passwordTextField||[[touches anyObject]view]!= self.verificationCodeTextField) {
        [self textFieldResignFirstResponder];
    }
}

#pragma mark - 获取验证码
- (IBAction)giveVerificationCodeBtnPressed:(id)sender {
    
    [SVProgressShow showSuccessWithStatus:@"您的验证码是：869563"];
    double delayInSeconds = 1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [SVProgressShow dismiss];
    });

}

#pragma mark - 注册会员
- (IBAction)becomeMemberBtnPressed:(id)sender {
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isMember"];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isMember"];
    
    [SVProgressShow showSuccessWithStatus:@"会员卡生成成功！"];
    double delayInSeconds = 1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [self dismissViewControllerAnimated:YES completion:nil];
        [SVProgressShow dismiss];
    });
}
@end
