//
//  ProductTableViewCell.m
//  shrb
//
//  Created by PayBay on 15/6/26.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "ProductTableViewCell.h"
#import "ProductModel.h"
#import <BFPaperButton.h>
#import "Const.h"
#import "SuperBecomeMemberView1.h"
#import "ProductIsMemberTableViewController.h"

@interface ProductTableViewCell () {
    
    SuperBecomeMemberView1 *_becomeMemberView;
    UIButton *_smallbuttonModel;
    CGRect _bounds;
}

@property (weak, nonatomic) IBOutlet UIView *cardDetailView;

@property (weak, nonatomic) IBOutlet UIView *imageShadowView;

@property (weak, nonatomic) IBOutlet UIView *ImageBackView;
@property (weak, nonatomic) IBOutlet UILabel *saveMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *signInBtn;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *integralLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardNumberLabel;


@end
@implementation ProductTableViewCell

- (void)setModel:(ProductModel *)model
{
    self.tradeImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",model.tradeImage]];
    self.signInBtn.layer.cornerRadius = 4;
    self.signInBtn.layer.masksToBounds = YES;
    self.saveMoneyLabel.text = [NSString stringWithFormat:@"省￥%@元",model.saveMoney];
    self.descriptionLabel.text = model.tradeDescription;
    self.moneyLabel.text = [NSString stringWithFormat:@"金额：%@元",model.money];
    self.integralLabel.text = [NSString stringWithFormat:@"积分：%@",model.integral];
    self.cardNumberLabel.text = [NSString stringWithFormat:@"卡号：%@",model.cardNumber];

}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.imageShadowView.layer.cornerRadius = 10;
    self.imageShadowView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.imageShadowView.layer.shadowOffset = CGSizeMake(2,2);
    self.imageShadowView.layer.shadowOpacity = 0.5;
    self.imageShadowView.layer.shadowRadius = 2.0;
    
    self.ImageBackView.layer.cornerRadius = 10;
    self.ImageBackView.layer.masksToBounds = YES;
    
    self.saveMoneyLabel.textColor = shrbPink;
    
    [self.signInBtn addTarget:self action:@selector(buttonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addBlurViewView:self.blurView];
    
    
    UITapGestureRecognizer *gotoCardDetailTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoCardDetailTap)];
    [self.cardDetailView addGestureRecognizer:gotoCardDetailTap];
}

#pragma mark - 注册
- (void)buttonWasPressed:(id)sender
{
    
    if (_becomeMemberView == nil) {
        _becomeMemberView = [[SuperBecomeMemberView1 alloc] initWithFrame:CGRectMake(screenWidth, self.signInBtn.frame.origin.y, screenWidth/2, 180)];
        [self addSubview:_becomeMemberView];
        
        _smallbuttonModel = [UIButton buttonWithType:UIButtonTypeCustom];
        _smallbuttonModel.frame = CGRectMake(screenWidth/2-45,  self.signInBtn.frame.origin.y, 90, 44);
        _smallbuttonModel.hidden = YES;
        _smallbuttonModel.layer.cornerRadius = 4;
        _smallbuttonModel.layer.masksToBounds = YES;
        [_smallbuttonModel setTitle:@"注册" forState:UIControlStateNormal];
        [_smallbuttonModel setTintColor:[UIColor clearColor]];
        [_smallbuttonModel setBackgroundColor:shrbPink];
        [_smallbuttonModel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_smallbuttonModel addTarget:self action:@selector(sureBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_smallbuttonModel];
    }
    
    if (_bounds.size.width == 0) {
        _bounds = self.signInBtn.bounds;
    }
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        CGRect bounds = _bounds;
        bounds.size.width = bounds.size.width/4;
        self.signInBtn.bounds = bounds;
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            self.signInBtn.hidden = YES;
            _smallbuttonModel.hidden = NO;
            _smallbuttonModel.layer.transform = CATransform3DMakeTranslation(-(screenWidth/2-_smallbuttonModel.frame.size.width)-30, 0, 0);
            
            _becomeMemberView.layer.transform = CATransform3DTranslate(_becomeMemberView.layer.transform, -210, 0, 0);
            
            
        } completion:^(BOOL finished) {
            
            
        }];
        
    }];
    
}

#pragma mark - 确定注册
- (void)sureBtnPressed
{
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        _smallbuttonModel.layer.transform = CATransform3DIdentity;
        
        _becomeMemberView.layer.transform = CATransform3DIdentity;
        
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            _smallbuttonModel.hidden = YES;
            self.signInBtn.hidden = NO;
            
            self.signInBtn.bounds = _bounds;
            
        } completion:^(BOOL finished) {
            
            [[SuperBecomeMemberView1 shareSuperBecomeMemberView] textFieldResignFirstResponder];
            
        }];
        
    }];
    
}

#pragma mark - 蒙版效果
- (void)addBlurViewView:(UIView *)view
{
    if (IsIOS8) {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurEffectView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        blurEffectView.frame =  view.bounds;
        [view insertSubview:blurEffectView atIndex:0];
    }
    else{
        UIView *blurEffectView = [[UIView alloc] init];
        blurEffectView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        blurEffectView.frame = view.bounds;
        [view insertSubview:blurEffectView atIndex:0];
    }
}


#pragma mark - 会员卡详情页面
- (void)gotoCardDetailTap
{
    
    [[ProductIsMemberTableViewController shareProductIsMemberTableViewController] gotoCardDetailView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
