//
//  VoucherAmoutTableViewCell.m
//  shrb
//
//  Created by PayBay on 15/8/28.
//  Copyright © 2015年 PayBay. All rights reserved.
//

#import "VoucherAmoutTableViewCell.h"
#import "Const.h"

@implementation VoucherAmoutTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.amountTextField.delegate = self;
}


#pragma mark textfield的deletage事件
//键盘即将显示的时候回调
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if (IsiPhone4s) {
        UITableView *tableView = (UITableView *)self.superview.superview;
        
        [tableView setContentOffset:CGPointMake(0, tableView.contentSize.height -tableView.bounds.size.height-100) animated:YES];
        
        
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            self.superview.superview.layer.transform =CATransform3DMakeTranslation(0, -100, 0);
            
        } completion:^(BOOL finished) {
            
        }];
    }
}

//键盘即将消失的时候回调
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (IsiPhone4s) {
        
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            self.superview.superview.layer.transform = CATransform3DIdentity;
            
        } completion:^(BOOL finished) {
            
        }];
    }
}

#pragma mark - 单击键盘return键回调
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.amountTextField resignFirstResponder];
    return YES;
}

#pragma mark - 单击屏幕键盘消失
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if ([[touches anyObject]view]!= self.amountTextField) {
        [self.amountTextField resignFirstResponder];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
