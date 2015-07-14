//
//  ChangePasswordViewController.m
//  shrb
//
//  Created by PayBay on 15/7/13.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController ()

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *surePasswordTextField;


@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (IBAction)backBtnPressed:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sureBtnPressed:(id)sender {
    
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}

#pragma mark - 单击键盘return键回调
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.passwordTextField resignFirstResponder];
    [self.surePasswordTextField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if ([[touches anyObject]view]!=self.passwordTextField||[[touches anyObject]view]!= self.surePasswordTextField) {
        [self.passwordTextField resignFirstResponder];
        [self.surePasswordTextField resignFirstResponder];
    }
}

@end
