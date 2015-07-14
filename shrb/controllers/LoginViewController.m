//
//  LoginViewController.m
//  shrb
//
//  Created by PayBay on 15/7/13.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "LoginViewController.h"
#import "MainTabBarController.h"
#import "SVProgressShow.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    
}
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;

}


- (IBAction)loginInBtnPressed:(id)sender {
    
    [SVProgressShow showWithStatus:@"拼命登录中..."];
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(todoSomething) object:nil];
    [self performSelector:@selector(todoSomething) withObject:nil afterDelay:0.5f];
    
}

- (void)todoSomething
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"IsLogin"];
    [SVProgressShow dismiss];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancelBtnPressed:(id)sender {
    
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
    
   // [[MainTabBarController shareMainTabBarController] showHotView];
}

#pragma mark - 单击键盘return键回调
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.passwordTextField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if ([[touches anyObject]view]!=self.passwordTextField) {
        [self.passwordTextField resignFirstResponder];
    }
}

@end
