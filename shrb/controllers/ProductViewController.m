//
//  ProductViewController.m
//  shrb
//
//  Created by PayBay on 15/7/22.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "ProductViewController.h"
#import "SuperBecomeMemberView1.h"
#import "Const.h"
#import "UIImageView+WebCache.h"
#import <POP/POP.h>
#import "BecomeMemberView.h"
#import "DOPScrollableActionSheet.h"
#import "SVProgressShow.h"
#import "ProductIsMemberViewController.h"
#import "ShowMeImageViewController.h"
#import "RegisteringStoreMemberViewController.h"
#import "TBUser.h"

static ProductViewController *g_ProductViewController = nil;

@interface ProductViewController ()
{
    NSMutableArray *_imageArray;
    CGRect _bounds;
    
    NSTimer *_timer;
}

@property(nonatomic,retain) UIScrollView *mainScrollView;//整个界面ScrollView

@property(nonatomic,retain) UIView *cardView;//展示卡片View
@property(nonatomic,retain) UIScrollView *cardScrollView;//卡片ScrollView
@property (retain, nonatomic) UIPageControl *imagePageControl; //卡片page
@property(nonatomic,retain) UIImageView *cardPhotoView;//卡片图片
@property(nonatomic,retain) UIView *blurEffectView;//毛玻璃View
@property (retain, nonatomic) UIButton *collectBtn;     //收藏
@property (retain, nonatomic) UIButton *shareBtn;       //分享

@property(nonatomic,retain) UIView *tradeNameAndPriceView;//商品名和价格View
@property (retain, nonatomic) UILabel *prodNameLabel; //商品名
@property (retain, nonatomic) UILabel *vipPriceLabel; //会员价
@property (retain, nonatomic) UILabel *saveMoneyLabel; //节省价格
@property (retain, nonatomic) UILabel *priceLabel; //原价

@property(nonatomic,retain) UIView *descriptionAndregisterView;//产品描述与注册View
@property (retain, nonatomic) UILabel *prodDescLabel; //产品描述
@property (retain, nonatomic) UIButton *registerBtn;     //注册
@property (retain, nonatomic) SuperBecomeMemberView1 *becomeMemberView; //注册弹出界面
@property (retain, nonatomic) UIButton *smallbutton; //注册弹出button


@end

@implementation ProductViewController

@synthesize productDataDic;


+ (ProductViewController *)shareProductViewController
{
    return g_ProductViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    g_ProductViewController = self;
    
    [self initData];
    [self initMainView];
    [self initCardView];
    [self initTradeNameAndPriceView];
    [self initDescriptionAndregisterView];
    
    [self cardAnimation];
    
}



