//
//  OrderListTableViewController.m
//  shrb
//
//  Created by PayBay on 15/6/16.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "OrderListTableViewController.h"
#import "UITableView+Wave.h"
#import "OrderListTableViewCell.h"
#import "Const.h"

@interface OrderListTableViewController ()

@property (nonatomic, strong) NSMutableArray *data;

@end

@implementation OrderListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.data = [[NSMutableArray alloc] initWithObjects:@"1",@"2",@"3",@"4", nil];
    
    self.tableView.backgroundColor = HexRGB(0xF1EFEF);
    [self.tableView reloadDataAnimateWithWave:RightToLeftWaveAnimation];
}

#pragma mark - tableView dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  120;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_data count];
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
    
    cell.storeLogoImageView.image = [UIImage imageNamed:@"官方头像"];
    cell.orderListInfoTextView.text = @"金额：100元\n时间：18:39   2015/06/15\n订单：2015061520159\n地址：徐家汇";
    return cell;
}
@end
