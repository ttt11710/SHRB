//
//  HelpCenterTableViewController.m
//  shrb
//
//  Created by PayBay on 15/6/16.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "HelpCenterTableViewController.h"
#import "Const.h"

@interface HelpCenterTableViewController ()

@end

@implementation HelpCenterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTableView];
}

- (void)initTableView
{
    self.tableView.backgroundColor = HexRGB(0xF1EFEF);
    //删除多余线
    self.tableView.tableFooterView =[[UIView alloc]init];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 6;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"常见问题";
}
@end