- (void)viewWillAppear:(BOOL)animated {
    
  //  self.tabBarController.tabBar.hidden = YES;
    
    [super viewWillAppear:animated];
    
    if (!_timer.isValid) {
        [self startTime];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    if (_timer.isValid) {
       [_timer invalidate];
    }
}


- (void)initData
{
    _imageArray = [[NSMutableArray alloc] init];
    for (int i = 0 ; i < [self.productDataDic[@"imgList"] count]; i++) {
        [_imageArray addObject:[self.productDataDic[@"imgList"] objectAtIndex:i][@"imgUrl"]];
    }
    
    self.title = @"商品详情";
}

- (void)initMainView
{
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    _mainScrollView.backgroundColor = shrbTableViewColor;
    [self.view addSubview:_mainScrollView];
}

-(void)initCardView
{
    _cardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenWidth/1.37)];
    _cardView.backgroundColor=[UIColor whiteColor];
    
    [_mainScrollView addSubview:_cardView];
    
    _cardScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _cardView.frame.size.width, _cardView.frame.size.height)];
    _cardScrollView.contentSize = CGSizeMake(_cardScrollView.frame.size.width*([_imageArray count]+2), 0);
    _cardScrollView.contentOffset = CGPointMake(_cardScrollView.frame.size.width, 0);
    _cardScrollView.delegate = self;
    _cardScrollView.pagingEnabled = YES;
    _cardScrollView.showsHorizontalScrollIndicator = NO;
    _cardScrollView.showsVerticalScrollIndicator = NO;
    [_cardView addSubview:_cardScrollView];
    
    _imagePageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, _cardView.frame.size.height-30, _cardView.frame.size.width, 20)];
    _imagePageControl.numberOfPages = [_imageArray count];
    _imagePageControl.currentPage = 0;
    [_imagePageControl addTarget:self action:@selector(pageControlValueChanged) forControlEvents:UIControlEventValueChanged];
    _imagePageControl.currentPageIndicatorTintColor = shrbPink;
    _imagePageControl.pageIndicatorTintColor = [UIColor whiteColor];
    [_cardView addSubview:_imagePageControl];
    
    if ([_imageArray count]<= 0 ) {
        UIImageView *_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(_cardScrollView.frame.size.width, 0, _cardScrollView.frame.size.width, _cardScrollView.frame.size.height)];
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [_imageView sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"官方头像"]];
        [_cardScrollView addSubview:_imageView];

    }
    else {
        for (int i = 0 ; i < [_imageArray count]+2; i++)
        {
            UIImageView *_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(_cardScrollView.frame.size.width *i, 0, _cardScrollView.frame.size.width, _cardScrollView.frame.size.height)];
            _imageView.clipsToBounds = YES;
            _imageView.contentMode = UIViewContentModeScaleAspectFill;
            
            if (i == 0)
            {
                [_imageView sd_setImageWithURL:[NSURL URLWithString:[_imageArray objectAtIndex:[_imageArray count]-1]] placeholderImage:[UIImage imageNamed:@"热点无图片"]];
                _imageView.tag = [_imageArray count]-1;
            }
            else if (i == [_imageArray count]+1)
            {
                [_imageView sd_setImageWithURL:[NSURL URLWithString:[_imageArray objectAtIndex:0]] placeholderImage:[UIImage imageNamed:@"热点无图片"]];
                _imageView.tag = 0;
            }
            else {
                [_imageView sd_setImageWithURL:[NSURL URLWithString:[_imageArray objectAtIndex:i-1]] placeholderImage:[UIImage imageNamed:@"热点无图片"]];
                _imageView.tag = i-1;
            }

            _imageView.userInteractionEnabled = YES ;
            UITapGestureRecognizer *tapGestureRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showMeImageViewPressed:)];
            [_imageView addGestureRecognizer:tapGestureRecognizer];

            [_cardScrollView addSubview:_imageView];
        }

    }
    
    if (IsIOS8) {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        _blurEffectView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    }
    else{
        _blurEffectView = [[UIView alloc] init];
        _blurEffectView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    }
    
    if (screenHeight<=480) {
        _blurEffectView.frame =CGRectMake(screenWidth-45-46-16, _cardView.frame.size.height-42, 45+46, 32);
    }else{
        _blurEffectView.frame =CGRectMake(screenWidth-54-55-16, _cardView.frame.size.height-47, 54+55, 37);
    }
    [_cardView addSubview:_blurEffectView];
    
    _collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_collectBtn setBackgroundImage:[UIImage imageNamed:@"shoucang"] forState:UIControlStateNormal];
    [_collectBtn setBackgroundImage:[UIImage imageNamed:@"shoucang"] forState:UIControlStateHighlighted];
    _collectBtn.frame = CGRectMake(0, 0, (_blurEffectView.frame.size.width-1)/2, _blurEffectView.frame.size.height);
    [_collectBtn addTarget:self action:@selector(collectBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [_blurEffectView addSubview:_collectBtn];
    
    
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_blurEffectView.frame.size.width/2, 5, 1, 30)];
    lineImageView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
   // [_blurEffectView addSubview:lineImageView];

    
    _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_shareBtn setBackgroundImage:[UIImage imageNamed:@"fenxiang"] forState:UIControlStateNormal];
    [_shareBtn setBackgroundImage:[UIImage imageNamed:@"fenxiang"] forState:UIControlStateHighlighted];
    _shareBtn.frame = CGRectMake((_blurEffectView.frame.size.width-1)/2, 0, (_blurEffectView.frame.size.width+1)/2, _blurEffectView.frame.size.height);
    [_shareBtn addTarget:self action:@selector(shareBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [_blurEffectView addSubview:_shareBtn];

}

-(void)initTradeNameAndPriceView
{
    _tradeNameAndPriceView = [[UIView alloc] initWithFrame:CGRectMake(0, _cardScrollView.frame.origin.y + _cardScrollView.frame.size.height, screenWidth, 105)];
    _tradeNameAndPriceView.backgroundColor = [UIColor whiteColor];
    [_mainScrollView addSubview:_tradeNameAndPriceView];
    
    //商品名
    _prodNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 12, screenWidth-16*2, 30)];
    _prodNameLabel.font = [UIFont systemFontOfSize:17.0];
    _prodNameLabel.textColor = shrbText;
    _prodNameLabel.text = self.productDataDic[@"prodName"];
    [_tradeNameAndPriceView addSubview:_prodNameLabel];
    
    //会员价
    _vipPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, _prodNameLabel.frame.origin.y + _prodNameLabel.frame.size.height + 4, 100, 30)];
    _vipPriceLabel.font = [UIFont systemFontOfSize:18.0];
    _vipPriceLabel.textColor = shrbPink;
    _vipPriceLabel.text = [NSString stringWithFormat:@"会员价:￥%@",self.productDataDic[@"vipPrice"]];
    [_vipPriceLabel sizeToFit];
    [_tradeNameAndPriceView addSubview:_vipPriceLabel];
    
    //节省价格
    _saveMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(_vipPriceLabel.frame.origin.x + _vipPriceLabel.frame.size.width + 8, _vipPriceLabel.frame.origin.y, 80, 24)];
    _saveMoneyLabel.center = CGPointMake(_vipPriceLabel.frame.origin.x + _vipPriceLabel.frame.size.width + 8 + 40 , _vipPriceLabel.center.y);
    _saveMoneyLabel.font = [UIFont systemFontOfSize:15.0];
    _saveMoneyLabel.textColor = [UIColor whiteColor];
    _saveMoneyLabel.backgroundColor = shrbPink;
    _saveMoneyLabel.textAlignment = NSTextAlignmentCenter;
    _saveMoneyLabel.text = [NSString stringWithFormat:@"省￥%.2f",[self.productDataDic[@"price"] floatValue] - [self.productDataDic[@"vipPrice"] floatValue]]  ;
    [_tradeNameAndPriceView addSubview:_saveMoneyLabel];
    
    //原价
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, _vipPriceLabel.frame.origin.y + _vipPriceLabel.frame.size.height + 4, 100, 21)];
    _priceLabel.font = [UIFont systemFontOfSize:15.0];
    _priceLabel.textColor = [UIColor lightGrayColor];
    _priceLabel.text = [NSString stringWithFormat:@"原价:￥%@",self.productDataDic[@"price"]];
    [_priceLabel sizeToFit];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:_priceLabel.text];
    [attrString addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, [_priceLabel.text length])];//删除线
    [attrString addAttribute:NSStrikethroughColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, [_priceLabel.text length])];
    _priceLabel.attributedText = attrString;
    [_tradeNameAndPriceView addSubview:_priceLabel];

}

