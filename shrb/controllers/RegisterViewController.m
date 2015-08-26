//
//  RegisterViewController.m
//  shrb
//
//  Created by PayBay on 15/7/13.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "RegisterViewController.h"
#import "TNCheckBoxData.h"
#import "TNCheckBoxGroup.h"
#import "Const.h"

@interface RegisterViewController () {
  //  TNCheckBoxGroup *_loveGroup;
}
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *captchaTextField;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet TNCheckBoxGroup *loveGroup;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TNImageCheckBoxData *manData = [[TNImageCheckBoxData alloc] init];
    manData.identifier = @"man";
    manData.labelText = @"同意《通宝用户协议》";
    manData.checked = YES;
    manData.checkedImage = [UIImage imageNamed:@"checked"];
    manData.uncheckedImage = [UIImage imageNamed:@"unchecked"];
    
    self.loveGroup.checkBoxData = @[manData];
    self.loveGroup.layout = TNCheckBoxLayoutVertical;
    self.loveGroup.labelColor = [UIColor whiteColor];
    [self.loveGroup create];
    
 //   self.loveGroup.position = CGPointMake(40, 260);
  //  [self.loveGroup insertSubview:self.backView atIndex:0];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loveGroupChanged:) name:GROUP_CHANGED object:_loveGroup];

}

- (void)viewDidLayoutSubviews
{
   //
}

- (IBAction)backBtnPressed:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)getCodeBtnPressed:(id)sender {
    
    NSString *url=[baseUrl stringByAppendingString:@"/user/v1.0/getCode?"];
    [self.requestOperationManager GET:url parameters:@{@"phone":self.phoneTextField.text} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject[@"msg"]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error:++++%@",error.localizedDescription);
    }];
    
}



- (IBAction)sureBtnPressed:(id)sender {
    
    NSString *url2=[baseUrl stringByAppendingString:@"/user/v1.0/register?"];
    [self.requestOperationManager POST:url2 parameters:@{@"phone":self.phoneTextField.text,@"password":self.passwordTextField.text,@"code":self.captchaTextField.text} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject[@"msg"]);
        
        if ([responseObject[@"code"] isEqualToString:@"200"]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"operation %@ error:++++%@",operation, error.localizedDescription);
    }];
}

#pragma mark - 单击键盘return键回调
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.phoneTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.captchaTextField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if ([[touches anyObject]view]!=self.phoneTextField||[[touches anyObject]view]!=self.passwordTextField||[[touches anyObject]view]!= self.captchaTextField) {
        [self.phoneTextField resignFirstResponder];
        [self.passwordTextField resignFirstResponder];
        [self.captchaTextField resignFirstResponder];
    }

}

#pragma mark - 单选框点击调用
- (void)loveGroupChanged:(NSNotification *)notification {
    
    NSLog(@"Checked checkboxes %@", _loveGroup.checkedCheckBoxes);
    NSLog(@"Unchecked checkboxes %@", _loveGroup.uncheckedCheckBoxes);
    
}



@end
