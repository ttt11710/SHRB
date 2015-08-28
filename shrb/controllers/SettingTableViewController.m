//
//  SettingTableViewController.m
//  shrb
//
//  Created by PayBay on 15/6/16.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "SettingTableViewController.h"
#import "Const.h"
#import "SVProgressShow.h"
#import "TBUser.h"

@interface SettingTableViewController ()

@end

@implementation SettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTableView];
}

- (void)initTableView
{
    self.tableView.backgroundColor = shrbTableViewColor;
    //删除多余线
    self.tableView.tableFooterView =[[UIView alloc]init];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row == 2?8: 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 7;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
        UIViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"updatePayPass"];
        [viewController setModalPresentationStyle:UIModalPresentationFullScreen];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    if (indexPath.row == 1) {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
        UIViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"updatePass"];
        [viewController setModalPresentationStyle:UIModalPresentationFullScreen];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
}

@end
