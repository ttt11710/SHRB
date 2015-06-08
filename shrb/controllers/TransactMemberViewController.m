//
//  TransactViewController.m
//  shrb
//
//  Created by PayBay on 15/5/21.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "TransactMemberViewController.h"
#import "Const.h"

@interface TransactMemberViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation TransactMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark textfield的deletage事件
//键盘即将显示的时候回调
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (IsiPhone4s? YES:NO) {
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^
         {
             self.view.layer.transform = CATransform3DTranslate(self.view.layer.transform, 0, -180,0);
         }completion:^(BOOL finished){}];
    }
}
//键盘即将消失的时候回调
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^
     {
         self.view.layer.transform = CATransform3DIdentity;
     }completion:^(BOOL finished){}];
}

#pragma mark - 单击键盘return键回调
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.phoneNumberTextField resignFirstResponder];
    [self.moneyTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    return YES;
}


@end
