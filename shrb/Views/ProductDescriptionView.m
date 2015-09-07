//
//  ProductDescriptionView.m
//  shrb
//
//  Created by PayBay on 15/5/21.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "ProductDescriptionView.h"
#import "SVProgressShow.h"
#import "Const.h"
#import "DOPScrollableActionSheet.h"
#import <UIImageView+WebCache.h>

@interface ProductDescriptionView ()
{
    NSMutableArray *_data;
    NSInteger _currentSection;
    NSInteger _currentRow;
}


@property(nonatomic,retain)UIView *mainView;
@property(nonatomic,retain)UIView *descriptionView;
@property(nonatomic,assign,getter=isPaning)BOOL paning;

@property(nonatomic,retain)UILabel *nameLabel;
@property(nonatomic,retain)UIView *shadowView;
@property(nonatomic,retain)UIImageView *descriptionImageView;
@property(nonatomic,retain)UILabel *descriptionLabel;


@end

@implementation ProductDescriptionView


@synthesize plistArr;

- (void)setCurrentSection:(NSInteger)currentSection {
    _currentSection = currentSection;
}

- (void)setCurrentRow:(NSInteger)currentRow
{
    _currentRow = currentRow;
    [self initSubView];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled=YES;
        self.backgroundColor=[UIColor colorWithWhite:0 alpha:0.5];
        
        [self initMainView];
    }
    return self;
}

- (void)initData
{
    NSString *storeFile = [[NSUserDefaults standardUserDefaults] stringForKey:@"storePlistName"];
    
    self.plistArr =[[NSMutableArray alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:storeFile ofType:@"plist"]];
}
-(void)initMainView {
    
    _mainView=[[UIView alloc]initWithFrame:CGRectMake(screenWidth/10, 20, 4*screenWidth/5, 3*screenHeight/4 )];
    _mainView.backgroundColor=[UIColor clearColor];
    [self addSubview:_mainView];
}

