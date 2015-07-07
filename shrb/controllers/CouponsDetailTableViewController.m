//
//  CouponsDetailTableViewController.m
//  shrb
//  电子券详情
//  Created by PayBay on 15/6/8.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "CouponsDetailTableViewController.h"
#import "CouponsDetailTableViewCell.h"
#import "CouponsModel.h"
#import "StoreViewController.h"
#import "UITableView+Wave.h"
#import "Const.h"
#import "UserCouponsViewController.h"

@interface CouponsDetailTableViewController ()

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation CouponsDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initTableView];
    
}

- (void)initData
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:
                             @{
                               @"couponsImage" : @"辛巴克",
                               @"money" : @"1000",
                               @"count":@"4",
                               @"expirationDate":@"2016.3.2"
                               },
                             @{
                               @"couponsImage" : @"官方头像",
                               @"money" : @"2000",
                               @"count":@"1",
                               @"expirationDate":@"2016.4.2"
                               },
                             @{
                               @"couponsImage" : @"吉野家",
                               @"money" : @"3000",
                               @"count":@"3",
                               @"expirationDate":@"2016.2.2"
                               },
                             @{
                               @"couponsImage" : @"冰雪皇后",
                               @"money" : @"4000",
                               @"count":@"10",
                               @"expirationDate":@"2016.1.2"
                               },
                             @{
                               @"couponsImage" : @"雀巢",
                               @"money" : @"200",
                               @"count":@"2",
                               @"expirationDate":@"2015.12.2"
                               },
                             @{
                               @"couponsImage" : @"官方头像",
                               @"money" : @"2000",
                               @"count":@"1",
                               @"expirationDate":@"2016.4.2"
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
    self.tableView.backgroundColor = shrbTableViewColor;
    
    [self.tableView reloadDataAnimateWithWave:RightToLeftWaveAnimation];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.dataArray count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *SimpleTableIdentifier = @"CouponsDetailTableViewCellIdentifier";
    CouponsDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (cell == nil) {
        cell = [[CouponsDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:SimpleTableIdentifier];
    }
   
    cell.model = self.dataArray[indexPath.row];
    cell.userCouponsBtn.tag = indexPath.row;
    return cell;
}


#pragma  mark - 转存电子券
- (IBAction)userCouponsBtnPressed:(UIButton *)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Card" bundle:nil];
    UserCouponsViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"UserCouponsView"];
    [viewController setModalPresentationStyle:UIModalPresentationFullScreen];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
