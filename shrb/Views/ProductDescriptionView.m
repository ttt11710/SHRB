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

@interface ProductDescriptionView ()
{
    NSMutableArray *_data;
}

@property(nonatomic,retain)UIView *mainView;
@property(nonatomic,retain)UIView *descriptionView;
@property(nonatomic,assign,getter=isPaning)BOOL paning;

@property(nonatomic,retain)UILabel *nameLabel;
@property(nonatomic,retain)UIImageView *descriptionImageView;
@property(nonatomic,retain)UITextView *descriptionTextView;

@end

@implementation ProductDescriptionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled=YES;
        self.backgroundColor=[UIColor colorWithWhite:0 alpha:0.5];
        
        _data = [[NSMutableArray alloc] initWithObjects:
                 @{
                   @"storeName" : @"提拉米苏",
                   @"detail":@"        夏天正劲，混搭出趣！全新推出的咖啡三重奏星冰乐，把苏门答腊、意式烘焙和浓缩烘焙三种滋味放进一杯！美味的咖啡吉利，冰爽的咖啡星冰乐和滑顺的浓缩咖啡搅打奶油，为你打造浓郁的咖啡体验。更有夏莓意式奶冻星冰乐与摩卡曲奇星冰乐，丰富你的选择！"
                   },
                 @{
                   @"storeName" : @"蜂蜜提子可颂",
                   @"detail":@"        中华沃土，润生万物，时代沧桑，印证合兴风雨历程。几十年的风雨坎坷、改革创新，合兴走过了一条发展的路、创新的路、希望的路。在国家迅速发展的大环境下，在社会各界朋友以及广大顾客的大力支持下，合兴餐饮集团有了今天的规模。\n        面对取得的成绩我们没有丝毫的骄傲，我们将一如既往，用“良心品质”核心价值观来指导企业的行为，做到对顾客、对员工、对合作伙伴、对社会有良心，用双赢、多赢、共赢的观念来促进多方面的合作。为创建一个民族的、多品牌的、国内领先的快餐连锁企业集团而不懈努力，为民族餐饮业的发展做出自己积极的贡献。"
                   },
                 @{
                   @"storeName" : @"芝士可颂",
                   @"detail":@"        优质食品，美好生活是我们时时刻刻、无处不在的承诺——用优质的食品和饮料来提高生活质量，将该理念贯穿生命各个阶段"
                   },
                 @{
                   @"storeName" : @"牛奶",
                   @"detail":@"        自从1940年夏天开第一家冰淇淋店开始，迄今为止，已在25个国家，开了近8000家连锁店。它提供Dairy Queen冰淇淋、Orange Julius鲜果露、Karmelkom爆米花等休闲食品，是世界销量第一的软冰淇淋专家和全球连锁快餐业巨头之一。\n        DQ的冰淇淋都是软体冰淇淋，经过均匀搅拌后，有倒杯不洒的美誉。明星产品“暴风雪”还能做到“倒杯不洒”，这是其它冰淇淋所不具备的，非常神奇。美国权威期刊“Restaurants and Institutions”每年对全球400个连锁餐饮品牌进行排名，DQ在冰淇淋产品市场连续数年全球排名第一！"
                   },
                 @{
                   @"storeName" : @"抹茶拿铁",
                   @"detail":@"        优质食品，美好生活是我们时时刻刻、无处不在的承诺——用优质的食品和饮料来提高生活质量，将该理念贯穿生命各个阶段"
                   },
                 @{
                   @"storeName" : @"英式红茶",
                   @"detail":@"        中华沃土，润生万物，时代沧桑，印证合兴风雨历程。几十年的风雨坎坷、改革创新，合兴走过了一条发展的路、创新的路、希望的路。在国家迅速发展的大环境下，在社会各界朋友以及广大顾客的大力支持下，合兴餐饮集团有了今天的规模。\n        面对取得的成绩我们没有丝毫的骄傲，我们将一如既往，用“良心品质”核心价值观来指导企业的行为，做到对顾客、对员工、对合作伙伴、对社会有良心，用双赢、多赢、共赢的观念来促进多方面的合作。为创建一个民族的、多品牌的、国内领先的快餐连锁企业集团而不懈努力，为民族餐饮业的发展做出自己积极的贡献。"
                   },
                 @{
                   @"storeName" : @"冰拿铁",
                   @"detail":@"        夏天正劲，混搭出趣！全新推出的咖啡三重奏星冰乐，把苏门答腊、意式烘焙和浓缩烘焙三种滋味放进一杯！美味的咖啡吉利，冰爽的咖啡星冰乐和滑顺的浓缩咖啡搅打奶油，为你打造浓郁的咖啡体验。更有夏莓意式奶冻星冰乐与摩卡曲奇星冰乐，丰富你的选择！"
                   },
                 @{
                   @"storeName" : @"卡布奇诺",
                   @"detail":@"        中华沃土，润生万物，时代沧桑，印证合兴风雨历程。几十年的风雨坎坷、改革创新，合兴走过了一条发展的路、创新的路、希望的路。在国家迅速发展的大环境下，在社会各界朋友以及广大顾客的大力支持下，合兴餐饮集团有了今天的规模。\n        面对取得的成绩我们没有丝毫的骄傲，我们将一如既往，用“良心品质”核心价值观来指导企业的行为，做到对顾客、对员工、对合作伙伴、对社会有良心，用双赢、多赢、共赢的观念来促进多方面的合作。为创建一个民族的、多品牌的、国内领先的快餐连锁企业集团而不懈努力，为民族餐饮业的发展做出自己积极的贡献。"
                   },

                 @{
                   @"storeName" : @"焦糖玛奇朵",
                   @"detail":@"        优质食品，美好生活是我们时时刻刻、无处不在的承诺——用优质的食品和饮料来提高生活质量，将该理念贯穿生命各个阶段"
                   },
                 @{
                   @"storeName" : @"美式咖啡",
                   @"detail":@"        中华沃土，润生万物，时代沧桑，印证合兴风雨历程。几十年的风雨坎坷、改革创新，合兴走过了一条发展的路、创新的路、希望的路。在国家迅速发展的大环境下，在社会各界朋友以及广大顾客的大力支持下，合兴餐饮集团有了今天的规模。\n        面对取得的成绩我们没有丝毫的骄傲，我们将一如既往，用“良心品质”核心价值观来指导企业的行为，做到对顾客、对员工、对合作伙伴、对社会有良心，用双赢、多赢、共赢的观念来促进多方面的合作。为创建一个民族的、多品牌的、国内领先的快餐连锁企业集团而不懈努力，为民族餐饮业的发展做出自己积极的贡献。"
                   },
                 @{
                   @"storeName" : @"拿铁",
                   @"detail":@"        优质食品，美好生活是我们时时刻刻、无处不在的承诺——用优质的食品和饮料来提高生活质量，将该理念贯穿生命各个阶段"
                   },
                 @{
                   @"storeName" : @"浓缩咖啡",
                   @"detail":@"        自从1940年夏天开第一家冰淇淋店开始，迄今为止，已在25个国家，开了近8000家连锁店。它提供Dairy Queen冰淇淋、Orange Julius鲜果露、Karmelkom爆米花等休闲食品，是世界销量第一的软冰淇淋专家和全球连锁快餐业巨头之一。\n        DQ的冰淇淋都是软体冰淇淋，经过均匀搅拌后，有倒杯不洒的美誉。明星产品“暴风雪”还能做到“倒杯不洒”，这是其它冰淇淋所不具备的，非常神奇。美国权威期刊“Restaurants and Institutions”每年对全球400个连锁餐饮品牌进行排名，DQ在冰淇淋产品市场连续数年全球排名第一！"
                   },
                 @{
                   @"storeName" : @"摩卡",
                   @"detail":@"        优质食品，美好生活是我们时时刻刻、无处不在的承诺——用优质的食品和饮料来提高生活质量，将该理念贯穿生命各个阶段"
                   },
                 @{
                   @"storeName" : @"香草拿铁",
                   @"detail":@"        夏天正劲，混搭出趣！全新推出的咖啡三重奏星冰乐，把苏门答腊、意式烘焙和浓缩烘焙三种滋味放进一杯！美味的咖啡吉利，冰爽的咖啡星冰乐和滑顺的浓缩咖啡搅打奶油，为你打造浓郁的咖啡体验。更有夏莓意式奶冻星冰乐与摩卡曲奇星冰乐，丰富你的选择！"
                   },
                 nil ];

        [self initMainView];
        
    }
    return self;
}

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    _currentIndex = currentIndex;
    [self initSubView];
}
-(void)initMainView {
    
    _mainView=[[UIView alloc]initWithFrame:CGRectMake(screenWidth/10, screenHeight/8+44, 4*screenWidth/5, 3*screenHeight/4 -50)];
    _mainView.backgroundColor=[UIColor clearColor];
    [self addSubview:_mainView];
}