- (void)initSubView
{
    NSLog(@"_currentSection = %ld,_currentRow = %ld",_currentSection,_currentRow);
    _descriptionView=[[UIView alloc]initWithFrame:CGRectMake(0,0, 4*screenWidth/5, 3*screenHeight/4)];
    _descriptionView.backgroundColor = [UIColor whiteColor];
    _descriptionView.userInteractionEnabled=YES;
    UIPanGestureRecognizer *panGestureRecognizer=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(cardPanEven:)];
    [_descriptionView addGestureRecognizer:panGestureRecognizer];
    _descriptionView.layer.cornerRadius=8;
    _descriptionView.layer.masksToBounds = YES;
    
    [_mainView insertSubview:_descriptionView atIndex:0];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 12, 200, 21)];
    _nameLabel.text = [[self.plistArr objectAtIndex:_currentSection][@"prodList"] objectAtIndex:_currentRow][@"prodName"];
    _nameLabel.textColor = [UIColor colorWithRed:78.0/255.0 green:78.0/255.0 blue:78.0/255.0 alpha:1];
    [_descriptionView addSubview:_nameLabel];
    
    _descriptionImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, _nameLabel.frame.origin.y+_nameLabel.frame.size.height+4, 4*screenWidth/5-12*2, 4*screenWidth/5-50)];
    [_descriptionImageView sd_setImageWithURL:[NSURL URLWithString:[[self.plistArr objectAtIndex:_currentSection][@"prodList"] objectAtIndex:_currentRow][@"imgUrl"]] placeholderImage:[UIImage imageNamed:@"热点无图片"]];
    _descriptionImageView.layer.cornerRadius = 8;
    _descriptionImageView.layer.masksToBounds = YES;
    
    
    //4边阴影
    _shadowView = [[UIView alloc] initWithFrame:CGRectMake(12, _nameLabel.frame.origin.y+_nameLabel.frame.size.height+4, 4*screenWidth/5-12*2, 4*screenWidth/5-50)];
    _shadowView.userInteractionEnabled = NO;
    _shadowView.backgroundColor = [UIColor whiteColor];
    _shadowView.layer.cornerRadius = 8;
    _shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
    _shadowView.layer.shadowOffset = CGSizeMake(0,0);
    _shadowView.layer.shadowOpacity = 0.5;
    _shadowView.layer.shadowRadius = 2.0;
    
    //路径阴影
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    float width = _shadowView.bounds.size.width;
    float height = _shadowView.bounds.size.height;
    float x = _shadowView.bounds.origin.x;
    float y = _shadowView.bounds.origin.y;
    float addWH = 2;
    
    CGPoint topLeft      = CGPointMake(x,y);
    CGPoint topMiddle = CGPointMake(x+(width/2),y-addWH);
    CGPoint topRight     = CGPointMake(x+width,y);
    
    CGPoint rightMiddle = CGPointMake(x+width+addWH,y+(height/2));
    
    CGPoint bottomRight  = CGPointMake(x+width,y+height);
    CGPoint bottomMiddle = CGPointMake(x+(width/2),y+height+addWH);
    CGPoint bottomLeft   = CGPointMake(x,y+height);
    
    
    CGPoint leftMiddle = CGPointMake(x-addWH,y+(height/2));
    
    [path moveToPoint:topLeft];
    //添加四个二元曲线
    [path addQuadCurveToPoint:topRight
                 controlPoint:topMiddle];
    [path addQuadCurveToPoint:bottomRight
                 controlPoint:rightMiddle];
    [path addQuadCurveToPoint:bottomLeft
                 controlPoint:bottomMiddle];
    [path addQuadCurveToPoint:topLeft
                 controlPoint:leftMiddle];  
    //设置阴影路径
    _shadowView.layer.shadowPath = path.CGPath;
    
    
    
    [_descriptionView addSubview:_shadowView];
    [_descriptionView addSubview:_descriptionImageView];
    [self addBlurViewView:_descriptionImageView];
    
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, _descriptionImageView.frame.size.height-21-12, 100, 21)];
    moneyLabel.text = @"省 40元";
    moneyLabel.textColor = [UIColor orangeColor];
    [_descriptionImageView addSubview:moneyLabel];
    
    _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, _descriptionImageView.frame.origin.y+_descriptionImageView.frame.size.height+4, 4*screenWidth/5-12*2, 10)];
    _descriptionLabel.text = [[self.plistArr objectAtIndex:_currentSection][@"prodList"] objectAtIndex:_currentRow][@"prodDesc"];
    _descriptionLabel.backgroundColor = [UIColor whiteColor];
    _descriptionLabel.textColor = [UIColor grayColor];
    _descriptionLabel.numberOfLines = 2;
    _descriptionLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [_descriptionView addSubview:_descriptionLabel];
    if (IsiPhone4s) {
        _descriptionLabel.font = [UIFont systemFontOfSize:15];
    }
    else {
        _descriptionLabel.font = [UIFont systemFontOfSize:16];
    }
    [_descriptionLabel sizeToFit];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(_descriptionImageView.frame.origin.x+_descriptionImageView.frame.size.width-41-15, _descriptionImageView.frame.origin.y + _descriptionImageView.frame.size.height-40, 41, 35);
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"fenxiang"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    [_descriptionView addSubview:shareBtn];

    UIButton *collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    collectBtn.frame = CGRectMake(shareBtn.frame.origin.x-40, shareBtn.frame.origin.y, 40, 35);
    [collectBtn setBackgroundImage:[UIImage imageNamed:@"shoucang"] forState:UIControlStateNormal];
    [collectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [collectBtn addTarget:self action:@selector(collectBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [_descriptionView addSubview:collectBtn];

    UIButton *addButton=[[UIButton alloc]initWithFrame:CGRectMake(4*screenWidth/5-55, 8, 40, 25)];
    addButton.layer.cornerRadius = 4;
    addButton.layer.masksToBounds = YES;
    addButton.layer.borderColor = shrbPink.CGColor;
    addButton.layer.borderWidth = 1;
    addButton.font = [UIFont boldSystemFontOfSize:14];
    [addButton setTitle:@"添加" forState:UIControlStateNormal];
    [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addButton setTintColor:[UIColor clearColor]];
    [addButton setTitleColor:shrbPink forState:UIControlStateHighlighted];
    [addButton setBackgroundImage:[UIImage imageNamed:@"button_highlight"] forState:UIControlStateNormal];
    [addButton setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateHighlighted];
    //[addButton setTitle:@"+" forState:UIControlStateNormal];
   // [addButton setBackgroundImage:[UIImage imageNamed:@"increase2"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addButtonEven) forControlEvents:UIControlEventTouchUpInside];
    [_descriptionView addSubview:addButton];
    
    
    _descriptionView.frame = CGRectMake(0,0, 4*screenWidth/5, _descriptionImageView.frame.origin.y + _descriptionImageView.frame.size.height + 4 + _descriptionLabel.frame.size.height + 12);
    _mainView.frame = CGRectMake(screenWidth/10, 0, 4*screenWidth/5, _descriptionImageView.frame.origin.y + _descriptionImageView.frame.size.height + 4 + _descriptionLabel.frame.size.height + 12);
    _mainView.center = CGPointMake(screenWidth/2, (screenHeight - 20 - 44)/2);
    NSLog(@"screenHeight = %f",screenHeight);
    
}

- (void)refreshDescriptionView {
    
    _nameLabel.text = [[self.plistArr objectAtIndex:_currentSection][@"prodList"] objectAtIndex:_currentRow][@"prodName"];
    [_descriptionImageView sd_setImageWithURL:[NSURL URLWithString:[[self.plistArr objectAtIndex:_currentSection][@"prodList"] objectAtIndex:_currentRow][@"imgUrl"]] placeholderImage:[UIImage imageNamed:@"热点无图片"]];
    _descriptionLabel.text = [[self.plistArr objectAtIndex:_currentSection][@"prodList"] objectAtIndex:_currentRow][@"prodDesc"];
    if (_currentRow == 1) {
        _descriptionLabel.text = @"jkjvklsngjroijgnjkandkljiorutiohvdfjsnjkwjrljfjjkjvklsngjroijgnjkandkljiorutiohvdfjsnjkwjrljfjjkjvklsngjroijgnjkandkljiorutiohvdfjsnjkwjrljfjjkjvklsngjroijgnjkandkljiorutiohvdfjsnjkwjrljfjjkjvklsngjroijgnjkandkljiorutiohvdfjsnjkwjrljfjjkjvklsngjroijgnjkandkljiorutiohvdfjsnjkwjrljfjjkjvklsngjroijgnjkandkljiorutiohvdfjsnjkwjrljfjjkjvklsngjroijgnjkandkljiorutiohvdfjsnjkwjrljfjjkjvklsngjroijgnjkandkljiorutiohvdfjsnjkwjrljfjjkjvklsngjroijgnjkandkljiorutiohvdfjsnjkwjrljfjjkjvklsngjroijgnjkandkljiorutiohvdfjsnjkwjrljfj";
        
    }
}

#pragma mark -  主播卡片滑动手势 方法

static CGPoint startPoint;
static CGPoint endPoint;
static NSInteger oldSection;
static NSInteger oldRow;
-(void)cardPanEven:(UIPanGestureRecognizer *)sender{
    
    if (!self.isPaning) {
        [_mainView bringSubviewToFront:sender.view];
        startPoint=[sender translationInView:_mainView];
        endPoint=startPoint;
        oldSection = _currentSection;
        oldRow = _currentRow;
        
        if (oldRow<[[self.plistArr objectAtIndex:oldSection][@"prodList"] count]-1 && oldRow >= 0)
        {
            oldRow++;
        }
        else {
            oldRow = 0 ;
            oldSection ++;
        }
        if (oldSection == [self.plistArr count]) {
            oldSection = 0 ;
        }
        _currentSection = oldSection;
        _currentRow = oldRow;
        
        [self initSubView];
        _descriptionView.transform=CGAffineTransformMakeScale(0.5, 0.5);
        //[self refreshDescriptionView];
        //[self setCurrentInfo:_currentIndex];
        _descriptionView.userInteractionEnabled=NO;
        _paning=YES;
    }
    
    
    CGPoint point=[sender translationInView:_mainView];
    
    endPoint=CGPointMake(endPoint.x+point.x, endPoint.y+point.y);
    
    sender.view.transform=CGAffineTransformTranslate(sender.view.transform, point.x, point.y) ;
    [sender setTranslation:CGPointMake(0, 0) inView:_mainView];
    
    CGFloat scale= (abs(endPoint.x-startPoint.x)+abs(endPoint.y-startPoint.y))*0.0005;
    scale=MIN(0.1, scale);
    _descriptionView.transform=CGAffineTransformMakeScale(0.5+scale, 0.5+scale);
    
    if (sender.state==UIGestureRecognizerStateEnded) {
        
        if (abs(endPoint.x-startPoint.x) <=100&&abs(endPoint.y-startPoint.y)<=100) {
            [_descriptionView removeFromSuperview];
            _descriptionView=sender.view;
            [self refreshDescriptionView];
            [UIView animateWithDuration:0.2f animations:^{
                sender.view.transform=CGAffineTransformIdentity;
            }];
            _paning=NO;
            return;
        }
        CGFloat x;
        CGFloat y;
        x=sender.view.frame.origin.x>=0?screenWidth:0;
        y=screenHeight;
//        if (_currentArtistIndex==0) {
//            [self refreshArtistsDate];
//        }
        [UIView animateWithDuration:0.6f animations:^{
            sender.view.frame=CGRectMake(x,y, 0, 0);
            _descriptionView.transform=CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [sender.view removeFromSuperview];
            _paning=NO;
            _descriptionView.userInteractionEnabled=YES;
        }];
    }
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if ([[touches anyObject]view]!=_mainView &&[[touches anyObject]view]!=_descriptionView) {
        [self removeFromSuperview];
    }
}


#pragma mark - 收藏
- (void)collectBtnPressed
{
    
    [SVProgressShow showWithStatus:@"收藏中..."];
    double delayInSeconds = 1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [SVProgressShow showSuccessWithStatus:@"收藏成功！"];
    });
}

#pragma mark - 分享
- (void)shareBtnPressed
{
    
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

#pragma mark - 添加商品
-(void)addButtonEven
{
    [SVProgressShow showSuccessWithStatus:@"添加成功"];
}

#pragma mark - 蒙版效果
- (void)addBlurViewView:(UIView *)view
{
    if (IsIOS8) {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurEffectView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        blurEffectView.frame =  CGRectMake(0, view.frame.size.height-45, view.frame.size.width, 45);
        [view insertSubview:blurEffectView atIndex:0];
    }
    else{
        UIView *blurEffectView = [[UIView alloc] init];
        blurEffectView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        blurEffectView.frame = CGRectMake(0, view.frame.size.height-45, view.frame.size.width, 45);
        [view insertSubview:blurEffectView atIndex:0];
    }
}

@end