- (void)initDescriptionAndregisterView
{
    
    if (_descriptionAndregisterView != nil) {
        [_descriptionAndregisterView removeFromSuperview];
    }
    _descriptionAndregisterView = [[UIView alloc] initWithFrame:CGRectMake(0, _tradeNameAndPriceView.frame.origin.y + _tradeNameAndPriceView.frame.size.height + 8, screenWidth, 230)];
    _descriptionAndregisterView.backgroundColor =[UIColor whiteColor];
    [_mainScrollView addSubview:_descriptionAndregisterView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 16, 200, 30)];
    label.text = @"商品详情";
    label.textColor = shrbText;
    label.font = [UIFont systemFontOfSize:20];
    [_descriptionAndregisterView addSubview:label];
    
    //商品描述
    _prodDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, label.frame.origin.y + label.frame.size.height + 16 ,screenWidth - 32 , 40)];
    _prodDescLabel.numberOfLines = 1000;
    _prodDescLabel.font = [UIFont systemFontOfSize:15.0];
    _prodDescLabel.textColor = shrbLightText;
    _prodDescLabel.text = self.productDataDic[@"prodDesc"];
    [_prodDescLabel sizeToFit];
    [_descriptionAndregisterView addSubview:_prodDescLabel];
    
    _registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_registerBtn setTitle:@"会员注册" forState:UIControlStateNormal];
    _registerBtn.font = [UIFont systemFontOfSize:15.f];
    [_registerBtn setBackgroundColor:shrbPink];
    _registerBtn.frame = CGRectMake(16, _prodDescLabel.frame.origin.y + _prodDescLabel.frame.size.height + 16, screenWidth - 32, 44);
    _registerBtn.layer.cornerRadius = 4;
    _registerBtn.layer.masksToBounds = YES;
    [_registerBtn addTarget:self action:@selector(registerBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [_descriptionAndregisterView addSubview:_registerBtn];
    
        _registerBtn.hidden = NO;
        
        _descriptionAndregisterView.frame = CGRectMake(0, _tradeNameAndPriceView.frame.origin.y + _tradeNameAndPriceView.frame.size.height + 8, screenWidth, label.frame.origin.y + label.frame.size.height + 16 + _prodDescLabel.frame.size.height + 16 + _registerBtn.frame.size.height + 30);
  //  }

    if (_cardView.frame.size.height + _tradeNameAndPriceView.frame.size.height+ 8 + _descriptionAndregisterView.frame.size.height + 10  < screenHeight-20-44) {
        _mainScrollView.scrollEnabled = NO;
        _mainScrollView.contentSize = CGSizeMake(0, 0);
        return ;
    }

    _mainScrollView.scrollEnabled = YES;
    _mainScrollView.contentSize = CGSizeMake(0, _cardView.frame.size.height + _tradeNameAndPriceView.frame.size.height+ 8 + _descriptionAndregisterView.frame.size.height + 10);
}


#pragma mark - 卡片动画
- (void)cardAnimation
{
    
    self.registerBtn.layer.transform = CATransform3DMakeTranslation(screenWidth, 0, 0);
    self.cardView.layer.transform = CATransform3DMakeScale(0, 0, 1);
    self.prodDescLabel.alpha = 0;
    
    [UIView animateWithDuration:0.8 delay:0.1 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        self.cardView.layer.transform = CATransform3DIdentity;
        
    } completion:^(BOOL finished) {
        
    }];
    
    [UIView animateWithDuration:2.0 delay:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
        self.prodDescLabel.alpha = 1;
    } completion:nil];
    
    [UIView animateWithDuration:0.8 delay:1.5 usingSpringWithDamping:0.3 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        self.registerBtn.layer.transform = CATransform3DMakeScale(0.5, 1, 1);
        
    } completion:^(BOOL finished) {
        
    }];
    [UIView animateWithDuration:1.5 delay:1.5 usingSpringWithDamping:0.3 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        self.registerBtn.layer.transform = CATransform3DIdentity;
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - 开启时间
- (void)startTime
{
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timerFun) userInfo:nil repeats:YES];
    
}


