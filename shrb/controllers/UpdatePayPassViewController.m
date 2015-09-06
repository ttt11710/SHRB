//
//  UpdatePayPassViewController.m
//  shrb
//
//  Created by PayBay on 15/8/28.
//  Copyright © 2015年 PayBay. All rights reserved.
//

#import "UpdatePayPassViewController.h"
#import "TBUser.h"
#import "Const.h"
#import "SVProgressShow.h"

@interface UpdatePayPassViewController ()

@property (weak, nonatomic) IBOutlet UITextField *oldPassTextField;
@property (weak, nonatomic) IBOutlet UITextField *myNewPassTextField;

@end

@implementation UpdatePayPassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setPayPass];
}

- (void)viewDidLayoutSubviews
{
    self.oldPassTextField.secureTextEntry = YES;
    self.myNewPassTextField.secureTextEntry = YES;
}

#pragma mark - 设置支付密码
- (void)setPayPass
{
    NSString *url2=[baseUrl stringByAppendingString:@"/user/v1.0/setPayPass?"];
    [self.requestOperationManager POST:url2 parameters:@{@"userId":[TBUser currentUser].userId,@"token":[TBUser currentUser].token,@"payPass":@"111111"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"setPayPass operation = %@ JSON: %@", operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:++++%@",error.localizedDescription);
    }];
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
    [self.myNewPassTextField resignFirstResponder];
    [self.oldPassTextField resignFirstResponder];
}

#pragma mark - 点击界面键盘失去响应
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if ([[touches anyObject]view]!= self.oldPassTextField||[[touches anyObject]view]!= self.myNewPassTextField) {
        [self textFieldResignFirstResponder];
    }
}

#pragma mark - 重置支付密码
- (IBAction)updatePayPassBtnPressed:(id)sender {
    
    if (self.oldPassTextField.text.length == 0 ||self.myNewPassTextField.text.length == 0) {
        [SVProgressShow showInfoWithStatus:@"信息未填写完整!"];
    }
    
    //原密码111111
    NSString *url2=[baseUrl stringByAppendingString:@"/user/v1.0/updatePayPass?"];
    [self.requestOperationManager POST:url2 parameters:@{@"userId":[TBUser currentUser].userId,@"token":[TBUser currentUser].token,@"oldPass":self.oldPassTextField.text,@"newPass":self.myNewPassTextField.text} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"updatePayPass operation = %@ JSON: %@", operation,responseObject);
        if ([responseObject[@"code"] isEqualToString:@"200"]) {
            [SVProgressShow showSuccessWithStatus:responseObject[@"msg"]];
            
            double delayInSeconds = 1;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self.navigationController popViewControllerAnimated:YES];
                [SVProgressShow dismiss];
            });
        }
        else {
            [SVProgressShow showInfoWithStatus:responseObject[@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:++++%@",error.localizedDescription);
    }];
    
}

@end
