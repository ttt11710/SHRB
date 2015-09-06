//
//  NewForgetPasswordViewController.m
//  shrb
//
//  Created by PayBay on 15/8/28.
//  Copyright © 2015年 PayBay. All rights reserved.
//

#import "NewForgetPasswordViewController.h"
#import "Const.h"
#import "SVProgressShow.h"

@interface NewForgetPasswordViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *captchaTextField;
@property (weak, nonatomic) IBOutlet UITextField *myNewPassTextField;

@end

@implementation NewForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

- (IBAction)getCodeBtnPressed:(id)sender {
    
    NSString *url=[baseUrl stringByAppendingString:@"/user/v1.0/getCode?"];
    [self.requestOperationManager GET:url parameters:@{@"phone":self.phoneTextField.text} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"getCode operation = %@ JSON: %@", operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error:++++%@",error.localizedDescription);
    }];
    
}

- (IBAction)setPassBtnPressed:(id)sender {
    
    
}



@end
