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
#import "CouponsDetailTableViewCell.h"
#import "TBUser.h"

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
    
    if ([TBUser currentUser].token.length == 0) {
        
        [SVProgressShow showInfoWithStatus:@"请先登录!"];
        return;
    }

    NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:
                             @{
                               @"couponsImage" : @"辛巴克",
                               @"money" : @"10000",
                               @"count":@"4",
                               @"expirationDate":@"2016-3-2",
                               @"canUse":@YES
                               },
                             @{
                               @"couponsImage" : @"官方头像",
                               @"money" : @"2000",
                               @"count":@"1",
                               @"expirationDate":@"2016-4-2",
                               @"canUse":@YES
                               },
                             @{
                               @"couponsImage" : @"吉野家",
                               @"money" : @"3000",
                               @"count":@"3",
                               @"expirationDate":@"2016-2-2",
                               @"canUse":@NO,
                               },
                             @{
                               @"couponsImage" : @"冰雪皇后",
                               @"money" : @"4000",
                               @"count":@"10",
                               @"expirationDate":@"2016-1-2",
                               @"canUse":@NO
                               },
                             @{
                               @"couponsImage" : @"雀巢",
                               @"money" : @"200",
                               @"count":@"2",
                               @"expirationDate":@"2015-12-2",
                               @"canUse":@NO
                               },
                             @{
                               @"couponsImage" : @"官方头像",
                               @"money" : @"2000",
                               @"count":@"1",
                               @"expirationDate":@"2016-4-2",
                               @"canUse":@YES
                               },
                             nil];
    
    
    self.dataArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary * dict in array) {
        CouponsModel * model = [[CouponsModel alloc] init];
        [model setValuesForKeysWithDictionary:dict];
        [self.dataArray addObject:model];
    }
    
    _receiveArray = [[NSMutableArray alloc] initWithObjects:
                     @{
                       @"couponsImage" : @"辛巴克",
                       @"money" : @"10000",
                       @"count":@"4",
                       @"expirationDate":@"2016-3-2",
                       @"canUse":@YES
                       },
                     @{
                       @"couponsImage" : @"官方头像",
                       @"money" : @"2000",
                       @"count":@"1",
                       @"expirationDate":@"2016-4-2",
                       @"canUse":@YES
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
    //tableView 去分界线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.tableFooterView =[[UIView alloc]init];
    self.tableView.backgroundColor = shrbTableViewColor;
    
    [self.tableView reloadDataAnimateWithWave:RightToLeftWaveAnimation];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return section == 0?0:4;
//}

//- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    CGFloat height ;
//    height = section == 0?0:4;
//    
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, height)] ;
//    [headerView setBackgroundColor:shrbSectionColor];
//    
//    return headerView;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return section == 0?[self.receiveDataArray count]:[self.dataArray count];
   // return [self.dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return 68;
    return 135;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        static NSString *SimpleTableIdentifier = @"ReceiveCouponsDetailTableViewCellIdentifier";
        CouponsDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor = shrbLightCell;
        if (cell == nil) {
            cell = [[CouponsDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:SimpleTableIdentifier];
        }
        
        cell.model = self.receiveDataArray[indexPath.row];
        
        return cell;
    }
    else {
        static NSString *SimpleTableIdentifier = @"CouponsDetailTableViewCellIdentifier";
        CouponsDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor = shrbLightCell;
        if (cell == nil) {
            cell = [[CouponsDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:SimpleTableIdentifier];
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
