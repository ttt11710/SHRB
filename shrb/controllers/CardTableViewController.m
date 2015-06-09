//
//  CardTableViewController.m
//  shrb
//  会员卡
//  Created by PayBay on 15/5/20.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "CardTableViewController.h"
#import "CardTableViewCell.h"
#import "UITableView+Wave.h"

@interface CardTableViewController ()
{
    NSMutableArray *_data;
}

@end

@implementation CardTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //tableView 去分界线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _data = [[NSMutableArray alloc] initWithObjects:@"1",@"2",@"3",@"4", nil];
    [self.tableView reloadDataAnimateWithWave:RightToLeftWaveAnimation];
}

#pragma mark - tableView dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimpleTableIdentifier = @"CardTableViewCellIdentifier";
    CardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    if (cell == nil) {
        cell = [[CardTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
    }
    //cell 选中方式
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.memberCardImageView.image = [UIImage imageNamed:@"官方头像"];
    cell.moneyLabel.text = @"金额：1000.00元";
    cell.cardNumberLabel.text = @"卡号：54542354235321";
    cell.integralLabel.text = @"积分：2000分";
   
    return cell;
}

@end
