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
#import "KYCuteView.h"
#import "SVProgressShow.h"

//#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface HotFocusViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,strong) NSMutableArray * plistArr;

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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
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
    self.dataArray = [[NSMutableArray alloc] init];
    self.plistArr =[[NSMutableArray alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"store" ofType:@"plist"]];
}

- (void)initTableView
{
    //删除底部多余横线
    self.tableView.tableFooterView =[[UIView alloc]init];
    //动画
    [self.tableView reloadDataAnimateWithWave:RightToLeftWaveAnimation];
    
    self.tableView.backgroundColor = shrbTableViewColor;
}

#pragma mark - tableView dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 244;
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.plistArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimpleTableIdentifier = @"HotMembersTableViewCellIdentifier";
    HotFocusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (cell == nil) {
        cell = [[HotFocusTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
    }
    
    [self.dataArray removeAllObjects];
    for (NSDictionary * dict in self.plistArr) {
        HotFocusModel * model = [[HotFocusModel alloc] init];
        [model setValuesForKeysWithDictionary:dict];
        [self.dataArray addObject:model];
    }

    cell.model = self.dataArray[indexPath.row];
    // start animating
 //   [cell.hotImageView startAnimating];

    
//    if (indexPath.row == 0) {
//        KYCuteView *badgeLabel = [[KYCuteView alloc]initWithPoint:CGPointMake(60, 4) superView:cell];
//        badgeLabel.viscosity = 8;
//        badgeLabel.bubbleWidth = 20;
//        badgeLabel.bubbleColor = [UIColor redColor];
//        [badgeLabel setUp];
//        [badgeLabel addGesture];
//        badgeLabel.bubbleLabel.text = @"2";
//        badgeLabel.bubbleLabel.textColor = [UIColor whiteColor];
//        
//        NSString *badgeNum = badgeLabel.bubbleLabel.text;
//        NSInteger num =  [badgeNum integerValue];
//        badgeLabel.frontView.hidden = num == 0?YES:NO;
//    }
    
    cell.tag = indexPath.row;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //是否会员
    if (indexPath.row %2 == 0) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isMember"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isMember"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"store"];
        [[NSUserDefaults standardUserDefaults] setObject:@"holy" forKey:@"store"];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isMember"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isMember"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"store"];
        [[NSUserDefaults standardUserDefaults] setObject:@"16D" forKey:@"store"];
    }
    
    if (indexPath.row == 0) {
        [[NSUserDefaults standardUserDefaults] setObject:@"16D" forKey:@"store"];
    }
    else if (indexPath.row == 1) {
        [[NSUserDefaults standardUserDefaults] setObject:@"yunifang" forKey:@"store"];
    }
    else if (indexPath.row == 2) {
        [[NSUserDefaults standardUserDefaults] setObject:@"holy" forKey:@"store"];
    }
    else if (indexPath.row == 3) {
        [[NSUserDefaults standardUserDefaults] setObject:@"McDonalds" forKey:@"store"];
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
    
//    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    HotDetailViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"HotDetailView"];
//    viewController.storeNum = indexPath.row;
//    [viewController setModalPresentationStyle:UIModalPresentationFullScreen];
//    
//    [self.navigationController pushViewController:viewController animated:YES];
    
    [SVProgressShow showWithStatus:@"进入店铺..."];
    
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(todoSomething) object:nil];
    [self performSelector:@selector(todoSomething) withObject:nil afterDelay:0.4f];
    
}


#pragma mark - 延时显示状态然后跳转
- (void)todoSomething
{
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
    [self.navigationController pushViewController:viewController animated:YES];
    [SVProgressShow dismiss];
}
@end









