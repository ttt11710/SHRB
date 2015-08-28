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
@end

@implementation NewLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"登录";
    
    self.passwordTextField.secureTextEntry = YES;
    
}


- (IBAction)loginInBtnPressed:(id)sender {
    
    if (self.phoneTextField.text.length <= 0 || self.passwordTextField.text.length <= 0 ) {
        [SVProgressShow showInfoWithStatus:@"信息输入不完整"];
        return;
    }
    
    [self.phoneTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    
    NSString *url=[baseUrl stringByAppendingString:@"/user/v1.0/login?"];
    [self.requestOperationManager POST:url parameters:@{@"phone":self.phoneTextField.text,@"password":self.passwordTextField.text} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressShow showInfoWithStatus:responseObject[@"msg"]];
        NSLog(@"JSON: %@", responseObject[@"msg"]);
        if ([responseObject[@"code"] isEqualToString:@"200"]) {
            
            
            [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(todoSomething) object:nil];
            [self performSelector:@selector(todoSomething) withObject:nil afterDelay:0.5f];
            
            TBUser *user = [[TBUser alloc] init];
            user.userId = responseObject[@"userId"];
            user.userName = responseObject[@"userName"];
            user.token = responseObject[@"token"];
            
            [TBUser setCurrentUser:user];
            
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
    
    if ([[touches anyObject]view]!=self.passwordTextField ||[[touches anyObject]view]!=self.phoneTextField) {
        [self.phoneTextField resignFirstResponder];
        [self.passwordTextField resignFirstResponder];
    }
}

@end
