//
//  TradingRecordTableViewController.m
//  shrb
//
//  Created by PayBay on 15/6/29.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "TradingRecordTableViewController.h"
#import "CardModel.h"
#import "ExpenseTableViewCell.h"
#import "SVPullToRefresh.h"
#import "UITableView+Wave.h"
#import "SVProgressShow.h"

@interface TradingRecordTableViewController ()

@property (nonatomic, strong) NSMutableArray *expenseArray;


@end

@implementation TradingRecordTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initTableView];
    
}

- (void)initData
{
    
    NSMutableArray *expenseArray = [[NSMutableArray alloc] initWithObjects:
                                    @{
                                      @"date" : @"15:20  2016.3.1",
                                      @"money" : @"1",
                                      @"orderNum" : @"4523214655654498",
                                      @"address":@"上海市",
                                      },
                                    @{
                                      @"date" : @"15:20  2016.3.1",
                                      @"money" : @"1",
                                      @"orderNum" : @"4523214655654498",
                                      @"address":@"浙江省",
                                      },
                                    @{
                                      @"date" : @"15:20  2016.3.3",
                                      @"money" : @"1",
                                      @"orderNum" : @"4523214655654498",
                                      @"address":@"江苏市",
                                      },
                                    @{
                                      @"date" : @"15:20  2016.3.4",
                                      @"money" : @"1",
                                      @"orderNum" : @"4523214655654498",
                                      @"address":@"云南",
                                      },
                                    nil];
    
    self.expenseArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary * dict in expenseArray) {
        CardModel * model = [[CardModel alloc] init];
        [model setValuesForKeysWithDictionary:dict];
        [self.expenseArray addObject:model];
    }
}

- (void)initTableView
{
    [self.tableView reloadDataAnimateWithWave:RightToLeftWaveAnimation];
    self.automaticallyAdjustsScrollViewInsets = false;
    
    __weak TradingRecordTableViewController *weakSelf = self;
    //下拉加载
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf insertRowAtTop];
    }];
    
    //上拉刷新
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf insertRowAtBottom];
    }];
}

#pragma mark - top插入数据
- (void)insertRowAtTop {
    __weak TradingRecordTableViewController *weakSelf = self;
    
    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [weakSelf.tableView beginUpdates];
        NSDictionary *dic = @{ @"date" : @"15:20  2016.4.1",
                               @"money" : @"20",
                               @"orderNum" : @"4523214655654498",
                               @"address":@"徐汇区",
                               };
        CardModel * model = [[CardModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        [weakSelf.expenseArray insertObject:model atIndex:0];
        
        [weakSelf.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
        [weakSelf.tableView endUpdates];
        
        [weakSelf.tableView.pullToRefreshView stopAnimating];
        [weakSelf.tableView reloadData];
        [SVProgressShow showSuccessWithStatus:@"刷新成功！"];
    });
}

#pragma mark - bottom插入数据
- (void)insertRowAtBottom {
    __weak TradingRecordTableViewController *weakSelf = self;
    
    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [weakSelf.tableView beginUpdates];
        NSDictionary *dic = @{ @"date" : @"15:20  2015.3.1",
                               @"money" : @"100",
                               @"orderNum" : @"4523214655654498",
                               @"address":@"上海浦东",
                               };
        CardModel * model = [[CardModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        [weakSelf.expenseArray addObject:model];
        
        [weakSelf.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:weakSelf.expenseArray.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
        [weakSelf.tableView endUpdates];
        
        [weakSelf.tableView.infiniteScrollingView stopAnimating];
        [SVProgressShow showSuccessWithStatus:@"加载成功！"];
    });
}

#pragma mark - tableView dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  130;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.expenseArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *SimpleTableIdentifier = @"ExpenseTableViewIdentifier";
    ExpenseTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (cell == nil) {
        cell = [[ExpenseTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
    }
    
    cell.model = self.expenseArray[indexPath.row];
    return cell;
    
}
@end
