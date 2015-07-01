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

@interface ButtonTableViewCell () {
    
    BecomeMemberView *_becomeMemberView;
    UIButton *_sureBtn;
    CGRect _bounds;
    BOOL _flag ;
}

@end
@implementation ButtonTableViewCell


- (void)awakeFromNib {
        
    self.buttonModel.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:120.0/255.0 blue:161.0/255.0 alpha:1];
    [self.buttonModel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
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
    
    if (_becomeMemberView == nil) {
        _becomeMemberView = [[BecomeMemberView alloc] initWithFrame:CGRectMake(screenWidth, 10, screenWidth/2, 180)];
        [self addSubview:_becomeMemberView];
        
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBtn.frame = CGRectMake(screenWidth/2-45,  self.buttonModel.frame.origin.y, 90, 44);
        _sureBtn.hidden = YES;
        [_sureBtn setTitle:@"注册" forState:UIControlStateNormal];
        [_sureBtn setTintColor:[UIColor clearColor]];
        [_sureBtn setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:120.0/255.0 blue:161.0/255.0 alpha:1]];
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(sureBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_sureBtn];
    }
    
    if (_bounds.size.width == 0) {
        _bounds = self.buttonModel.bounds;
    }
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        CGRect bounds = _bounds;
        bounds.size.width = bounds.size.width/4;
        self.buttonModel.bounds = bounds;
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            self.buttonModel.hidden = YES;
            _sureBtn.hidden = NO;
            _sureBtn.layer.transform = CATransform3DMakeTranslation(-(screenWidth/2-_sureBtn.frame.size.width)-20, 0, 0);
            
            _becomeMemberView.layer.transform = CATransform3DTranslate(_becomeMemberView.layer.transform, -210, 0, 0);
            
            
        } completion:^(BOOL finished) {
            
            
        }];
        
    }];
    
}


- (void)sureBtnPressed
{
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        _sureBtn.layer.transform = CATransform3DIdentity;
        
        _becomeMemberView.layer.transform = CATransform3DIdentity;
        
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            _sureBtn.hidden = YES;
            self.buttonModel.hidden = NO;
        
            self.buttonModel.bounds = _bounds;
            
        } completion:^(BOOL finished) {
            
            [[BecomeMemberView shareBecomeMemberView] textFieldResignFirstResponder];
            
        }];
        
    }];
 
}


@end
