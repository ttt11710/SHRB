//
//  ProductDescriptionView.m
//  shrb
//
//  Created by PayBay on 15/5/21.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "ProductDescriptionView.h"
#import "Const.h"

@interface ProductDescriptionView ()

@property(nonatomic,retain)UIView *mainView;
@property(nonatomic,retain)UIView *descriptionView;

@end

@implementation ProductDescriptionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled=YES;
        self.backgroundColor=[UIColor colorWithWhite:0 alpha:0.5];
        
        [self initSubView];
    }
    return self;
}

- (void)initSubView
{
    _mainView=[[UIView alloc]initWithFrame:CGRectMake(screenWidth/10, screenHeight/8+44, 4*screenWidth/5, 3*screenHeight/4)];
    _mainView.backgroundColor=[UIColor clearColor];
    [self addSubview:_mainView];
    
    _descriptionView=[[UIView alloc]initWithFrame:CGRectMake(0,0, 4*screenWidth/5, 3*screenHeight/4)];
    _descriptionView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    _descriptionView.userInteractionEnabled=YES;
    
    [_mainView addSubview:_descriptionView];
    
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 12, 100, 21)];
    nameLabel.text = @"产品名称";
    nameLabel.textColor = [UIColor blackColor];
    [_descriptionView addSubview:nameLabel];
    
    UIImageView *descriptionImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, nameLabel.frame.origin.y+nameLabel.frame.size.height+4, 4*screenWidth/5-12*2, 4*screenWidth/5-50)];
    descriptionImageView.image = [UIImage imageNamed:@"官方头像"];
    [_descriptionView addSubview:descriptionImageView];
    [self addBlurViewView:descriptionImageView];
    
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, descriptionImageView.frame.size.height-26, 100, 21)];
    moneyLabel.text = @"省 40元";
    moneyLabel.textColor = [UIColor orangeColor];
    [descriptionImageView addSubview:moneyLabel];
    
    UITextView *descriptionTextView = [[UITextView alloc] initWithFrame:CGRectMake(12, descriptionImageView.frame.origin.y+descriptionImageView.frame.size.height+4, 4*screenWidth/5-12*2, 100)];
    descriptionTextView.text = @"产品描述：\n换房间号开奖时间快女空间撒绝望iorhewkjfhkjdshnjfkndlkajlhjfkhshoirejk加快了交罚款了简单撒开了健康hi而近日将开发计划开工可接受的几女健康时间发货快睡觉。。。";
    descriptionTextView.backgroundColor = [UIColor whiteColor];
    descriptionTextView.textColor = [UIColor grayColor];
    descriptionTextView.editable = NO;
    [_descriptionView addSubview:descriptionTextView];
    
    UIButton *closeButton=[[UIButton alloc]initWithFrame:CGRectMake(4*screenWidth/5-39, 12, 27, 27)];
    [closeButton setImage:[UIImage imageNamed:@"cancle"] forState:UIControlStateNormal];
    [closeButton setImage:[UIImage imageNamed:@"cancle_pressed"] forState:UIControlStateHighlighted];
    [closeButton addTarget:self action:@selector(closeButtonEven) forControlEvents:UIControlEventTouchUpInside];
    [_descriptionView addSubview:closeButton];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if ([[touches anyObject]view]!=_mainView &&[[touches anyObject]view]!=_descriptionView) {
        self.hidden=YES;
    }
}

-(void)closeButtonEven{
    self.hidden=YES;
}

#pragma mark - 蒙版效果
- (void)addBlurViewView:(UIView *)view
{
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
     UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = CGRectMake(0, view.frame.size.height-30, view.frame.size.width, 30);
    [view insertSubview:blurEffectView atIndex:0];
}

@end
