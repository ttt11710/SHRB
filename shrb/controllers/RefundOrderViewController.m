//
//  RefundOrderViewController.m
//  shrb
//
//  Created by PayBay on 15/8/21.
//  Copyright © 2015年 PayBay. All rights reserved.
//

#import "RefundOrderViewController.h"
#import "Const.h"
#import "OrderListModel.h"
#import "OrderTableViewCell.h"

@interface RefundOrderViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation RefundOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initTableView];
}

- (void)initData
{
    self.data = [[NSMutableArray alloc] initWithObjects:
                 @{@"storeLogoImageView":@"辛巴克.jpg",
                   @"storeNameLabel":@"辛巴克",
                   @"stateLabel":@"退款成功",
                   @"orderImageView":@"辛巴克.jpg",
                   @"moneyLabel":@"105",
                   @"refundmoney":@"105",
                   @"date":@"18:30 2015/06/01",
                   @"orderNum":@"201506010001",
                   @"address":@"上海市徐汇区龙吴路1333号华滨家园23#1202室12345343243243214321432672222222222334563456734567"},
                 @{@"storeLogoImageView":@"冰雪皇后.jpg",
                   @"storeNameLabel":@"冰雪皇后",
                   @"stateLabel":@"退款成功",
                   @"orderImageView":@"冰雪皇后.jpg",
                   @"moneyLabel":@"2300",
                   @"refundmoney":@"105",
                   @"date":@"15:30 2015/06/13",
                   @"orderNum":@"201506010003",
                   @"address":@"徐汇区"},
                 @{@"storeLogoImageView":@"雀巢.jpg",
                   @"storeNameLabel":@"雀巢",
                   @"stateLabel":@"退款成功",
                   @"orderImageView":@"雀巢.jpg",
                   @"moneyLabel":@"400",
                   @"refundmoney":@"105",
                   @"date":@"12:30 2015/06/04",
                   @"orderNum":@"201506010004",
                   @"address":@"徐汇区"},
                 @{@"storeLogoImageView":@"吉野家.jpg",
                   @"storeNameLabel":@"吉野家",
                   @"stateLabel":@"退款成功",
                   @"orderImageView":@"吉野家.jpg",
                   @"moneyLabel":@"350",
                   @"refundmoney":@"105",
                   @"date":@"18:30 2015/06/23",
                   @"orderNum":@"201506010006",
                   @"address":@"徐汇区"},
                 @{@"storeLogoImageView":@"雀巢.jpg",
                   @"storeNameLabel":@"雀巢",
                   @"stateLabel":@"退款成功",
                   @"orderImageView":@"雀巢.jpg",
                   @"moneyLabel":@"33440",
                   @"refundmoney":@"105",
                   @"date":@"18:30 2015/06/12",
                   @"orderNum":@"201506010011",
                   @"address":@"徐汇区"},
                 @{@"storeLogoImageView":@"吉野家.jpg",
                   @"storeNameLabel":@"吉野家",
                   @"stateLabel":@"退款成功",
                   @"orderImageView":@"吉野家.jpg",
                   @"moneyLabel":@"350",
                   @"refundmoney":@"105",
                   @"date":@"18:30 2015/06/23",
                   @"orderNum":@"201506010006",
                   @"address":@"徐汇区"},
                 nil];
    
    self.dataArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary * dict in self.data) {
        OrderListModel * model = [[OrderListModel alloc] init];
        [model setValuesForKeysWithDictionary:dict];
        [self.dataArray addObject:model];
    }
    
}

- (void)initTableView
{
    self.tableView.backgroundColor = shrbTableViewColor;
    //tableView 去分界线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //删除底部多余横线
    self.tableView.tableFooterView =[[UIView alloc]init];
}

#pragma mark - tableView dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 190+8;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimpleTableIdentifier = @"OrderTableViewCellIdentifier";
    OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor = shrbTableViewColor;
    if (cell == nil) {
        cell = [[OrderTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
    }
    //cell 选中方式
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArray[indexPath.row];
    
    return cell;
}

@end
