//
//  AppleRefundTableViewCell.m
//  shrb
//
//  Created by PayBay on 15/8/24.
//  Copyright © 2015年 PayBay. All rights reserved.
//

#import "AppleRefundTableViewCell.h"
#import "Const.h"

@interface AppleRefundTableViewCell () <UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;
@property (weak, nonatomic) IBOutlet UITextView *explainTextView;

@end


@implementation AppleRefundTableViewCell
- (IBAction)appleRefundBtnPressed:(UIButton *)sender {
    self.callBack(self.moneyTextField.text);
}

#pragma mark - 键盘即将显示的时候回调
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    UITableView *tableView = (UITableView *)self.superview.superview;
    
    [tableView setContentOffset:CGPointMake(0, tableView.contentSize.height -tableView.bounds.size.height) animated:YES];
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        self.layer.transform =CATransform3DMakeTranslation(0, -100, 0);
        
    } completion:^(BOOL finished) {
        
    }];
    
}

#pragma mark - 键盘即将消失的时候回调
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        self.layer.transform = CATransform3DIdentity;
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    UITableView *tableView = (UITableView *)self.superview.superview;
    
    [tableView setContentOffset:CGPointMake(0, tableView.contentSize.height -tableView.bounds.size.height) animated:YES];
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        self.layer.transform =CATransform3DMakeTranslation(0, -200, 0);
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        self.layer.transform = CATransform3DIdentity;
        
    } completion:^(BOOL finished) {
        
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
    [self.moneyTextField resignFirstResponder];
    [self.explainTextView resignFirstResponder];
}

#pragma mark - 点击界面键盘失去响应
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if ([[touches anyObject]view]!=self.moneyTextField || [[touches anyObject]view]!=self.explainTextView) {
        [self textFieldResignFirstResponder];
    }
}

- (void)awakeFromNib {
    
    self.moneyTextField.delegate = self;
    self.explainTextView.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
