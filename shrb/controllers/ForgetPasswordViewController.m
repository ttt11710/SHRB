//
//  ForgetPasswordViewController.m
//  shrb
//
//  Created by PayBay on 15/7/13.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "SVProgressShow.h"

@interface ForgetPasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *memberNumField;
@property (weak, nonatomic) IBOutlet UITextField *captchaTextField;

@end

@implementation ForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (IBAction)backBtnPressed:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 单击键盘return键回调
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.captchaTextField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if ([[touches anyObject]view]!=self.captchaTextField) {
        [self.captchaTextField resignFirstResponder];
    }
}


@end
