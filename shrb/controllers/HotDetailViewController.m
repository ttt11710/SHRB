//
//  HotDetailViewController.m
//  shrb
//  热点详情
//  Created by PayBay on 15/5/19.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "HotDetailViewController.h"
#import "HotDetailTableViewCell.h"
#import <DCAnimationKit/UIView+DCAnimationKit.h>
#import <BFPaperButton/BFPaperButton.h>
#import "SVProgressShow.h"
#import "HotFocusModel.h"
#import "Const.h"
#import "DOPScrollableActionSheet.h"

@interface HotDetailViewController ()
{
    UIView *_moreView;
    NSMutableArray *_array;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray * dataArray;

@end

@implementation HotDetailViewController

@synthesize storeNum;

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self makeNavigationBar];
    [self initData];
    [self initTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden=YES;
}

- (void)makeNavigationBar
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addBtnPressed)];
    
    _moreView = [[UIView alloc] initWithFrame:CGRectMake(screenWidth-85, 20+44-8, 80, 35*2)];
    _moreView.hidden = YES;
    UIButton *collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    collectBtn.frame = CGRectMake(0, 0, 80, 35);
    [collectBtn setTitle:@"收藏" forState:UIControlStateNormal];
    [collectBtn setTitleColor:shrbPink forState:UIControlStateNormal];
    [collectBtn setBackgroundColor:[UIColor whiteColor]];
    collectBtn.layer.borderColor = shrbPink.CGColor;
    collectBtn.layer.borderWidth = 1;
    [collectBtn addTarget:self action:@selector(collectBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [_moreView addSubview:collectBtn];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(0, collectBtn.frame.size.height-1, 80, 35);
    [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    [shareBtn setTitleColor:shrbPink forState:UIControlStateNormal];
    [shareBtn setBackgroundColor:[UIColor whiteColor]];
    shareBtn.layer.borderColor = shrbPink.CGColor;
    shareBtn.layer.borderWidth = 1;
    [shareBtn addTarget:self action:@selector(shareBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [_moreView addSubview:shareBtn];
    
    [self.navigationController.view addSubview:_moreView];
    
}

- (void)initData
{
    _array = [[NSMutableArray alloc] initWithObjects:
              @{
                @"storeName" : @"辛巴克",
                @"storeDetail":@"        夏天正劲，混搭出趣！全新推出的咖啡三重奏星冰乐，把苏门答腊、意式烘焙和浓缩烘焙三种滋味放进一杯！美味的咖啡吉利，冰爽的咖啡星冰乐和滑顺的浓缩咖啡搅打奶油，为你打造浓郁的咖啡体验。更有夏莓意式奶冻星冰乐与摩卡曲奇星冰乐，丰富你的选择！"
                },
              @{
                @"storeName" : @"吉野家",
                @"storeDetail":@"        中华沃土，润生万物，时代沧桑，印证合兴风雨历程。几十年的风雨坎坷、改革创新，合兴走过了一条发展的路、创新的路、希望的路。在国家迅速发展的大环境下，在社会各界朋友以及广大顾客的大力支持下，合兴餐饮集团有了今天的规模。\n        面对取得的成绩我们没有丝毫的骄傲，我们将一如既往，用“良心品质”核心价值观来指导企业的行为，做到对顾客、对员工、对合作伙伴、对社会有良心，用双赢、多赢、共赢的观念来促进多方面的合作。为创建一个民族的、多品牌的、国内领先的快餐连锁企业集团而不懈努力，为民族餐饮业的发展做出自己积极的贡献。"
                },
              @{
                @"storeName" : @"雀巢",
                @"storeDetail":@"        优质食品，美好生活是我们时时刻刻、无处不在的承诺——用优质的食品和饮料来提高生活质量，将该理念贯穿生命各个阶段"
                },
              @{
                @"storeName" : @"冰雪皇后",
                @"storeDetail":@"        自从1940年夏天开第一家冰淇淋店开始，迄今为止，已在25个国家，开了近8000家连锁店。它提供Dairy Queen冰淇淋、Orange Julius鲜果露、Karmelkom爆米花等休闲食品，是世界销量第一的软冰淇淋专家和全球连锁快餐业巨头之一。\n        DQ的冰淇淋都是软体冰淇淋，经过均匀搅拌后，有倒杯不洒的美誉。明星产品“暴风雪”还能做到“倒杯不洒”，这是其它冰淇淋所不具备的，非常神奇。美国权威期刊“Restaurants and Institutions”每年对全球400个连锁餐饮品牌进行排名，DQ在冰淇淋产品市场连续数年全球排名第一！"
                },
              @{
                @"storeName" : @"雀巢",
                @"storeDetail":@"        优质食品，美好生活是我们时时刻刻、无处不在的承诺——用优质的食品和饮料来提高生活质量，将该理念贯穿生命各个阶段"
                },
              @{
                @"storeName" : @"冰雪皇后",
                @"storeDetail":@"        自从1940年夏天开第一家冰淇淋店开始，迄今为止，已在25个国家，开了近8000家连锁店。它提供Dairy Queen冰淇淋、Orange Julius鲜果露、Karmelkom爆米花等休闲食品，是世界销量第一的软冰淇淋专家和全球连锁快餐业巨头之一。\n        DQ的冰淇淋都是软体冰淇淋，经过均匀搅拌后，有倒杯不洒的美誉。明星产品“暴风雪”还能做到“倒杯不洒”，这是其它冰淇淋所不具备的，非常神奇。美国权威期刊“Restaurants and Institutions”每年对全球400个连锁餐饮品牌进行排名，DQ在冰淇淋产品市场连续数年全球排名第一！"
                },
              nil ];
    
    self.dataArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary * dict in _array) {
        HotFocusModel * model = [[HotFocusModel alloc] init];
        [model setValuesForKeysWithDictionary:dict];
        [self.dataArray addObject:model];
    }

}

- (void)initTableView
{
    //去除tableview顶部留白
    self.automaticallyAdjustsScrollViewInsets = false;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //上下震动动画
    [self.tableView bounce:nil];
}

#pragma mark - tableView dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenWidth - 68, 0)];
    UIFont* theFont = [UIFont systemFontOfSize:17.0];
    label.numberOfLines = 0;
    [label setFont:theFont];
    [label setText:_array[storeNum][@"storeDetail"]];
    
    
    [label sizeToFit];// 显示文本需要的长度和宽度
    
    CGFloat height = label.frame.size.height;
    
    if (label.frame.size.height+140 < screenHeight-(20+44+44)) {
        return screenHeight-(20+44+44);
    }
    else {
       return label.frame.size.height+176;
    }
}


#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimpleTableIdentifier = @"HotDetailTableCellIdentifier";
    HotDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    cell.model = self.dataArray[storeNum];
    
    return cell;
}

#pragma mark - 更多按钮
- (void)addBtnPressed
{
    _moreView.hidden = NO;
}

#pragma mark - 收藏
- (void)collectBtnPressed
{
    _moreView.hidden = YES;
    [SVProgressShow showWithStatus:@"请稍等..."];
    double delayInSeconds = 1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [SVProgressShow showSuccessWithStatus:@"收藏成功！"];
    });
}

#pragma mark - 分享
- (void)shareBtnPressed
{
    _moreView.hidden = YES;
    
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


#pragma mark - 进入商店
- (IBAction)gotoStoreView:(id)sender {
    
    NSString * typesOfShops = [[NSUserDefaults standardUserDefaults] stringForKey:@"typesOfShops"];
    
    //supermarket
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UIViewController *viewController;
    if ([typesOfShops isEqualToString:@"supermarket"]) {
        //超市
        viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"newstoreView"];
    }
    else if ([typesOfShops isEqualToString:@"order"]) {
        //点餐
        viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"storeView"];
    }
    else {
        //小店 暂时和超市一样
        viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"newstoreView"];
    }
    
    [viewController setModalPresentationStyle:UIModalPresentationFullScreen];
    [SVProgressShow showWithStatus:@"进入店铺..."];
    
    double delayInSeconds = 1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [SVProgressShow dismiss];
        [self.navigationController pushViewController:viewController animated:YES];
    });
}

@end
