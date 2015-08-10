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
#import "SVProgressShow.h"
#import "DOPScrollableActionSheet.h"
#import <POP/POP.h>
#import "FoldingView.h"
#import "UIImageView+WebCache.h"


#define imageWidth  screenWidth-32
#define imageHeight  screenWidth-32

@interface ProductTableViewCell () {
    
    SuperBecomeMemberView1 *_becomeMemberView;
    UIButton *_smallbuttonModel;
    CGRect _bounds;
    
    //照片轮播时间
    NSTimer   *_timer;
    //图片数组
    NSArray *_imageArray;
}

@property (weak, nonatomic) IBOutlet UIView *cardDetailView;

@property (weak, nonatomic) IBOutlet UIView *imageShadowView;


@property (weak, nonatomic) IBOutlet UILabel *saveMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *signInBtn;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *integralLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardNumberLabel;

@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end
@implementation ProductTableViewCell

- (void)setModel:(ProductModel *)model
{
    self.tradeImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",model.tradeImage]];
    _imageArray = [[NSMutableArray alloc] initWithObjects:
                   @"http://static.lover1314.me/image/2015/04/16/1552f5e302fae3_orig.jpg",
                   @"http://static.lover1314.me/image/2015/04/16/1552f5e2b1fee1_orig.jpg",
                   @"http://static.lover1314.me/image/2015/04/16/1552f5e1903f9b_orig.jpg", nil];
    


    
    self.tradeImageView.hidden = YES;
    self.imageShadowView.hidden = YES;
    [self.ImageBackView myInitWithFrame:CGRectMake(0, 0, screenWidth-48, screenWidth-48) image:[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",model.tradeImage]]];
    
    
    self.signInBtn.layer.cornerRadius = 4;
    self.signInBtn.layer.masksToBounds = YES;
    self.saveMoneyLabel.text = [NSString stringWithFormat:@"省￥%@元",model.saveMoney];
    self.descriptionLabel.text = model.tradeDescription;
    self.moneyLabel.text = [NSString stringWithFormat:@"金额：%@元",model.money];
    self.integralLabel.text = [NSString stringWithFormat:@"积分：%@",model.integral];
    self.cardNumberLabel.text = [NSString stringWithFormat:@"卡号：%@",model.cardNumber];
    
    for (int i = 0 ; i < [_imageArray count]; i++)
    {
        UIImageView *_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageWidth *i, 0, imageWidth, imageHeight)];
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [_imageView sd_setImageWithURL:[NSURL URLWithString:[_imageArray objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"默认女头像"]];
        [_imageScrollView addSubview:_imageView];
    }
    _imageScrollView.contentSize = CGSizeMake(imageWidth*[_imageArray count] , imageHeight);
    _pageControl.numberOfPages = [_imageArray count];
    
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.imageShadowView.layer.cornerRadius = 10;
    self.imageShadowView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.imageShadowView.layer.shadowOffset = CGSizeMake(0,2);
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
//    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"IsLogin"];
//    if (!isLogin) {
//        [SVProgressShow showInfoWithStatus:@"请先登录！"];
//        return ;
//    }
    
    if (_becomeMemberView == nil) {
        _becomeMemberView = [[SuperBecomeMemberView1 alloc] initWithFrame:CGRectMake(screenWidth, self.signInBtn.frame.origin.y, screenWidth/2, 220)];
        [self addSubview:_becomeMemberView];
        
        _smallbuttonModel = [UIButton buttonWithType:UIButtonTypeCustom];
        _smallbuttonModel.frame = CGRectMake(screenWidth/2-45,  self.signInBtn.frame.origin.y, 90, 44);
        _smallbuttonModel.font = [UIFont systemFontOfSize:15.0f];
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
            POPSpringAnimation *sizeAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
            sizeAnimation.springSpeed = 0.f;
            sizeAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, _smallbuttonModel.frame.size.width-5, _smallbuttonModel.frame.size.height-5)];
            [_smallbuttonModel pop_addAnimation:sizeAnimation forKey:nil];
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

#pragma mark - 收藏
- (IBAction)collectBtnPressed:(id)sender {
    [SVProgressShow showWithStatus:@"收藏中..."];
    double delayInSeconds = 1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [SVProgressShow showSuccessWithStatus:@"收藏成功！"];
    });

}

#pragma mark - 分享
- (IBAction)shareBtnPressed:(id)sender {
    DOPAction *action1 = [[DOPAction alloc] initWithName:@"Wechat" iconName:@"weixin" handler:^{
        [SVProgressShow showSuccessWithStatus:@"微信分享成功！"];
    }];
    DOPAction *action2 = [[DOPAction alloc] initWithName:@"QQ" iconName:@"qq" handler:^{
        [SVProgressShow showSuccessWithStatus:@"QQ分享成功！"];
    }];
    DOPAction *action3 = [[DOPAction alloc] initWithName:@"WxFriends" iconName:@"wxFriends" handler:^{
        [SVProgressShow showSuccessWithStatus:@"微信朋友圈分享成功！"];
    }];
    DOPAction *action4 = [[DOPAction alloc] initWithName:@"Qzone" iconName:@"qzone" handler:^{
        [SVProgressShow showSuccessWithStatus:@"QQ空间分享成功！"];
    }];
    DOPAction *action5 = [[DOPAction alloc] initWithName:@"Weibo" iconName:@"weibo" handler:^{
        [SVProgressShow showSuccessWithStatus:@"新浪微博分享成功！"];
    }];
    DOPAction *action6 = [[DOPAction alloc] initWithName:@"SMS" iconName:@"sms" handler:^{
        [SVProgressShow showSuccessWithStatus:@"短信发送成功！"];
    }];
    DOPAction *action7 = [[DOPAction alloc] initWithName:@"Email" iconName:@"email" handler:^{
        [SVProgressShow showSuccessWithStatus:@"邮件发送成功！"];
    }];
    
    
    NSArray *actions;
    actions = @[@"Share",
                @[action1, action2, action3, action4],
                @"",
                @[action5, action6, action7]];
    DOPScrollableActionSheet *as = [[DOPScrollableActionSheet alloc] initWithActionArray:actions];
    [as show];

}



@end
