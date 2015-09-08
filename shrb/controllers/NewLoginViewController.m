//
//  NewLoginViewController.m
//  shrb
//
//  Created by PayBay on 15/8/28.
//  Copyright © 2015年 PayBay. All rights reserved.
//

#import "NewLoginViewController.h"
#import "SVProgressShow.h"
#import "Const.h"
#import "TBUser.h"

@interface NewLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginInBtn;


@end

@implementation NewLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"登录";
    
    self.passwordTextField.secureTextEntry = YES;
    
}

- (void)viewDidLayoutSubviews
{
    self.loginInBtn.layer.cornerRadius = 4;
    self.loginInBtn.layer.masksToBounds = YES;
}

- (IBAction)loginInBtnPressed:(id)sender {
    
    if (self.phoneTextField.text.length <= 0 || self.passwordTextField.text.length <= 0 ) {
        [SVProgressShow showInfoWithStatus:@"信息输入不完整"];
        return;
    }
    
    [self.phoneTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    
    [SVProgressShow showWithStatus:@"正在登录..."];
    
    NSString *url=[baseUrl stringByAppendingString:@"/user/v1.0/login?"];
    [self.requestOperationManager POST:url parameters:@{@"phone":self.phoneTextField.text,@"password":self.passwordTextField.text} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressShow showInfoWithStatus:responseObject[@"msg"]];
        NSLog(@"login operation = %@ JSON: %@", operation,responseObject);
        
        switch ([responseObject[@"code"] integerValue]) {
            case 200: {
                [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(todoSomething) object:nil];
                [self performSelector:@selector(todoSomething) withObject:nil afterDelay:0.5f];
                
                TBUser *user = [[TBUser alloc] init];
                user.userId = responseObject[@"userId"];
                user.userName = responseObject[@"userName"];
                user.token = responseObject[@"token"];
                
                [TBUser setCurrentUser:user];
                
            }
                break;
            case 404:
            case 500:
                [SVProgressShow showErrorWithStatus:responseObject[@"msg"]];
                break;
                
            default:
                break;
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:++++%@",error.localizedDescription);
    }];
}

- (void)todoSomething
{
    [SVProgressShow dismiss];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark textfield的deletage事件
//键盘即将显示的时候回调
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if (IsiPhone4s) {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            self.view.layer.transform =CATransform3DMakeTranslation(0, -100, 0);
            
        } completion:^(BOOL finished) {
            
        }];
    }
}

//键盘即将消失的时候回调
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (IsiPhone4s) {
        
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            self.view.layer.transform = CATransform3DIdentity;
            
        } completion:^(BOOL finished) {
            
        }];
    }
}

#pragma mark - 单击键盘return键回调
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.phoneTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if ([[touches anyObject]view] == self.passwordTextField ) {
        self.passwordTextField.secureTextEntry = NO;
    }
    
    if ([[touches anyObject]view]!=self.passwordTextField &&[[touches anyObject]view]!=self.phoneTextField) {
        [self.phoneTextField resignFirstResponder];
        [self.passwordTextField resignFirstResponder];
    }
}

@end
