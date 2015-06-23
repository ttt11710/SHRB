//
//  CouponsTableViewController.m
//  shrb
//  电子券
//  Created by PayBay on 15/5/20.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "CouponsTableViewController.h"
#import "CouponsTableViewCell.h"
#import "CouponsModel.h"
#import "UITableView+Wave.h"
#import "Const.h"

@interface CouponsTableViewController ()

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation CouponsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initTableView];
    
}

- (void)initData {
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:
                             @{
                               @"couponsImage" : @"雀巢",
                               @"money" : @"1000",
                               @"count":@"4",
                               },
                             @{
                               @"couponsImage" : @"官方头像",
                               @"money" : @"2000",
                               @"count":@"1",
                               },
                             @{
                               @"couponsImage" : @"辛巴克",
                               @"money" : @"3000",
                               @"count":@"2",
                               },
                             nil];
    
    self.dataArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary * dict in array) {
        CouponsModel * model = [[CouponsModel alloc] init];
        [model setValuesForKeysWithDictionary:dict];
        [self.dataArray addObject:model];
    }
}

- (void)initTableView
{
    self.tableView.tableFooterView =[[UIView alloc]init];
    self.tableView.backgroundColor = HexRGB(0xF1EFEF);
    
    [self.tableView reloadDataAnimateWithWave:RightToLeftWaveAnimation];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.dataArray count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *SimpleTableIdentifier = @"couponsTableViewCellIdentifier";
    CouponsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (cell == nil) {
        cell = [[CouponsTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:SimpleTableIdentifier];
    }
    
    cell.model = self.dataArray[indexPath.row];
    
    return cell;
}



@end
