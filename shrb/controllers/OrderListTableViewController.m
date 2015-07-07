//
//  OrderListTableViewController.m
//  shrb
//
//  Created by PayBay on 15/6/16.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "OrderListTableViewController.h"
#import "OrderListTableViewCell.h"
#import "Const.h"

@interface OrderListTableViewController ()

@property (nonatomic, strong) NSMutableArray *data;

@end

@implementation OrderListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self initData];
    [self initTableView];
    
}

- (void)initData
{
    self.data = [[NSMutableArray alloc] initWithObjects:
                 @{@"orderImageView":@"辛巴克.jpg",
                   @"money":@"金额：105元",
                   @"date":@"时间：18:30 2015/06/01",
                   @"orderNum":@"订单号：201506010001",
                   @"address":@"地区：上海市徐汇区龙吴路1333号华滨家园23#1202室12345343243243214321432672222222222334563456734567"},
                 @{@"orderImageView":@"冰雪皇后.jpg",
                   @"money":@"金额：2300元",
                   @"date":@"时间：15:30 2015/06/13",
                   @"orderNum":@"订单号：201506010003",
                   @"address":@"地区：徐汇区"},
                 @{@"orderImageView":@"雀巢.jpg",
                   @"money":@"金额：400元",
                   @"date":@"时间：12:30 2015/06/04",
                   @"orderNum":@"订单号：201506010004",
                   @"address":@"地区：徐汇区"},
                 @{@"orderImageView":@"吉野家.jpg",
                   @"money":@"金额：350元",
                   @"date":@"时间：18:30 2015/06/23",
                   @"orderNum":@"订单号：201506010006",
                   @"address":@"地区：徐汇区"},
                 @{@"orderImageView":@"雀巢.jpg",
                   @"money":@"金额：33440元",
                   @"date":@"时间：18:30 2015/06/12",
                   @"orderNum":@"订单号：201506010011",
                   @"address":@"地区：徐汇区"},
                 @{@"orderImageView":@"吉野家.jpg",
                   @"money":@"金额：350元",
                   @"date":@"时间：18:30 2015/06/23",
                   @"orderNum":@"订单号：201506010006",
                   @"address":@"地区：徐汇区"},
                 nil];
}

- (void)initTableView
{
    self.tableView.backgroundColor = shrbTableViewColor;
}

#pragma mark - tableView dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenWidth - 70, 0)];
    UIFont* theFont = [UIFont systemFontOfSize:15.0];
    label.numberOfLines = 0;
    [label setFont:theFont];
    [label setText:[NSString stringWithFormat:@"%@\n%@\n%@\n%@\n",self.data[ indexPath.row][@"money"],self.data[indexPath.row][@"date"],self.data[indexPath.row][@"orderNum"],self.data[indexPath.row][@"address"]]];
    
    [label sizeToFit];// 显示文本需要的长度和宽度
    
    return label.frame.size.height+20;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimpleTableIdentifier = @"OrderListTableViewCellIdentifier";
    OrderListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (cell == nil) {
        cell = [[OrderListTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
    }
    //cell 选中方式
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
  //  cell.storeLogoImageView.image = [UIImage imageNamed:self.data[indexPath.row][@"orderImageView"]];
    cell.orderListInfoLabel.text = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n",self.data[ indexPath.row][@"money"],self.data[indexPath.row][@"date"],self.data[indexPath.row][@"orderNum"],self.data[indexPath.row][@"address"]];
    return cell;
}
@end
