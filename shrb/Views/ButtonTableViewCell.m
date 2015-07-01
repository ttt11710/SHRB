//
//  ButtonTableViewCell.m
//  shrb
//
//  Created by PayBay on 15/5/20.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "ButtonTableViewCell.h"
#import "Const.h"
#import "BecomeMemberView.h"

@implementation ButtonTableViewCell

- (void)awakeFromNib {
    self.buttonModel.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:120.0/255.0 blue:161.0/255.0 alpha:1];
    [self.buttonModel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.buttonModel setTitleFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.f]];
//    self.buttonModel.usesSmartColor = NO;
    [self.buttonModel addTarget:self action:@selector(buttonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)buttonWasPressed:(id)sender
{
    NSLog(@"%@ was pressed!", ((UIButton *)sender).titleLabel.text);
    
    if ([((UIButton *)sender).titleLabel.text isEqualToString:@"扫码加单"]) {
        return ;
    }
    
    BecomeMemberView *view = [[BecomeMemberView alloc] initWithFrame:CGRectMake(screenWidth, 10, screenWidth/2, 180)];
    [self addSubview:view];
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{

        CGRect bounds = self.buttonModel.bounds;
        bounds.size.width = bounds.size.width/4;
        self.buttonModel.bounds = bounds;
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            self.buttonModel.layer.transform = CATransform3DTranslate(self.buttonModel.layer.transform, -(screenWidth/2-self.buttonModel.frame.size.width)-20, 0, 0);
            
            view.layer.transform = CATransform3DTranslate(view.layer.transform, -screenWidth/2-30, 0, 0);
            
        } completion:^(BOOL finished) {
            
        }];

    }];
    
//    CGRect bounds = self.buttonModel.bounds;
//    bounds.size.width = bounds.size.width/2;
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:1.0];
//    //放大缩小了的bounds放回到原来button中
//    self.buttonModel.bounds = bounds;
//    //提交动画
//    [UIView commitAnimations];
//
}

@end
