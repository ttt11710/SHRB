//
//  HotViewController.m
//  shrb
//  热点
//  Created by PayBay on 15/5/20.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "HotFocusViewController.h"
#import "HotFocusTableViewCell.h"
#import "HotFocusModel.h"
#import "HotDetailViewController.h"
#import "UITableView+Wave.h"
#import "Const.h"
#import <CBZSplashView/CBZSplashView.h>

//#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface HotFocusViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray * dataArray;

@end

@implementation HotFocusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initController];
    [self initData];
    [self initTableView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)initController
{
    //导航颜色
    self.navigationController.navigationBar.barTintColor = shrbPink;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    //工具栏图片 选中颜色
    self.tabBarController.tabBar.selectedItem.selectedImage = [UIImage imageNamed:@"恋人_highlight"];
    self.tabBarController.tabBar.tintColor = shrbPink;
    
    //动画 全屏
    UIImage *icon = [UIImage imageNamed:@"官方头像"];
    UIColor *color = shrbPink;
    CBZSplashView *splashView = [CBZSplashView splashViewWithIcon:icon backgroundColor:color];
    [self.view addSubview:splashView];
    [splashView startAnimation];

}

- (void)initData
{
    //假数据
    NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:
                             @{
                               @"status" : @"超市不是会员",
                               @"storeName" : @"辛巴克",
                               },
                             @{
                               @"status" : @"超市是会员",
                               @"storeName" : @"吉野家",
                               },
                             @{
                               @"status" : @"点餐不是会员",
                               @"storeName" : @"雀巢",
                               },
                             @{
                               @"status" : @"点餐是会员",
                               @"storeName" : @"冰雪皇后",
                               },
                             @{
                               @"status" : @"小店不是会员",
                               @"storeName" : @"雀巢",
                               },
                             @{
                               @"status" : @"小店是会员",
                               @"storeName" : @"冰雪皇后",
                               },
                             nil ];
    
    self.dataArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary * dict in array) {
        HotFocusModel * model = [[HotFocusModel alloc] init];
        [model setValuesForKeysWithDictionary:dict];
        [self.dataArray addObject:model];
    }
}

- (void)initTableView
{
    //删除底部多余横线
    self.tableView.tableFooterView =[[UIView alloc]init];
    //动画
    [self.tableView reloadDataAnimateWithWave:RightToLeftWaveAnimation];
    
    self.tableView.backgroundColor = HexRGB(0xF1EFEF);
}

#pragma mark - tableView dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimpleTableIdentifier = @"HotMembersTableViewCellIdentifier";
    HotFocusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (cell == nil) {
        cell = [[HotFocusTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
    }
    
    cell.model = self.dataArray[indexPath.row];
    
    cell.tag = indexPath.row;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //是否会员
    if (indexPath.row %2 == 0) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isMember"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isMember"];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isMember"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isMember"];
    }
    
     //商店类型 supermarket（超市）  order（点餐） store(小店)
    if (indexPath.row ==0 || indexPath.row == 1) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"typesOfShops"];
        [[NSUserDefaults standardUserDefaults] setObject:@"supermarket" forKey:@"typesOfShops"];
    }
    else if (indexPath.row == 2 || indexPath.row == 3)
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"typesOfShops"];
        [[NSUserDefaults standardUserDefaults] setObject:@"order" forKey:@"typesOfShops"];
    }

    else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"typesOfShops"];
        [[NSUserDefaults standardUserDefaults] setObject:@"store" forKey:@"typesOfShops"];
    }

    HotFocusTableViewCell* cell = (HotFocusTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HotDetailViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"HotDetailView"];
    viewController.storeNum = indexPath.row;
    [viewController setModalPresentationStyle:UIModalPresentationFullScreen];
    
    [self.navigationController pushViewController:viewController animated:YES];
    
    
}

@end









