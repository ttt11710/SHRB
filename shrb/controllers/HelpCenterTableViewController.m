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
    self.tableView.backgroundColor = shrbTableViewColor;
    //删除多余线
    self.tableView.tableFooterView =[[UIView alloc]init];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 6;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"常见问题";
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat height ;
    height = 44;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, height)] ;
    [headerView setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, (height-18)*0.5, tableView.bounds.size.width - 10, 18)];
       label.textColor = shrbText;
    label.text = @"常见问题";
    label.backgroundColor = [UIColor clearColor];
    [headerView addSubview:label];
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, height-1, tableView.bounds.size.width, 1)] ;
    [footView setBackgroundColor:shrbTableViewColor];
    [headerView addSubview:footView];
    
    return headerView;
}

@end
