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
#import "CardModel.h"
#import "ExpenseTableViewCell.h"
#import "UITableView+Wave.h"
#import "SVProgressShow.h"
#import "SVPullToRefresh.h"

@interface CardDetailViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *expenseArray;


@end

@implementation CardDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:
                             @{
                               @"memberCardImage" : @"雀巢",
                               @"money" : @"1000",
                               @"cardNumber":@"455133487465566",
                               @"integral":@"45",
                               },
                             nil];
    
    self.dataArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary * dict in array) {
        CardModel * model = [[CardModel alloc] init];
        [model setValuesForKeysWithDictionary:dict];
        [self.dataArray addObject:model];
    }
    
    NSMutableArray *expenseArray = [[NSMutableArray alloc] initWithObjects:
                                    @{
                                      @"expenseNum" : @"1",
                                      @"orderNum" : @"4523214655654498",
                                      @"expensePrice":@"89",
                                      },
                                    @{
                                      @"expenseNum" : @"1",
                                      @"orderNum" : @"4523214655654498",
                                      @"expensePrice":@"89",
                                      },
                                    @{
                                      @"expenseNum" : @"1",
                                      @"orderNum" : @"4523214655654498",
                                      @"expensePrice":@"89",
                                      },
                                    @{
                                      @"expenseNum" : @"1",
                                      @"orderNum" : @"4523214655654498",
                                      @"expensePrice":@"89",
                                      },
                             nil];
    
    self.expenseArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary * dict in expenseArray) {
        CardModel * model = [[CardModel alloc] init];
        [model setValuesForKeysWithDictionary:dict];
        [self.expenseArray addObject:model];
    }


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
        NSDictionary *dic = @{@"expenseNum" : @"1",
                              @"orderNum" : @"4523214655654498",
                              @"expensePrice":@"89",};
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


- (void)insertRowAtBottom {
    __weak CardDetailViewController *weakSelf = self;
    
    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [weakSelf.tableView beginUpdates];
        NSDictionary *dic = @{@"expenseNum" : @"1",
                              @"orderNum" : @"4523214655654498",
                              @"expensePrice":@"89",};
        CardModel * model = [[CardModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        [weakSelf.expenseArray addObject:model];

        [weakSelf.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:weakSelf.dataArray.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
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
    return [self.dataArray count]+[self.expenseArray count];
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
        
        cell.model = self.dataArray[indexPath.row];
    
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

        cell.model = self.expenseArray[indexPath.row-1];
        return cell;
    }    
    
}

@end
