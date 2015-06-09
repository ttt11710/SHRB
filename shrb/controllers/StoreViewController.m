//
//  StoreViewController.m
//  shrb
//  商店首页
//  Created by PayBay on 15/5/20.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "StoreViewController.h"
#import "StoreTableViewCell.h"
#import "ButtonTableViewCell.h"
#import "OrdersViewController.h"
#import "ProductDescriptionView.h"
#import "UITableView+Wave.h"

@interface StoreViewController ()
{
    NSMutableArray *_data;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,retain)ProductDescriptionView *productDescriptionView;
@end

@implementation StoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    _data = [[NSMutableArray alloc] initWithObjects:@"单人套餐",@"双人套餐",@"三人套餐",@"四人套餐", nil];
    [self.tableView reloadDataAnimateWithWave:RightToLeftWaveAnimation];
}

#pragma mark - tableView dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row < [_data count]?80:46;
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_data count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [_data count]) {
        static NSString *SimpleTableIdentifier = @"CouponsTableViewCellIdentifier";
        StoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (cell == nil) {
            cell = [[StoreTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
        }
        cell.tradeNameLabel.text = [_data objectAtIndex:indexPath.row];
        cell.couponsImageView.image = [UIImage imageNamed:@"官方头像"];
        
        return cell;
    }
    else
    {
        static NSString *SimpleTableIdentifier = @"ButtonTableViewCellIdentifier";
        ButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (cell == nil) {
            cell = [[ButtonTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
        }
        
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_productDescriptionView==nil) {
        _productDescriptionView=[[ProductDescriptionView alloc]initWithFrame:[UIScreen mainScreen].bounds];
       [self.view addSubview:_productDescriptionView];
    }
    self.productDescriptionView.hidden=NO;

}

#pragma  mark - storyboard传值
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    OrdersViewController *shoppingCartViewController = segue.destinationViewController;
    shoppingCartViewController.isMember = [[NSUserDefaults standardUserDefaults] boolForKey:@"isMember"];
}

@end
