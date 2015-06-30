//
//  DeskNumTableViewCell.m
//  shrb
//
//  Created by PayBay on 15/6/29.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "DeskNumTableViewCell.h"

@interface DeskNumTableViewCell () <UITextFieldDelegate>


@end

@implementation DeskNumTableViewCell


#pragma mark - 单击键盘return键回调
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.deskTextField resignFirstResponder];
    return YES;
}

- (void)awakeFromNib {
    self.deskTextField.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
