//
//  UserCenterTableViewController.m
//  shrb
//  我的首页
//  Created by PayBay on 15/6/8.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserCenterObjevtiveTableViewController.h"
//#import "shrb-swift.h"
#import "Const.h"

@interface UserCenterObjevtiveTableViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *memberNumLabel;
@end

@implementation UserCenterObjevtiveTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [self initController];
    [self initTableView];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"IsLogin"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"IsLogin"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    
    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"IsLogin"];
    if (!isLogin)
    {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        UIViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"loginView"];
        [viewController setModalPresentationStyle:UIModalPresentationFullScreen];
        [viewController setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:viewController animated:YES];
    }
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
    
    self.tabBarController.tabBar.selectedItem.selectedImage = [UIImage imageNamed:@"我的_highlight"];
}

- (void)initTableView
{
    //删除多余线
    self.tableView.tableFooterView =[[UIView alloc]init];
    
    self.tableView.backgroundColor = shrbTableViewColor;
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section == 0? 68:44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
    return section == 0?1:section==1?3:3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0? 0:8;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    //基本信息
    if (indexPath.section == 0)
    {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
        UIViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"infoView"];
        [viewController setModalPresentationStyle:UIModalPresentationFullScreen];
        [self.navigationController pushViewController:viewController animated:YES];
        
//        BasicInfoTableViewController *basicInfoTableViewController = [[BasicInfoTableViewController alloc] init];
//        [self.navigationController pushViewController:basicInfoTableViewController animated:YES];
        
    }
    else if (indexPath.section == 1)
    {
        //我的订单
        if (indexPath.row == 0) {
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
            UIViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"orderlistView"];
            [viewController setModalPresentationStyle:UIModalPresentationFullScreen];
            [self.navigationController pushViewController:viewController animated:YES];
            
            //            OrderListViewController *orderListViewController = [[OrderListViewController alloc] init];
            //            [self.navigationController pushViewController:orderListViewController animated:YES];
        }
        //我的收藏
        else if (indexPath.row == 1) {
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
            UIViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"collectObjectiveView"];
            [viewController setModalPresentationStyle:UIModalPresentationFullScreen];
            [self.navigationController pushViewController:viewController animated:YES];

        }
        //设置
        else if (indexPath.row == 2) {
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
            UIViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"settingView"];
            [viewController setModalPresentationStyle:UIModalPresentationFullScreen];
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
    else {
        //帮助中心
        if (indexPath.row == 0) {
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
            UIViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"helpCenterView"];
            [viewController setModalPresentationStyle:UIModalPresentationFullScreen];
            [self.navigationController pushViewController:viewController animated:YES];
        }
        //客服
        else if (indexPath.row == 1) {
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
            UIViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"shrbServiceView"];
            [viewController setModalPresentationStyle:UIModalPresentationFullScreen];
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
}

@end
