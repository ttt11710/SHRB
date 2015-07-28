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
#import "ProductIsMemberTableViewController.h"
#import "DOPScrollableActionSheet.h"
#import "SVProgressShow.h"
#import "ProductIsMemberViewController.h"
#import "ShowMeImageViewController.h"

static ProductViewController *g_ProductViewController = nil;

@interface ProductViewController ()
{
    NSMutableArray *_imageArray;
    CGRect _bounds;
    
    NSTimer *_timer;
}

@property (nonatomic,strong) NSMutableArray * modelArray;
@property (nonatomic,strong) NSMutableArray * plistArr;


@property(nonatomic,retain)UIScrollView *mainScrollView;//整个界面ScrollView
@property(nonatomic,retain)UIView *cardShadowView;//展示卡片阴影层
@property(nonatomic,retain)UIView *cardView;//展示卡片View
@property(nonatomic,retain)UIScrollView *cardScrollView;//卡片ScrollView
@property (retain, nonatomic)UIPageControl *imagePageControl; //卡片page
@property(nonatomic,retain)UIImageView *cardPhotoView;//卡片图片
@property(nonatomic,retain)UIView *blurEffectView;//毛玻璃View

//毛玻璃上控件
@property (retain, nonatomic) UILabel *saveMoneyLabel;  //节省钱数
@property (retain, nonatomic) UIButton *collectBtn;     //收藏
@property (retain, nonatomic) UIButton *shareBtn;       //分享

@property (retain, nonatomic) UILabel *descriptionLabel; //产品描述
@property (retain, nonatomic) UIButton *registerBtn;     //注册
@property (retain, nonatomic) SuperBecomeMemberView1 *becomeMemberView; //注册弹出界面
@property (retain, nonatomic) UIButton *smallbutton; //注册弹出button

@end

@implementation ProductViewController

@synthesize currentSection;
@synthesize currentRow;


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
    [self initTradeDescriptionView];
    [self initRegisterView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    self.view.userInteractionEnabled = YES;
    [self.view addGestureRecognizer:tap];
    
    [self cardAnimation];
}



- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self startTime];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [_timer invalidate];
}



- (void)initData
{
    NSString *storeFile = [[NSUserDefaults standardUserDefaults] stringForKey:@"storePlistName"];
    
    self.plistArr =[[NSMutableArray alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:storeFile ofType:@"plist"]];
    
    self.modelArray = [[NSMutableArray alloc] init];
    
//    _imageArray = [[NSMutableArray alloc] initWithObjects:
//                   @"http://static.lover1314.me/image/2015/04/16/1552f5e302fae3_orig.jpg",
//                   @"http://static.lover1314.me/image/2015/04/16/1552f5e2b1fee1_orig.jpg",
//                   @"http://static.lover1314.me/image/2015/04/16/1552f5e1903f9b_orig.jpg", nil];
    
    _imageArray = [[NSMutableArray alloc] initWithObjects:
                   @"毛呢冬带毛领",
                   @"男士休闲羊毛西服",
                   @"长款千鸟格大衣",
                   @"撞色加厚双排扣大衣", nil];
    
    
    self.title = [[self.plistArr objectAtIndex:currentSection][@"info"] objectAtIndex:currentRow][@"tradeName"];
}

- (void)initMainView
{
    _mainScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _mainScrollView.backgroundColor = [UIColor whiteColor] ;
    [self.view addSubview:_mainScrollView];
}

