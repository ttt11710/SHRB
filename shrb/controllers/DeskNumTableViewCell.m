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


static DeskNumTableViewCell *g_DeskNumTableViewCell = nil;


+ (DeskNumTableViewCell *)shareDeskNumTableViewCell
{
    return g_DeskNumTableViewCell;
}

#pragma mark - 单击键盘return键回调
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.deskTextField resignFirstResponder];
    return YES;
}

- (void)deskTextFieldResignFirstResponder:(NSSet *)touches
{
    if ([[touches anyObject]view]!= self.deskTextField ) {
        [self.deskTextField resignFirstResponder];
    }
}

- (void)deskTextFieldResignFirstResponder
{
    [self.deskTextField resignFirstResponder];
}

- (void)awakeFromNib {
    self.deskTextField.delegate = self;
    g_DeskNumTableViewCell = self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if ([[touches anyObject]view]!= self.deskTextField ) {
        [self.deskTextField resignFirstResponder];    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
