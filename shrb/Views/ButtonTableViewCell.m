//
//  ButtonTableViewCell.m
//  shrb
//
//  Created by PayBay on 15/5/20.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "ButtonTableViewCell.h"

@implementation ButtonTableViewCell

- (void)awakeFromNib {
    self.buttonModel.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:120.0/255.0 blue:161.0/255.0 alpha:1];
    [self.buttonModel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.buttonModel setTitleFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.f]];
    self.buttonModel.usesSmartColor = NO;
    [self.buttonModel addTarget:self action:@selector(buttonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)buttonWasPressed:(id)sender
{
    NSLog(@"%@ was pressed!", ((UIButton *)sender).titleLabel.text);
}

@end