-(void)initCardView{
    
    if (screenHeight>480) {
        _cardShadowView=[[UIView alloc]initWithFrame:CGRectMake(16, 16, screenWidth-32, screenHeight/5*3-20)];
    }
    else{
        _cardShadowView=[[UIView alloc]initWithFrame:CGRectMake(16, 16, screenWidth-32, screenHeight/2+30)];
    }
    
    _cardShadowView.layer.cornerRadius = 8;
    _cardShadowView.layer.shadowColor = [UIColor blackColor].CGColor;
    _cardShadowView.layer.shadowOffset = CGSizeMake(0,2);
    _cardShadowView.layer.shadowOpacity = 0.5;
    _cardShadowView.layer.shadowRadius = 2.0;
    
    _cardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _cardShadowView.frame.size.width, _cardShadowView.frame.size.height)];
    _cardView.backgroundColor=[UIColor whiteColor];
    _cardView.layer.cornerRadius=8;
    _cardView.layer.masksToBounds = YES;
    
    [_cardShadowView addSubview:_cardView];
    [_mainScrollView insertSubview:_cardShadowView atIndex:0];
    
    _cardScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _cardView.frame.size.width, _cardView.frame.size.height)];
    _cardScrollView.contentSize = CGSizeMake(_cardScrollView.frame.size.width*([_imageArray count]+2), 0);
    _cardScrollView.contentOffset = CGPointMake(_cardScrollView.frame.size.width, 0);
    _cardScrollView.delegate = self;
    _cardScrollView.pagingEnabled = YES;
    _cardScrollView.showsHorizontalScrollIndicator = NO;
    _cardScrollView.showsVerticalScrollIndicator = NO;
    [_cardView addSubview:_cardScrollView];
    
    _imagePageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, _cardView.frame.size.height-70, _cardView.frame.size.width, 20)];
    _imagePageControl.numberOfPages = [_imageArray count];
    _imagePageControl.currentPage = 0;
    [_imagePageControl addTarget:self action:@selector(pageControlValueChanged) forControlEvents:UIControlEventValueChanged];

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
                [_imageView sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",[_imageArray objectAtIndex:[_imageArray count]-1]]]];
                _imageView.tag = [_imageArray count]-1;
            }
            else if (i == [_imageArray count]+1)
            {
                [_imageView sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",[_imageArray objectAtIndex:0]]]];
                _imageView.tag = 0;
            }
            else {
                [_imageView sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",[_imageArray objectAtIndex:i-1]]]];
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
        _blurEffectView.frame =CGRectMake(0, _cardView.frame.size.height-40, _cardView.frame.size.width, 40);
    }else{
        _blurEffectView.frame =CGRectMake(0, _cardView.frame.size.height-40, _cardView.frame.size.width, 40);
    }
    [_cardView addSubview:_blurEffectView];
    
    _saveMoneyLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, _blurEffectView.frame.size.width/2-40, _blurEffectView.frame.size.height)];
    _saveMoneyLabel.font=[UIFont boldSystemFontOfSize:18];
    _saveMoneyLabel.textColor=[UIColor whiteColor];
    _saveMoneyLabel.textAlignment=NSTextAlignmentLeft;
    _saveMoneyLabel.text = @"省40元";
    [_blurEffectView addSubview:_saveMoneyLabel];
    
    _collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_collectBtn setBackgroundImage:[UIImage imageNamed:@"shoucang"] forState:UIControlStateNormal];
    _collectBtn.frame = CGRectMake(_blurEffectView.frame.size.width-38-38, _blurEffectView.frame.size.height/2-15, 30, 30);
    [_collectBtn addTarget:self action:@selector(collectBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [_blurEffectView addSubview:_collectBtn];

    
    _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_shareBtn setBackgroundImage:[UIImage imageNamed:@"fenxiang"] forState:UIControlStateNormal];
    _shareBtn.frame = CGRectMake(_blurEffectView.frame.size.width-38, _blurEffectView.frame.size.height/2-15, 30, 30);
    [_shareBtn addTarget:self action:@selector(shareBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [_blurEffectView addSubview:_shareBtn];

}

- (void)initTradeDescriptionView
{
    
    _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, _cardShadowView.frame.origin.y + _cardShadowView.frame.size.height + 10,screenWidth - 32 , 40)];
    _descriptionLabel.numberOfLines = 1000;
    _descriptionLabel.font = [UIFont systemFontOfSize:15.0];
    _descriptionLabel.textColor = shrbText;
    _descriptionLabel.text = [[self.plistArr objectAtIndex:currentSection][@"info"] objectAtIndex:currentRow][@"tradeDescription"];
    [_mainScrollView addSubview:_descriptionLabel];
    
    
    [_descriptionLabel sizeToFit];
    if (_descriptionLabel.frame.size.height + _cardView.frame.origin.y + _cardView.frame.size.height+220+10 < screenHeight-20-44) {
        _mainScrollView.scrollEnabled = NO;
        _mainScrollView.contentSize = CGSizeMake(0, 0);
        return ;
    }
    
    _mainScrollView.scrollEnabled = YES;
    _mainScrollView.contentSize = CGSizeMake(0, _descriptionLabel.frame.size.height + _cardView.frame.origin.y + _cardView.frame.size.height+220+10);
}