- (void)timerFun
{
    if ([_imageArray count] == 0 ) {
        return;
    }
    _imagePageControl.currentPage =  (_imagePageControl.currentPage+1)%[_imageArray count];
    
    if (_imagePageControl.currentPage == 0)
    {
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            _cardScrollView.contentOffset = CGPointMake(([_imageArray count]+1)*_cardScrollView.bounds.size.width, 0);
            
        } completion:^(BOOL finished) {
            
            _cardScrollView.contentOffset = CGPointMake(1*_cardScrollView.bounds.size.width, 0);
        }];
    }
    else
    {
        [_cardScrollView setContentOffset:CGPointMake((_imagePageControl.currentPage + 1)*_cardScrollView.bounds.size.width, 0) animated:YES];
    }
}


#pragma mark - 注册
- (void)registerBtnPressed
{
    if ([TBUser currentUser].token.length == 0) {
        
        [SVProgressShow showInfoWithStatus:@"请先登录账号!"];
        return ;
    }
    
    NSString *url2=[baseUrl stringByAppendingString:@"/card/v1.0/applyCard?"];
    [self.requestOperationManager POST:url2 parameters:@{@"userId":[TBUser currentUser].userId,@"token":[TBUser currentUser].token,@"merchId":self.productDataDic[@"merchId"]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"applyCard operation = %@ JSON: %@", operation,responseObject);
        
        if ([responseObject[@"code"]integerValue] == 200) {
            [SVProgressShow showSuccessWithStatus:@"会员卡申请成功"];
            
            
            NSString *url=[baseUrl stringByAppendingString:@"/product/v1.0/getProduct?"];
            [self.requestOperationManager GET:url parameters:@{@"prodId":self.productDataDic[@"prodId"],@"token":[TBUser currentUser].token} success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"getProduct operation = %@ JSON: %@", operation,responseObject);
                
                UINavigationController *navController = self.navigationController;
                [self.navigationController popViewControllerAnimated:NO];
                ProductIsMemberViewController *viewController = [[ProductIsMemberViewController alloc] init];
                viewController.productDataDic = responseObject[@"product"];
                viewController.cardDataDic = responseObject[@"card"];
                [navController pushViewController:viewController animated:YES];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"error:++++%@",error.localizedDescription);
            }];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:++++%@",error.localizedDescription);
    }];
    