- (void)initSubView
{
    _descriptionView=[[UIView alloc]initWithFrame:CGRectMake(0,0, 4*screenWidth/5, 3*screenHeight/4 -50)];
    _descriptionView.backgroundColor = [UIColor whiteColor];
    _descriptionView.userInteractionEnabled=YES;
    UIPanGestureRecognizer *panGestureRecognizer=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(cardPanEven:)];
    [_descriptionView addGestureRecognizer:panGestureRecognizer];
    _descriptionView.layer.cornerRadius=8;
    _descriptionView.layer.masksToBounds = YES;
    
    [_mainView insertSubview:_descriptionView atIndex:0];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 12, 200, 21)];
    _nameLabel.text = [_data objectAtIndex:_currentIndex][@"storeName"];
    _nameLabel.textColor = [UIColor colorWithRed:78.0/255.0 green:78.0/255.0 blue:78.0/255.0 alpha:1];
    [_descriptionView addSubview:_nameLabel];
    
    _descriptionImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, _nameLabel.frame.origin.y+_nameLabel.frame.size.height+4, 4*screenWidth/5-12*2, 4*screenWidth/5-50)];
    _descriptionImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",[_data objectAtIndex:_currentIndex][@"storeName"]]];
    [_descriptionView addSubview:_descriptionImageView];
    [self addBlurViewView:_descriptionImageView];
    
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, _descriptionImageView.frame.size.height-26, 100, 21)];
    moneyLabel.text = @"省 40元";
    moneyLabel.textColor = [UIColor orangeColor];
    [_descriptionImageView addSubview:moneyLabel];
    
    _descriptionTextView = [[UITextView alloc] initWithFrame:CGRectMake(12, _descriptionImageView.frame.origin.y+_descriptionImageView.frame.size.height+4, 4*screenWidth/5-12*2, 3*screenHeight/4-4*screenWidth/5-45)];
    _descriptionTextView.text = [_data objectAtIndex:_currentIndex][@"detail"];
    _descriptionTextView.backgroundColor = [UIColor whiteColor];
    _descriptionTextView.textColor = [UIColor grayColor];
    _descriptionTextView.editable = NO;
    [_descriptionView addSubview:_descriptionTextView];
    
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
}

