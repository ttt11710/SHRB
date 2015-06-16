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
#import "SVPullToRefresh.h"
#import "Const.h"
#import "SVProgressShow.h"

@interface CardTableViewController ()
@property (nonatomic, strong) NSMutableArray *data;

@end

@implementation CardTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //tableView 去分界线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
 //   self.automaticallyAdjustsScrollViewInsets = false;
    
    self.data = [[NSMutableArray alloc] initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6", nil];
    [self.tableView reloadDataAnimateWithWave:RightToLeftWaveAnimation];
    
    __weak CardTableViewController *weakSelf = self;
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
    __weak CardTableViewController *weakSelf = self;
    
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
    __weak CardTableViewController *weakSelf = self;
    
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
    return 160;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.data count];
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
    cell.integralLabel.text =[NSString stringWithFormat:@"积分：%@",[self.data objectAtIndex:indexPath.row]];
   
    return cell;
}

@end
