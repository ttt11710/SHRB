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
#import <POP/POP.h>

@interface ButtonTableViewCell () {
    
    BecomeMemberView *_becomeMemberView;
    UIButton *_smallbuttonModel;
    CGRect _bounds;
}

@end
@implementation ButtonTableViewCell


- (void)awakeFromNib {
        
    self.buttonModel.backgroundColor = shrbPink;
    [self.buttonModel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.buttonModel.layer.cornerRadius = 10;
    self.buttonModel.layer.masksToBounds = YES;
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
        _becomeMemberView = [[BecomeMemberView alloc] initWithFrame:CGRectMake(screenWidth+10, 10, screenWidth/2, 180)];
        [self addSubview:_becomeMemberView];
        
        _smallbuttonModel = [UIButton buttonWithType:UIButtonTypeCustom];
        _smallbuttonModel.frame = CGRectMake(screenWidth/2-45,  self.buttonModel.frame.origin.y, 90, 44);
        _smallbuttonModel.hidden = YES;
        _smallbuttonModel.layer.cornerRadius = 4;
        _smallbuttonModel.layer.masksToBounds = YES;
        [_smallbuttonModel setTitle:@"会员注册" forState:UIControlStateNormal];
        [_smallbuttonModel setTintColor:[UIColor clearColor]];
        [_smallbuttonModel setBackgroundColor:shrbPink];
        [_smallbuttonModel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_smallbuttonModel addTarget:self action:@selector(sureBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_smallbuttonModel];
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
            _smallbuttonModel.hidden = NO;
            _smallbuttonModel.layer.transform = CATransform3DMakeTranslation(-(screenWidth/2-_smallbuttonModel.frame.size.width)-30, 0, 0);
            
            _becomeMemberView.layer.transform = CATransform3DTranslate(_becomeMemberView.layer.transform, -220, 0, 0);
            
            
        } completion:^(BOOL finished) {
            
            //pop大小缩放
            POPSpringAnimation *sizeAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
            sizeAnimation.springSpeed = 0.f;
            sizeAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, _smallbuttonModel.frame.size.width+5, _smallbuttonModel.frame.size.height+5)];
            [_smallbuttonModel pop_addAnimation:sizeAnimation forKey:nil];
            
            
            //pop左右弹动
            POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
            positionAnimation.velocity = @2000;
            positionAnimation.springBounciness = 20;
            [positionAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
                _smallbuttonModel.userInteractionEnabled = YES;
            }];
            [_smallbuttonModel.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
            
        }];
        
    }];
    
}


- (void)sureBtnPressed
{
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        _smallbuttonModel.layer.transform = CATransform3DIdentity;
        
        _becomeMemberView.layer.transform = CATransform3DIdentity;
        
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            _smallbuttonModel.hidden = YES;
            self.buttonModel.hidden = NO;
        
            self.buttonModel.bounds = _bounds;
            
        } completion:^(BOOL finished) {
            
            [[BecomeMemberView shareBecomeMemberView] textFieldResignFirstResponder];
            
            POPSpringAnimation *sizeAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
            sizeAnimation.springSpeed = 0.f;
            sizeAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, _smallbuttonModel.frame.size.width-5, _smallbuttonModel.frame.size.height-5)];
            [_smallbuttonModel pop_addAnimation:sizeAnimation forKey:nil];
            
        }];
        
    }];
 
}



@end
