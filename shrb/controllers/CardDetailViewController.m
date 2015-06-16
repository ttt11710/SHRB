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
#import "SVProgressShow.h"
#import "SVPullToRefresh.h"

@interface CardDetailViewController ()
@property (nonatomic, strong) NSMutableArray *data;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CardDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.data = [[NSMutableArray alloc] initWithObjects:@"1",@"2",@"3",@"4", nil];
    [self.tableView reloadDataAnimateWithWave:RightToLeftWaveAnimation];
    self.automaticallyAdjustsScrollViewInsets = false;
    
    __weak CardDetailViewController *weakSelf = self;
    // setup pull-to-refresh
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf insertRowAtTop];
    }];
    
    // setup infinite scrolling
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf insertRowAtBottom];
    }];
}

- (void)insertRowAtTop {
    __weak CardDetailViewController *weakSelf = self;
    
    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [weakSelf.tableView beginUpdates];
        [weakSelf.data insertObject:[NSString stringWithFormat:@"%d",arc4random()%100] atIndex:0];
        [weakSelf.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
        [weakSelf.tableView endUpdates];
        
        [weakSelf.tableView.pullToRefreshView stopAnimating];
        [weakSelf.tableView reloadData];
        [SVProgressShow showSuccessWithStatus:@"刷新成功！"];
    });
}


- (void)insertRowAtBottom {
    __weak CardDetailViewController *weakSelf = self;
    
    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [weakSelf.tableView beginUpdates];
        [weakSelf.data addObject:[NSString stringWithFormat:@"%d",arc4random()%100]];
        [weakSelf.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:weakSelf.data.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
        [weakSelf.tableView endUpdates];
        
        [weakSelf.tableView.infiniteScrollingView stopAnimating];
        [SVProgressShow showSuccessWithStatus:@"加载成功！"];
    });
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
        cell.expenseTextView.text =[NSString stringWithFormat:@"消费记录：%@\n\n订单号：434544454676756765\n型号：M\n价格：70元\n",[self.data objectAtIndex:indexPath.row-1]] ;

        return cell;
    }    
    
}

@end
