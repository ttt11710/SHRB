//
//  ShoppingCartViewController.m
//  shrb
//  购物车
//  Created by PayBay on 15/5/20.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "OrdersViewController.h"
#import "OrdersTableViewCell.h"
#import "PayViewController.h"
#import "ButtonTableViewCell.h"
#import "UITableView+Wave.h"

@interface OrdersViewController ()
{
    NSMutableArray *_data;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *showOtherPayBtn;

@end

@implementation OrdersViewController

@synthesize isMember;

- (void)viewDidLoad {
    [super viewDidLoad];
    _data = [[NSMutableArray alloc] initWithObjects:@"星巴克",@"小绵羊",@"可爱多",@"水果工厂", nil];
    [self.tableView reloadDataAnimateWithWave:RightToLeftWaveAnimation];
}

- (void)viewWillAppear:(BOOL)animated
{
    isMember = [[NSUserDefaults standardUserDefaults] boolForKey:@"isMember"];
    [self.tableView reloadData];
}
#pragma mark - tableView dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [_data count]+3) {
        return 50;
    }
    return indexPath.row <= [_data count]?80:150;
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isMember) {
        _showOtherPayBtn.hidden = YES;
        return [_data count]+2;
    }
    return [_data count]+4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row <= [_data count]+2) {
        static NSString *SimpleTableIdentifier = @"ShoppingCartTableViewCellIdentifier";
        OrdersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (cell == nil) {
            cell = [[OrdersTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
        }
        
        if (indexPath.row <= [_data count]) {
            if (indexPath.row < [_data count]) {
                cell.tradeNameLabel.text = [_data objectAtIndex:indexPath.row];
                cell.couponsImageView.image = [UIImage imageNamed:@"官方头像"];
                cell.priceLabel.text = @"会员价：30元  原价：40元";
            }
            else  {
                cell.tradeNameLabel.text = @"添加";
                cell.couponsImageView.image = [UIImage imageNamed:@"上传相片"];
                cell.priceLabel.text = @"";
            }
            cell.couponsImageView.hidden = NO;
            cell.tradeNameLabel.hidden = NO;
            cell.priceLabel.hidden = NO;
            cell.settlementTextView.hidden = YES;
            cell.checkImageView.hidden = YES;
            cell.couponLabel.hidden = YES;
            cell.ruleTextView.hidden = YES;
        }
        else
        {
            cell.couponsImageView.hidden = YES;
            cell.tradeNameLabel.hidden = YES;
            cell.priceLabel.hidden = YES;
            if (indexPath.row == [_data count]+1)
            {
                cell.settlementTextView.hidden = NO;
                cell.checkImageView.hidden = NO;
                cell.couponLabel.hidden = NO;
                cell.ruleTextView.hidden = YES;
                cell.settlementTextView.text = @"总价：500RMB\n会员价：350RMB";
                cell.couponLabel.text = @"100RMB电子券";
            }
            else
            {
                cell.settlementTextView.hidden = YES;
                cell.checkImageView.hidden = YES;
                cell.couponLabel.hidden = YES;
                cell.ruleTextView.hidden = NO;
                cell.ruleTextView.textAlignment = NSTextAlignmentLeft;
                cell.ruleTextView.text = @"会员好处：范德萨发几款的结果看见啊\n\n会员规则:芭芭拉回复将恢复快热好可恶";
            }
            
        }
        return cell;
    }
    else
    {
        static NSString *SimpleTableIdentifier = @"ButtonTableViewCellIdentifier";
        ButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (cell == nil) {
            cell = [[ButtonTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
        }
        
        [cell.buttonModel setTitle:@"我要变会员" forState:UIControlStateNormal];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [_data count]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma  mark - storyboard传值
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    PayViewController *payViewController = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"memberPayidentifier"]) {
        payViewController.isMemberPay = YES;
    }
    else if([segue.identifier isEqualToString:@"othersPayidentifier"])
    {
        payViewController.isMemberPay = NO;
    }
}
@end
