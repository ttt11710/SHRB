//
//  CollectTableViewController.m
//  shrb
//
//  Created by PayBay on 15/7/3.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "CollectObjectiveTableViewController.h"
#import "CollectTableViewCell.h"
#import "Const.h"

@interface CollectObjectiveTableViewController ()

@property (nonatomic, strong) NSMutableArray *data;

@end

@implementation CollectObjectiveTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initTableView];
    
}

- (void)initData
{
    self.data = [[NSMutableArray alloc] initWithObjects:
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
                   @"storeDetail":@"        优质食品，美好生活是我们时时刻刻、无处不在的承诺——用优质的食品和饮料来提高生活质量，将该理念贯穿生命各个阶段。"
                   },
                 @{
                   @"storeName" : @"冰雪皇后",
                   @"storeDetail":@"        自从1940年夏天开第一家冰淇淋店开始，迄今为止，已在25个国家，开了近8000家连锁店。它提供Dairy Queen冰淇淋、Orange Julius鲜果露、Karmelkom爆米花等休闲食品，是世界销量第一的软冰淇淋专家和全球连锁快餐业巨头之一。\n        DQ的冰淇淋都是软体冰淇淋，经过均匀搅拌后，有倒杯不洒的美誉。明星产品“暴风雪”还能做到“倒杯不洒”，这是其它冰淇淋所不具备的，非常神奇。美国权威期刊“Restaurants and Institutions”每年对全球400个连锁餐饮品牌进行排名，DQ在冰淇淋产品市场连续数年全球排名第一！"
                   },
                 nil];
}

- (void)initTableView
{
    self.tableView.backgroundColor = shrbTableViewColor;
}


#pragma mark - tableView dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenWidth - 100, 0)];
    UIFont* theFont = [UIFont systemFontOfSize:15.0];
    label.numberOfLines = 0;
    [label setFont:theFont];
    [label setText:self.data[indexPath.row][@"storeDetail"]];
    
    [label sizeToFit];// 显示文本需要的长度和宽度
    
    return label.frame.size.height+40;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimpleTableIdentifier = @"CollectTableViewCellIdentifier";
    CollectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (cell == nil) {
        cell = [[CollectTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
    }
    //cell 选中方式
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.collectImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",self.data[indexPath.row][@"storeName"]]];
    cell.collectDetailLabel.text =  self.data[indexPath.row][@"storeDetail"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"HotDetailView"];
        [viewController setModalPresentationStyle:UIModalPresentationFullScreen];
        [self.navigationController pushViewController:viewController animated:YES];
}
@end
