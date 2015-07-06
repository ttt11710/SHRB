//
//  CompletePayViewController.m
//  shrb
//  完成支付
//  Created by PayBay on 15/5/20.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "CompletePayViewController.h"
#import "LazyFadeInView.h"
#import "SVProgressShow.h"
#import <DCAnimationKit/UIView+DCAnimationKit.h>
#import "Const.h"
#import "LeftLabelTableViewCell.h"
#import "CompletePayOrdersTableViewCell.h"

@interface CompletePayViewController () {
    BOOL _isMember;
}
@property (weak, nonatomic) IBOutlet UILabel *completePayLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSMutableArray * dataArray;

@end

@implementation CompletePayViewController

@synthesize isMemberPay;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    [self initData];
    [self initTableView];
    
    [self.completePayLabel swing:nil];
}

- (void)initData
{
    
    _isMember = [[NSUserDefaults standardUserDefaults] boolForKey:@"isMember"];
    
    self.dataArray = [[NSMutableArray alloc] initWithObjects:
                      @{
                        @"tradeImage" : @"提拉米苏",
                        @"tradeName" : @"提拉米苏",
                        @"amount":@"10",
                        @"money":@"¥450",
                        },
                      @{
                        @"tradeImage" : @"蜂蜜提子可颂",
                        @"tradeName" : @"蜂蜜提子可颂",
                        @"amount":@"2",
                        @"money":@"¥60",
                        },
                      @{
                        @"tradeImage" : @"芝士可颂",
                        @"tradeName" : @"芝士可颂",
                        @"amount":@"1",
                        @"money":@"¥25",
                        },
                      nil];
}

#pragma mark - 初始化UI
- (void)initView
{
//    self.payInfoView.text = self.isMemberPay? @"信息确认\n型号：L款\n日期：2015年5月20日\n单号：89849382403284093\n\n本次消费：200RMB    本次积分35分\n会员余额：2650RMB   会员积分：35分\n\n已收到您的订单，请耐心等待，我们将为您服务":@"信息确认\n型号：L款\n日期：2015年5月20日\n单号：89849382403284093\n\n会员余额：2650RMB   会员积分：35分\n会员卡买单更划算，更优惠哦！\n\n已收到您的订单，请耐心等待，我们将为您服务";
//    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isMember"]) {
//        self.payInfoView.text = @"信息确认\n型号：L款\n日期：2015年5月20日\n单号：89849382403284093\n\n已收到您的订单，请耐心等待，我们将为您服务";
//    }

}

- (void)initTableView
{
    //删除多余线
    self.tableView.tableFooterView =[[UIView alloc]init];
    self.tableView.backgroundColor = HexRGB(0xF1EFEF);
}


#pragma mark - tableView dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isMember) {
        if (indexPath.row == [self.dataArray count]+1 ||indexPath.row == [self.dataArray count]+2) {
            return 60;
        }
    }
    else {
        if (indexPath.row == [self.dataArray count]+1) {
            return 60;
        }
    }
    return 44;
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isMember) {
        return [self.dataArray count]+4;
    }
    
    return [self.dataArray count]+3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *SimpleTableIdentifier = @"LeftLabelTableViewCellIdentifier";
        LeftLabelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (cell == nil) {
            cell = [[LeftLabelTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
        }
        
        cell.leftLabel.text = @"信息确认";
        
        return cell;
    }
    else if (indexPath.row <= [self.dataArray count]) {
       
        static NSString *SimpleTableIdentifier = @"CompletePayOrdersTableViewCellIdentifier";
        CompletePayOrdersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (cell == nil) {
            cell = [[CompletePayOrdersTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
        }
        cell.tradeNameLabel.text = self.dataArray[indexPath.row-1][@"tradeName"];
        cell.amountLabel.text = self.dataArray[indexPath.row-1][@"amount"];
        cell.moneyLabel.text = self.dataArray[indexPath.row-1][@"money"];
        return cell;
    }
    else if (indexPath.row == [self.dataArray count]+1) {
        static NSString *SimpleTableIdentifier = @"DateAndNumCellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
        }
        cell.textLabel.text = @"日期：2015年6月20日";
        cell.detailTextLabel.text = @"单号：20150620123689474588662";
        return cell;

    }
    else if (indexPath.row == [self.dataArray count]+2) {
        if (isMemberPay) {
                static NSString *SimpleTableIdentifier = @"DateAndNumCellIdentifier";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                if (cell == nil) {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
                }
                cell.textLabel.text = @"本次消费：350RMB   本次积分：35分";
                cell.detailTextLabel.text = @"会员余额：2650RMB   会员积分：35分";
                return cell;
        }
        else if (_isMember && !isMemberPay) {
            static NSString *SimpleTableIdentifier = @"DateAndNumCellIdentifier";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
            }
            cell.textLabel.text = @"会员余额：2650RMB   会员积分：35分";
            cell.detailTextLabel.text = @"会员卡买单更划算更优惠哦！";
            return cell;
        }

        else {
            static NSString *SimpleTableIdentifier = @"LeftLabelTableViewCellIdentifier";
            LeftLabelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            if (cell == nil) {
                cell = [[LeftLabelTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
            }
            
            cell.leftLabel.text = @"已收到115桌订单，请耐心等待我们为您服务。";
            
            return cell;
        }
    }
    else {
        static NSString *SimpleTableIdentifier = @"LeftLabelTableViewCellIdentifier";
        LeftLabelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (cell == nil) {
            cell = [[LeftLabelTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
        }
        
        cell.leftLabel.text = @"已收到115桌订单，请耐心等待我们为您服务。";
        
        return cell;
    }

}

#pragma  mark - 完成支付Btn
- (IBAction)finishBtnPressed:(id)sender {
    
    //等待一定时间后执行
    [SVProgressShow showSuccessWithStatus:@"到店领取宝贝吧！"];
    double delayInSeconds = 1.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [SVProgressShow dismiss];
        ////跳转到指定页面
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
    });
}
@end
