//
//  CardDetailViewController.m
//  shrb
//  会员卡详情
//  Created by PayBay on 15/5/21.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "CardDetailViewController.h"
#import "Const.h"
#import "CardTableViewCell.h"
#import "ExpenseTableViewCell.h"
#import "UITableView+Wave.h"

@interface CardDetailViewController ()

{
    NSMutableArray *_data;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CardDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _data = [[NSMutableArray alloc] initWithObjects:@"1",@"2",@"3",@"4", nil];
    [self.tableView reloadDataAnimateWithWave:RightToLeftWaveAnimation];
}

#pragma mark - tableView dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  indexPath.row == 0? 200:150;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        static NSString *SimpleTableIdentifier = @"CardTableViewCellIdentifier";
        CardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (cell == nil) {
            cell = [[CardTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
        }
        //cell 选中方式
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.memberCardImageView.image = [UIImage imageNamed:@"官方头像"];
        cell.moneyLabel.text = @"金额：1000.00元";
        cell.cardNumberLabel.text = @"卡号：5321";
        cell.integralLabel.text = @"积分：2000分";
        return cell;
    }
    else
    {
        static NSString *SimpleTableIdentifier = @"ExpenseTableViewIdentifier";
        ExpenseTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (cell == nil) {
            cell = [[ExpenseTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
        }
        cell.expenseTextView.text = @"消费记录：\n\n订单号：434544454676756765\n型号：M\n价格：70元\n";

        return cell;
    }    
    
}

@end
