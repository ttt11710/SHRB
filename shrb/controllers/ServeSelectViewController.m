//
//  ServeSelectViewController.m
//  shrb
//
//  Created by PayBay on 15/8/21.
//  Copyright © 2015年 PayBay. All rights reserved.
//

#import "ServeSelectViewController.h"
#import "Const.h"
#import "AppleRefundViewController.h"

@interface ServeSelectViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ServeSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    self.title = @"服务选择";
    
    [self initTableView];
}

- (void)initTableView
{
    //删除多余线
    self.tableView.tableFooterView =[[UIView alloc]init];
    self.tableView.backgroundColor = shrbTableViewColor;
}

#pragma mark - tableView dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.textColor = shrbText;
    cell.detailTextLabel.textColor = shrbLightText;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.text = indexPath.row == 0? @"退货退款" : @"仅退款";
    cell.detailTextLabel.text = indexPath.row == 0? @"已收到货，需要退还已收到的货物" : @"未收到货，或与商家协商同意前提下申请";
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1)  {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
        AppleRefundViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"AppleRefundView"];
        [viewController setModalPresentationStyle:UIModalPresentationFullScreen];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}


@end