//    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//
//    UIViewController *registeringStoreMemberViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"RegisteringStoreMemberView"];
//    [registeringStoreMemberViewController setModalPresentationStyle:UIModalPresentationFullScreen];
//    [self.navigationController presentViewController:registeringStoreMemberViewController animated:YES completion:nil];
    
    //    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"IsLogin"];
    //    if (!isLogin) {
    //        [SVProgressShow showInfoWithStatus:@"请先登录！"];
    //        return ;
    //    }
    
//    if (self.becomeMemberView == nil) {
//        self.becomeMemberView = [[SuperBecomeMemberView1 alloc] initWithFrame:CGRectMake(screenWidth, _registerBtn.frame.origin.y, screenWidth/2, 220)];
//        [_mainScrollView addSubview:_becomeMemberView];
//        
//        self.smallbutton = [UIButton buttonWithType:UIButtonTypeCustom];
//        self.smallbutton.frame = CGRectMake(screenWidth/2-45,  _registerBtn.frame.origin.y, 90, 44);
//        self.smallbutton.font = [UIFont systemFontOfSize:15.0f];
//        self.smallbutton.hidden = YES;
//        self.smallbutton.layer.cornerRadius = 4;
//        self.smallbutton.layer.masksToBounds = YES;
//        [self.smallbutton setTitle:@"会员注册" forState:UIControlStateNormal];
//        [self.smallbutton setTintColor:[UIColor clearColor]];
//        [self.smallbutton setBackgroundColor:shrbPink];
//        [self.smallbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [self.smallbutton addTarget:self action:@selector(sureBtnPressed) forControlEvents:UIControlEventTouchUpInside];
//        [_mainScrollView addSubview:self.smallbutton];
//    }
//    
//    if (_bounds.size.width == 0) {
//        _bounds = _registerBtn.bounds;
//    }
//    
//    
//    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
//        
//        CGRect bounds = _bounds;
//        bounds.size.width = bounds.size.width/4;
//        _registerBtn.bounds = bounds;
//        
//    } completion:^(BOOL finished) {
//        
//        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
//            
//            _registerBtn.hidden = YES;
//            self.smallbutton.hidden = NO;
//            self.smallbutton.layer.transform = CATransform3DMakeTranslation(-(screenWidth/2-self.smallbutton.frame.size.width)-30, 0, 0);
//            
//          //  _becomeMemberView.layer.transform = CATransform3DTranslate(_becomeMemberView.layer.transform, -210, 0, 0);
//            
//            
//        } completion:^(BOOL finished) {
//            
//            //pop大小缩放
//            POPSpringAnimation *sizeAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
//            sizeAnimation.springSpeed = 0.f;
//            sizeAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, self.smallbutton.frame.size.width+5, self.smallbutton.frame.size.height+5)];
//            [self.smallbutton pop_addAnimation:sizeAnimation forKey:nil];
//            
//            
//            //pop左右弹动
//            POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
//            positionAnimation.velocity = @2000;
//            positionAnimation.springBounciness = 20;
//            [positionAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
//                self.smallbutton.userInteractionEnabled = YES;
//            }];
//            [self.smallbutton.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
//        }];
//        
//        
//        [UIView animateWithDuration:0.1 delay:0.5 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//            _becomeMemberView.layer.transform = CATransform3DTranslate(_becomeMemberView.layer.transform, -210, 0, 0);
//        } completion:^(BOOL finished) {
//            
//            [[SuperBecomeMemberView1 shareSuperBecomeMemberView] showView];
//            
//        }];
//    }];
    
}


#pragma mark - 收藏
- (void)collectBtnPressed {
    [SVProgressShow showWithStatus:@"收藏中..."];
    double delayInSeconds = 1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [SVProgressShow showSuccessWithStatus:@"收藏成功！"];
    });
    
}

