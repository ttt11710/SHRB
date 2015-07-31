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
#import <BFPaperButton/BFPaperButton.h>

@interface CompletePayViewController () {
    BOOL _isMember;
}
@property (weak, nonatomic) IBOutlet UILabel *completePayLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet BFPaperButton *finishBtn;

@property (nonatomic,strong) NSMutableArray * dataArray;

@end

@implementation CompletePayViewController

@synthesize isMemberPay;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBtn];
    [self initData];
    [self initTableView];
    
    [self.completePayLabel swing:nil];
}

- (void)initBtn
{
    [self.finishBtn setBackgroundColor:shrbPink];
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

- (void)initTableView
{
    //删除多余线
    self.tableView.tableFooterView =[[UIView alloc]init];
    self.tableView.backgroundColor = shrbTableViewColor;
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
    
    NSString *QRPay =  [[NSUserDefaults standardUserDefaults] stringForKey:@"QRPay"];
    
    //等待一定时间后执行
    [SVProgressShow showSuccessWithStatus:@"等待我们为您服务吧！"];
    double delayInSeconds = 1.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [SVProgressShow dismiss];
        //超市商品页面直接扫码
        if ([QRPay isEqualToString:@"SupermarketNewStore"]) {
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-5] animated:YES];
        }
        else {
            //跳转到热点页面
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
        }
    });
}
@end
