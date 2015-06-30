//
//  MemberPayTableViewCell.m
//  shrb
//
//  Created by PayBay on 15/6/29.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "MemberPayTableViewCell.h"
#import "Const.h"

@interface MemberPayTableViewCell () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation MemberPayTableViewCell



- (void)awakeFromNib {
    // Initialization code
    
    self.passwordTextField.delegate = self;
}

//键盘即将显示的时候回调
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        self.superview.layer.transform = CATransform3DTranslate(self.superview.layer.transform, 0, -216, 0);
        
    } completion:^(BOOL finished) {
        
    }];

}
//键盘即将消失的时候回调
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        self.superview.layer.transform = CATransform3DIdentity;
        
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - 单击键盘return键回调
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.passwordTextField resignFirstResponder];
    return YES;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