#pragma mark - 分享
- (void)shareBtnPressed {

    DOPAction *action1 = [[DOPAction alloc] initWithName:@"微信" iconName:@"weixin" handler:^{
        [SVProgressShow showWithStatus:@"分享中..."];
        double delayInSeconds = 1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [SVProgressShow showSuccessWithStatus:@"微信分享成功！"];
        });
    }];
    DOPAction *action2 = [[DOPAction alloc] initWithName:@"QQ" iconName:@"qq" handler:^{
        [SVProgressShow showWithStatus:@"分享中..."];
        double delayInSeconds = 1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [SVProgressShow showSuccessWithStatus:@"QQ分享成功！"];
        });
    }];
    DOPAction *action3 = [[DOPAction alloc] initWithName:@"微信朋友圈" iconName:@"wxFriends" handler:^{
        [SVProgressShow showWithStatus:@"分享中..."];
        double delayInSeconds = 1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [SVProgressShow showSuccessWithStatus:@"微信朋友圈分享成功！"];
        });
    }];
    DOPAction *action4 = [[DOPAction alloc] initWithName:@"QQ空间" iconName:@"qzone" handler:^{
        [SVProgressShow showWithStatus:@"分享中..."];
        double delayInSeconds = 1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [SVProgressShow showSuccessWithStatus:@"QQ空间分享成功！"];
        });
    }];
    DOPAction *action5 = [[DOPAction alloc] initWithName:@"微博" iconName:@"weibo" handler:^{
        [SVProgressShow showWithStatus:@"分享中..."];
        double delayInSeconds = 1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [SVProgressShow showSuccessWithStatus:@"新浪微博分享成功！"];
        });
    }];
    DOPAction *action6 = [[DOPAction alloc] initWithName:@"短信" iconName:@"sms" handler:^{
        [SVProgressShow showWithStatus:@"短信发送中..."];
        double delayInSeconds = 1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [SVProgressShow showSuccessWithStatus:@"短信发送成功！"];
        });
    }];
    DOPAction *action7 = [[DOPAction alloc] initWithName:@"邮件" iconName:@"email" handler:^{
        [SVProgressShow showWithStatus:@"邮件发送中..."];
        double delayInSeconds = 1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [SVProgressShow showSuccessWithStatus:@"邮件发送成功！"];
        });
    }];
    
    NSArray *actions;
    actions = @[@"",
                @[action1, action2, action3, action4],
                @"",
                @[action5, action6, action7]];
    DOPScrollableActionSheet *as = [[DOPScrollableActionSheet alloc] initWithActionArray:actions];
    [as show];
    
}


#pragma  mark - pageControl
- (void)pageControlValueChanged
{
    
    [_cardScrollView setContentOffset:CGPointMake((_imagePageControl.currentPage + 1)*_cardView.bounds.size.width, 0) animated:YES];
}

#pragma mark - scrollView delegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (_timer.isValid) {
        [_timer invalidate];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (!_timer.isValid) {
        [self startTime];
    }
    
    int page = scrollView.contentOffset.x / scrollView.bounds.size.width;
    
    if (page ==[_imageArray count]+1)
    {
        scrollView.contentOffset = CGPointMake(scrollView.bounds.size.width, 0);
        
        _imagePageControl.currentPage = 0;
    }
    else if (page == 0)
    {
        scrollView.contentOffset = CGPointMake(scrollView.bounds.size.width * [_imageArray count], 0);
        
        _imagePageControl.currentPage = [_imageArray count]-1;
    }
    else
    {
        _imagePageControl.currentPage = page - 1;
    }
}


#pragma mark - 全屏显示图片
- (void)showMeImageViewPressed:(UITapGestureRecognizer *)tap
{
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        self.cardView.layer.transform = CATransform3DMakeScale(0.9, 0.9, 1);
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            self.cardView.layer.transform = CATransform3DIdentity;
            
        } completion:^(BOOL finished) {
            
            if (_timer.isValid) {
                [_timer invalidate];
            }
            
            ShowMeImageViewController *viewController = [[ShowMeImageViewController alloc] init];
            viewController.imagesArray=_imageArray;
            viewController.currentImageIndex=tap.view.tag;
            [self presentViewController:viewController animated:YES completion:^{
                
            }];
            
        }];
    }];
    
}
@end
