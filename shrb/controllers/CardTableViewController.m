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
#import "CardModel.h"

@interface CardTableViewController ()
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation CardTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initTableView];
}

- (void)initData
{
    //假数据
    NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:
                             @{
                               @"memberCardImage" : @"雀巢",
                               @"money" : @"1000",
                               @"cardNumber":@"455133487465566",
                               @"integral":@"45",
                               },
                             @{
                               @"memberCardImage" : @"辛巴克",
                               @"money" : @"200",
                               @"cardNumber":@"7845123165468",
                               @"integral":@"55",                               },
                             @{
                               @"memberCardImage" : @"吉野家",
                               @"money" : @"100",
                               @"cardNumber":@"998562144555456",
                               @"integral":@"33",
                               },
                             @{
                               @"memberCardImage" : @"冰雪皇后",
                               @"money" : @"150",
                               @"cardNumber":@"781123264645465654",
                               @"integral":@"55",
                               },
                             nil];
    
    self.dataArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary * dict in array) {
        CardModel * model = [[CardModel alloc] init];
        [model setValuesForKeysWithDictionary:dict];
        [self.dataArray addObject:model];
    }

}

- (void)initTableView
{
    //tableView 去分界线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //动画
    [self.tableView reloadDataAnimateWithWave:RightToLeftWaveAnimation];
    
    __weak CardTableViewController *weakSelf = self;
    //下拉刷新
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf insertRowAtTop];
    }];
    
    //上拉加载
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf insertRowAtBottom];
    }];
 
}

#pragma mark - top插入数据
- (void)insertRowAtTop {
    __weak CardTableViewController *weakSelf = self;
    
    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [weakSelf.tableView beginUpdates];
        
        NSDictionary *dic = @{@"memberCardImage" : @"雀巢",
                              @"money" : @"1000",
                              @"cardNumber":@"455133487465566",
                              @"integral":@"45"};
        CardModel * model = [[CardModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        [weakSelf.dataArray insertObject:model atIndex:0];
        
        [weakSelf.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
        [weakSelf.tableView endUpdates];
        
        [weakSelf.tableView.pullToRefreshView stopAnimating];
        [weakSelf.tableView reloadData];
        [SVProgressShow showSuccessWithStatus:@"刷新成功！"];
    });
}

#pragma mark - bottom插入数据
- (void)insertRowAtBottom {
    __weak CardTableViewController *weakSelf = self;
    
    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [weakSelf.tableView beginUpdates];
        NSDictionary *dic = @{@"memberCardImage" : @"雀巢",
                              @"money" : @"1000",
                              @"cardNumber":@"455133487465566",
                              @"integral":@"45"};
        CardModel * model = [[CardModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        [weakSelf.dataArray addObject:model];
        
        [weakSelf.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:weakSelf.dataArray.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
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
    return [self.dataArray count];
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
    cell.model = self.dataArray[indexPath.row];
    
    return cell;
}

@end
