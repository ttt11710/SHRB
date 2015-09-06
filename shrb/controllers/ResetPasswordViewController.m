//
//  ResetPasswordViewController.m
//  shrb
//
//  Created by PayBay on 15/8/26.
//  Copyright © 2015年 PayBay. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "TBUser.h"
#import "Const.h"
#import "SVProgressShow.h"

@interface ResetPasswordViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *oldPassTextField;
@property (weak, nonatomic) IBOutlet UITextField *myNewPassTextField;
@property (weak, nonatomic) IBOutlet UIButton *giveCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *updatePassBtn;

@end

@implementation ResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewDidLayoutSubviews
{
    self.giveCodeBtn.layer.borderColor = shrbPink.CGColor;
    self.giveCodeBtn.layer.borderWidth = 1;
    self.giveCodeBtn.layer.cornerRadius = 4;
    self.giveCodeBtn.layer.masksToBounds = YES;
    
    self.updatePassBtn.backgroundColor = shrbPink;
    self.updatePassBtn.layer.cornerRadius = 4;
    self.updatePassBtn.layer.masksToBounds = YES;
    
    self.oldPassTextField.secureTextEntry = YES;
    self.myNewPassTextField.secureTextEntry = YES;
    
}

#pragma mark - 键盘即将显示的时候回调
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(IsiPhone4s)
    {
        if (textField == self.myNewPassTextField) {
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
    [self.phoneTextField resignFirstResponder];
    [self.codeTextField resignFirstResponder];
    [self.oldPassTextField resignFirstResponder];
    [self.myNewPassTextField resignFirstResponder];
}

#pragma mark - 点击界面键盘失去响应
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if ([[touches anyObject]view]!=self.phoneTextField||[[touches anyObject]view]!= self.codeTextField||[[touches anyObject]view]!= self.oldPassTextField||[[touches anyObject]view]!= self.myNewPassTextField) {
        [self textFieldResignFirstResponder];
    }
}

#pragma mark - 获取验证码
- (IBAction)getCodeBtnPressed:(id)sender {
    
    NSString *url=[baseUrl stringByAppendingString:@"/user/v1.0/getCode?"];
    [self.requestOperationManager GET:url parameters:@{@"phone":self.phoneTextField.text} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"getCode operation = %@ JSON: %@", operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error:++++%@",error.localizedDescription);
    }];
    
}

#pragma mark - 重置密码
- (IBAction)updatePassBtnPressed:(id)sender {
    
    [self textFieldResignFirstResponder];
    
    NSString *url2=[baseUrl stringByAppendingString:@"/user/v1.0/updatePass?"];
    [self.requestOperationManager POST:url2 parameters:@{@"userId":[TBUser currentUser].userId,@"token":[TBUser currentUser].token ,@"oldPass":self.oldPassTextField.text,@"newPass":self.myNewPassTextField.text} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"updatePass operation = %@ JSON: %@", operation,responseObject);        if ([responseObject[@"code"] isEqualToString:@"200"]) {
            [SVProgressShow showSuccessWithStatus:responseObject[@"msg"]];
            [self.navigationController popViewControllerAnimated:YES];
            [SVProgressShow dismiss];
        }
        else {
           [SVProgressShow showInfoWithStatus:responseObject[@"msg"]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:++++%@",error.localizedDescription);
        
    }];
    
}


@end
