//
//  SettingTableViewController.m
//  shrb
//
//  Created by PayBay on 15/6/16.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "SettingTableViewController.h"
#import "Const.h"

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
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 4;
}
@end
