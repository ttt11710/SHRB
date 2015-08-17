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


@end

@implementation RegisteringStoreMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)viewDidLayoutSubviews
{
    if (IsiPhone4s) {
        self.navigate.frame = CGRectMake(0, 0, screenWidth, 64);
    }
}
#pragma mark - 返回上一页
- (IBAction)goBackView:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark textfield的deletage事件 键盘即将显示的时候回调
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

//键盘即将消失的时候回调
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(IsIOS7)
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
    [self.telephoneTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.verificationCodeTextField resignFirstResponder];
    return YES;
}

- (void)textFieldResignFirstResponder
{
    [self.telephoneTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.verificationCodeTextField resignFirstResponder];
}

- (IBAction)giveVerificationCodeBtnPressed:(id)sender {
    
    [SVProgressShow showSuccessWithStatus:@"您的验证码是：869563"];
    double delayInSeconds = 1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [SVProgressShow dismiss];
    });

}

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
