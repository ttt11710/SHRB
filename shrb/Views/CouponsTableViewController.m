//
//  CouponsTableViewController.m
//  shrb
//  电子券
//  Created by PayBay on 15/5/20.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "CouponsTableViewController.h"
#import "CouponsTableViewCell.h"
#import "ReceiveCouponsTableViewCell.h"
#import "CouponsModel.h"
#import "UITableView+Wave.h"
#import "Const.h"
#import "SVProgressShow.h"

@interface CouponsTableViewController ()
{
    NSMutableArray *_array;
    NSMutableArray *_receiveArray;
}

@property (nonatomic, strong) NSMutableArray *receiveDataArray;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation CouponsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initTableView];
    
}

- (void)initData {
    
    _array = [[NSMutableArray alloc] initWithObjects:
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
    
    for (NSDictionary * dict in _array) {
        CouponsModel * model = [[CouponsModel alloc] init];
        [model setValuesForKeysWithDictionary:dict];
        [self.dataArray addObject:model];
    }
    
    _receiveArray = [[NSMutableArray alloc] initWithObjects:
                     @{
                       @"couponsImage" : @"吉野家",
                       @"money" : @"1000",
                       @"count":@"4",
                       },
                     @{
                       @"couponsImage" : @"冰雪皇后",
                       @"money" : @"2000",
                       @"count":@"1",
                       },
                     nil];
    
    self.receiveDataArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary * dict in _receiveArray) {
        CouponsModel * model = [[CouponsModel alloc] init];
        [model setValuesForKeysWithDictionary:dict];
        [self.receiveDataArray addObject:model];
    }

}

- (void)initTableView
{
    self.tableView.tableFooterView =[[UIView alloc]init];
    self.tableView.backgroundColor = HexRGB(0xF1EFEF);
    
    [self.tableView reloadDataAnimateWithWave:RightToLeftWaveAnimation];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0?0:10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return section == 0?[self.receiveDataArray count]:[self.dataArray count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        static NSString *SimpleTableIdentifier = @"ReceiveCouponsTableViewCellIdentifier";
        ReceiveCouponsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (cell == nil) {
            cell = [[ReceiveCouponsTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:SimpleTableIdentifier];
        }
        
        cell.model = self.receiveDataArray[indexPath.row];
        return cell;
    }
    
    else {
        static NSString *SimpleTableIdentifier = @"couponsTableViewCellIdentifier";
        CouponsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (cell == nil) {
            cell = [[CouponsTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:SimpleTableIdentifier];
        }
        
        cell.model = self.dataArray[indexPath.row];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        CouponsModel * model = [[CouponsModel alloc] init];
        [model setValuesForKeysWithDictionary:[_receiveArray objectAtIndex:indexPath.row]];
        [self.dataArray addObject:model];
        
        [self.receiveDataArray removeAllObjects];
        [_receiveArray removeObjectAtIndex:indexPath.row];
        for (NSDictionary * dict in _receiveArray) {
            CouponsModel * model = [[CouponsModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            [self.receiveDataArray addObject:model];
        }
        
        [SVProgressShow showSuccessWithStatus:@"接收成功！"];
        
        [self.tableView reloadData];
    }
}

@end