- (void)initRegisterView
{
    _registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_registerBtn setTitle:@"会员注册" forState:UIControlStateNormal];
    _registerBtn.font = [UIFont systemFontOfSize:15.f];
    [_registerBtn setBackgroundColor:shrbPink];
    _registerBtn.frame = CGRectMake(32, _descriptionLabel.frame.origin.y + _descriptionLabel.frame.size.height + 10, screenWidth - 64, 44);
    _registerBtn.layer.cornerRadius = 4;
    _registerBtn.layer.masksToBounds = YES;
    [_registerBtn addTarget:self action:@selector(registerBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [_mainScrollView addSubview:_registerBtn];
}


#pragma mark - 卡片动画
- (void)cardAnimation
{
    
    self.registerBtn.layer.transform = CATransform3DMakeTranslation(screenWidth, 0, 0);
    self.cardView.layer.transform = CATransform3DMakeScale(0, 0, 1);
    self.descriptionLabel.alpha = 0;
    
    [UIView animateWithDuration:0.8 delay:0.1 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        self.cardView.layer.transform = CATransform3DIdentity;
        
    } completion:^(BOOL finished) {
        
    }];
    
    [UIView animateWithDuration:2.0 delay:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
        self.descriptionLabel.alpha = 1;
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
    //    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"IsLogin"];
    //    if (!isLogin) {
    //        [SVProgressShow showInfoWithStatus:@"请先登录！"];
    //        return ;
    //    }
    
    if (self.becomeMemberView == nil) {
        self.becomeMemberView = [[SuperBecomeMemberView1 alloc] initWithFrame:CGRectMake(screenWidth, _registerBtn.frame.origin.y, screenWidth/2, 220)];
        [_mainScrollView addSubview:_becomeMemberView];
        
        self.smallbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.smallbutton.frame = CGRectMake(screenWidth/2-45,  _registerBtn.frame.origin.y, 90, 44);
        self.smallbutton.font = [UIFont systemFontOfSize:15.0f];
        self.smallbutton.hidden = YES;
        self.smallbutton.layer.cornerRadius = 4;
        self.smallbutton.layer.masksToBounds = YES;
        [self.smallbutton setTitle:@"会员注册" forState:UIControlStateNormal];
        [self.smallbutton setTintColor:[UIColor clearColor]];
        [self.smallbutton setBackgroundColor:shrbPink];
        [self.smallbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.smallbutton addTarget:self action:@selector(sureBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        [_mainScrollView addSubview:self.smallbutton];
    }
    
    if (_bounds.size.width == 0) {
        _bounds = _registerBtn.bounds;
    }
    
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        CGRect bounds = _bounds;
        bounds.size.width = bounds.size.width/4;
        _registerBtn.bounds = bounds;
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            _registerBtn.hidden = YES;
            self.smallbutton.hidden = NO;
            self.smallbutton.layer.transform = CATransform3DMakeTranslation(-(screenWidth/2-self.smallbutton.frame.size.width)-30, 0, 0);
            
            _becomeMemberView.layer.transform = CATransform3DTranslate(_becomeMemberView.layer.transform, -210, 0, 0);
            
            
        } completion:^(BOOL finished) {
            
            //pop大小缩放
            POPSpringAnimation *sizeAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
            sizeAnimation.springSpeed = 0.f;
            sizeAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, self.smallbutton.frame.size.width+5, self.smallbutton.frame.size.height+5)];
            [self.smallbutton pop_addAnimation:sizeAnimation forKey:nil];
            
            
            //pop左右弹动
            POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
            positionAnimation.velocity = @2000;
            positionAnimation.springBounciness = 20;
            [positionAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
                self.smallbutton.userInteractionEnabled = YES;
            }];
            [self.smallbutton.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
        }];
    }];
    
}

#pragma mark - 确定注册
- (void)sureBtnPressed
{
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        self.smallbutton.layer.transform = CATransform3DIdentity;
        
        _becomeMemberView.layer.transform = CATransform3DIdentity;
        
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            self.smallbutton.hidden = YES;
            _registerBtn.hidden = NO;
            
            _registerBtn.bounds = _bounds;
            
        } completion:^(BOOL finished) {
            
            [[SuperBecomeMemberView1 shareSuperBecomeMemberView] textFieldResignFirstResponder];
            POPSpringAnimation *sizeAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
            sizeAnimation.springSpeed = 0.f;
            sizeAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, self.smallbutton.frame.size.width-5, self.smallbutton.frame.size.height-5)];
            [self.smallbutton pop_addAnimation:sizeAnimation forKey:nil];
        }];
        
    }];
    
}


#pragma mark - 成为会员时页面重push
- (void)becomeMember
{
    UINavigationController *navController = self.navigationController;
    [self.navigationController popViewControllerAnimated:NO];
    
//    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    ProductIsMemberTableViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"ProductIsMemberTableView"];
//    viewController.currentSection = currentSection;
//    viewController.currentRow = currentRow;
//    
//    [viewController setModalPresentationStyle:UIModalPresentationFullScreen];
//    
//    [navController pushViewController:viewController animated:NO];
    
    
    ProductIsMemberViewController *viewController = [[ProductIsMemberViewController alloc] init];
    viewController.currentRow = currentRow;
    viewController.currentSection = currentSection;
    [navController pushViewController:viewController animated:NO];
    
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


#pragma  mark - pageControl
- (void)pageControlValueChanged
{
    
    [_cardScrollView setContentOffset:CGPointMake((_imagePageControl.currentPage + 1)*_cardView.bounds.size.width, 0) animated:YES];
}

#pragma mark - scrollView delegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_timer invalidate];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self startTime];
    
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

#pragma mark - 单击屏幕键盘消失
-(void)tap {
    
    [[SuperBecomeMemberView1 shareSuperBecomeMemberView] textFieldResignFirstResponder];
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
            
            ShowMeImageViewController *viewController = [[ShowMeImageViewController alloc] init];
            viewController.imagesArray=_imageArray;
            viewController.currentImageIndex=tap.view.tag;
            [self presentViewController:viewController animated:YES completion:^{
                
            }];
            
        }];
    }];
    
}
@end