- (void)refreshDescriptionView {
    
    _nameLabel.text = [_data objectAtIndex:_currentIndex][@"storeName"];
    _descriptionImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",[_data objectAtIndex:_currentIndex][@"storeName"]]];
    _descriptionTextView.text = [_data objectAtIndex:_currentIndex][@"detail"];
    
}

#pragma mark -  主播卡片滑动手势 方法

static CGPoint startPoint;
static CGPoint endPoint;
static NSInteger oldIndex;
-(void)cardPanEven:(UIPanGestureRecognizer *)sender{
    
    if (!self.isPaning) {
        [_mainView bringSubviewToFront:sender.view];
        startPoint=[sender translationInView:_mainView];
        endPoint=startPoint;
        oldIndex=_currentIndex;
        if (_currentIndex<_data.count-1&&_currentIndex>=0) {
            _currentIndex++;
        }
        else{
            _currentIndex=0;
        }
        [self initSubView];
        _descriptionView.transform=CGAffineTransformMakeScale(0.9, 0.9);
        [self setCurrentInfo:_currentIndex];
        _descriptionView.userInteractionEnabled=NO;
        _paning=YES;
    }
    
    
    CGPoint point=[sender translationInView:_mainView];
    
    endPoint=CGPointMake(endPoint.x+point.x, endPoint.y+point.y);
    
    sender.view.transform=CGAffineTransformTranslate(sender.view.transform, point.x, point.y) ;
    [sender setTranslation:CGPointMake(0, 0) inView:_mainView];
    
    CGFloat scale= (abs(endPoint.x-startPoint.x)+abs(endPoint.y-startPoint.y))*0.0005;
    scale=MIN(0.1, scale);
    _descriptionView.transform=CGAffineTransformMakeScale(0.9+scale, 0.9+scale);
    
    if (sender.state==UIGestureRecognizerStateEnded) {
        
        if (abs(endPoint.x-startPoint.x) <=100&&abs(endPoint.y-startPoint.y)<=100) {
            [_descriptionView removeFromSuperview];
            _descriptionView=sender.view;
            [self setCurrentInfo:oldIndex];
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

-(void)setCurrentInfo:(NSInteger)currentindex
{
    if (_data.count<=0) {
        return;
    }
    _currentIndex = currentindex;
    [self refreshDescriptionView];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if ([[touches anyObject]view]!=_mainView &&[[touches anyObject]view]!=_descriptionView) {
        [self removeFromSuperview];
    }
}


#pragma mark - 关掉页面
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
        blurEffectView.frame =  CGRectMake(0, view.frame.size.height-30, view.frame.size.width, 30);
        [view insertSubview:blurEffectView atIndex:0];
    }
    else{
        UIView *blurEffectView = [[UIView alloc] init];
        blurEffectView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        blurEffectView.frame = CGRectMake(0, view.frame.size.height-30, view.frame.size.width, 30);
        [view insertSubview:blurEffectView atIndex:0];
    }
}

@end
