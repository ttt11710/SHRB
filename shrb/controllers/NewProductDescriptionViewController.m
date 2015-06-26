//
//  NewProductDescriptionViewController.m
//  shrb
//
//  Created by PayBay on 15/6/25.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "NewProductDescriptionViewController.h"
#import "Const.h"

@interface NewProductDescriptionViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *tradeImageView;
@property (weak, nonatomic) IBOutlet UILabel *saveMoneyLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

@property (nonatomic,strong) NSMutableArray * dataArray;

@end

@implementation NewProductDescriptionViewController

@synthesize currentIndex;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initView];
}


- (void)initData
{
    self.dataArray = [[NSMutableArray alloc] initWithObjects:
             @{
               @"tradeImage" : @"提拉米苏",
               @"saveMoney" : @"60",
               @"detail":@"        夏天正劲，混搭出趣！全新推出的咖啡三重奏星冰乐，把苏门答腊、意式烘焙和浓缩烘焙三种滋味放进一杯！美味的咖啡吉利，冰爽的咖啡星冰乐和滑顺的浓缩咖啡搅打奶油，为你打造浓郁的咖啡体验。更有夏莓意式奶冻星冰乐与摩卡曲奇星冰乐，丰富你的选择！"
               },
             @{
               @"tradeImage" : @"蜂蜜提子可颂",
               @"saveMoney" : @"60",
               @"detail":@"        中华沃土，润生万物，时代沧桑，印证合兴风雨历程。几十年的风雨坎坷、改革创新，合兴走过了一条发展的路、创新的路、希望的路。在国家迅速发展的大环境下，在社会各界朋友以及广大顾客的大力支持下，合兴餐饮集团有了今天的规模。\n        面对取得的成绩我们没有丝毫的骄傲，我们将一如既往，用“良心品质”核心价值观来指导企业的行为，做到对顾客、对员工、对合作伙伴、对社会有良心，用双赢、多赢、共赢的观念来促进多方面的合作。为创建一个民族的、多品牌的、国内领先的快餐连锁企业集团而不懈努力，为民族餐饮业的发展做出自己积极的贡献。"
               },
             @{
               @"tradeImage" : @"芝士可颂",
               @"saveMoney" : @"60",
               @"detail":@"        优质食品，美好生活是我们时时刻刻、无处不在的承诺——用优质的食品和饮料来提高生活质量，将该理念贯穿生命各个阶段"
               },
             @{
               @"tradeImage" : @"牛奶",
               @"saveMoney" : @"60",
               @"detail":@"        自从1940年夏天开第一家冰淇淋店开始，迄今为止，已在25个国家，开了近8000家连锁店。它提供Dairy Queen冰淇淋、Orange Julius鲜果露、Karmelkom爆米花等休闲食品，是世界销量第一的软冰淇淋专家和全球连锁快餐业巨头之一。\n        DQ的冰淇淋都是软体冰淇淋，经过均匀搅拌后，有倒杯不洒的美誉。明星产品“暴风雪”还能做到“倒杯不洒”，这是其它冰淇淋所不具备的，非常神奇。美国权威期刊“Restaurants and Institutions”每年对全球400个连锁餐饮品牌进行排名，DQ在冰淇淋产品市场连续数年全球排名第一！"
               },
             @{
               @"tradeImage" : @"抹茶拿铁",
               @"saveMoney" : @"60",
               @"detail":@"        优质食品，美好生活是我们时时刻刻、无处不在的承诺——用优质的食品和饮料来提高生活质量，将该理念贯穿生命各个阶段"
               },
             @{
               @"tradeImage" : @"英式红茶",
               @"saveMoney" : @"60",
               @"detail":@"        中华沃土，润生万物，时代沧桑，印证合兴风雨历程。几十年的风雨坎坷、改革创新，合兴走过了一条发展的路、创新的路、希望的路。在国家迅速发展的大环境下，在社会各界朋友以及广大顾客的大力支持下，合兴餐饮集团有了今天的规模。\n        面对取得的成绩我们没有丝毫的骄傲，我们将一如既往，用“良心品质”核心价值观来指导企业的行为，做到对顾客、对员工、对合作伙伴、对社会有良心，用双赢、多赢、共赢的观念来促进多方面的合作。为创建一个民族的、多品牌的、国内领先的快餐连锁企业集团而不懈努力，为民族餐饮业的发展做出自己积极的贡献。"
               },
             @{
               @"tradeImage" : @"冰拿铁",
               @"saveMoney" : @"60",
               @"detail":@"        夏天正劲，混搭出趣！全新推出的咖啡三重奏星冰乐，把苏门答腊、意式烘焙和浓缩烘焙三种滋味放进一杯！美味的咖啡吉利，冰爽的咖啡星冰乐和滑顺的浓缩咖啡搅打奶油，为你打造浓郁的咖啡体验。更有夏莓意式奶冻星冰乐与摩卡曲奇星冰乐，丰富你的选择！"
               },
             @{
               @"tradeImage" : @"卡布奇诺",
               @"saveMoney" : @"60",
               @"detail":@"        中华沃土，润生万物，时代沧桑，印证合兴风雨历程。几十年的风雨坎坷、改革创新，合兴走过了一条发展的路、创新的路、希望的路。在国家迅速发展的大环境下，在社会各界朋友以及广大顾客的大力支持下，合兴餐饮集团有了今天的规模。\n        面对取得的成绩我们没有丝毫的骄傲，我们将一如既往，用“良心品质”核心价值观来指导企业的行为，做到对顾客、对员工、对合作伙伴、对社会有良心，用双赢、多赢、共赢的观念来促进多方面的合作。为创建一个民族的、多品牌的、国内领先的快餐连锁企业集团而不懈努力，为民族餐饮业的发展做出自己积极的贡献。"
               },
             
             @{
               @"tradeImage" : @"焦糖玛奇朵",
               @"saveMoney" : @"60",
               @"detail":@"        优质食品，美好生活是我们时时刻刻、无处不在的承诺——用优质的食品和饮料来提高生活质量，将该理念贯穿生命各个阶段"
               },
             @{
               @"tradeImage" : @"美式咖啡",
               @"saveMoney" : @"60",
               @"detail":@"        中华沃土，润生万物，时代沧桑，印证合兴风雨历程。几十年的风雨坎坷、改革创新，合兴走过了一条发展的路、创新的路、希望的路。在国家迅速发展的大环境下，在社会各界朋友以及广大顾客的大力支持下，合兴餐饮集团有了今天的规模。\n        面对取得的成绩我们没有丝毫的骄傲，我们将一如既往，用“良心品质”核心价值观来指导企业的行为，做到对顾客、对员工、对合作伙伴、对社会有良心，用双赢、多赢、共赢的观念来促进多方面的合作。为创建一个民族的、多品牌的、国内领先的快餐连锁企业集团而不懈努力，为民族餐饮业的发展做出自己积极的贡献。"
               },
             @{
               @"tradeImage" : @"拿铁",
               @"saveMoney" : @"60",
               @"detail":@"        优质食品，美好生活是我们时时刻刻、无处不在的承诺——用优质的食品和饮料来提高生活质量，将该理念贯穿生命各个阶段"
               },
             @{
               @"tradeImage" : @"浓缩咖啡",
               @"saveMoney" : @"60",
               @"detail":@"        自从1940年夏天开第一家冰淇淋店开始，迄今为止，已在25个国家，开了近8000家连锁店。它提供Dairy Queen冰淇淋、Orange Julius鲜果露、Karmelkom爆米花等休闲食品，是世界销量第一的软冰淇淋专家和全球连锁快餐业巨头之一。\n        DQ的冰淇淋都是软体冰淇淋，经过均匀搅拌后，有倒杯不洒的美誉。明星产品“暴风雪”还能做到“倒杯不洒”，这是其它冰淇淋所不具备的，非常神奇。美国权威期刊“Restaurants and Institutions”每年对全球400个连锁餐饮品牌进行排名，DQ在冰淇淋产品市场连续数年全球排名第一！"
               },
             @{
               @"tradeImage" : @"摩卡",
               @"saveMoney" : @"60",
               @"detail":@"        优质食品，美好生活是我们时时刻刻、无处不在的承诺——用优质的食品和饮料来提高生活质量，将该理念贯穿生命各个阶段"
               },
             @{
               @"tradeImage" : @"香草拿铁",
               @"saveMoney" : @"60",
               @"detail":@"        夏天正劲，混搭出趣！全新推出的咖啡三重奏星冰乐，把苏门答腊、意式烘焙和浓缩烘焙三种滋味放进一杯！美味的咖啡吉利，冰爽的咖啡星冰乐和滑顺的浓缩咖啡搅打奶油，为你打造浓郁的咖啡体验。更有夏莓意式奶冻星冰乐与摩卡曲奇星冰乐，丰富你的选择！"
               },
             nil ];
}

- (void)initView
{
    self.tradeImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",self.dataArray[currentIndex][@"tradeImage"]]];
    
    self.saveMoneyLabel.text = [NSString stringWithFormat:@"省￥%@元",self.dataArray[currentIndex][@"saveMoney"]];
    self.descriptionTextView.text = [NSString stringWithFormat:@"%@",self.dataArray[currentIndex][@"detail"]];
}

- (void)viewDidLayoutSubviews {
    
    self.scrollView.contentSize = CGSizeMake(0,screenHeight+100);
    
    self.tradeImageView.layer.cornerRadius = 10;
    self.tradeImageView.layer.masksToBounds = YES;
    [self addBlurViewView:self.tradeImageView];
}

#pragma mark - 蒙版效果
- (void)addBlurViewView:(UIView *)view
{
    if (IsIOS8) {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurEffectView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        blurEffectView.frame = CGRectMake(0, view.frame.size.height-45, view.frame.size.width, 45);
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
