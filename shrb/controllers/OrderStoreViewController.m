//
//  OrderStoreViewController.m
//  shrb
//
//  Created by PayBay on 15/8/18.
//  Copyright © 2015年 PayBay. All rights reserved.
//

#import "OrderStoreViewController.h"
#import "Const.h"
#import "NewStoreTableViewCell.h"
#import "TradeModel.h"

@interface OrderStoreViewController ()


@property (nonatomic, retain)UITableView *tableView;

@property (nonatomic,strong) NSMutableArray * modelArray;
@property (nonatomic, strong) NSMutableArray *plistArr;

@end

@implementation OrderStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [[NSUserDefaults standardUserDefaults] stringForKey:@"storeName"];
    
    [self initData];
    [self initTableView];
    
}

- (void)initData
{
    NSString *storeFile = [[NSUserDefaults standardUserDefaults] stringForKey:@"storePlistName"];
    
    self.plistArr =[[NSMutableArray alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:storeFile ofType:@"plist"]];
    
    self.modelArray = [[NSMutableArray alloc] init];
}


- (void)initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20+44, screenWidth, screenHeight) style:UITableViewStylePlain];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    
    
    
    //去除tableview顶部留白
    self.automaticallyAdjustsScrollViewInsets = false;
    
    //删除底部多余横线
    self.tableView.tableFooterView =[[UIView alloc]init];
    
    //self.selectTypeTableView.tableFooterView = [[UIView alloc] init];
    //动画
    //[self.tableView reloadDataAnimateWithWave:RightToLeftWaveAnimation];
}

#pragma mark - tableView dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  100;
}

#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.plistArr count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.plistArr objectAtIndex:section][@"type"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 30;
    
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat height ;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, height)] ;
    [headerView setBackgroundColor:shrbSectionColor];
    
    height = 30;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, (height-18)*0.5, tableView.bounds.size.width - 10, 18)];
    label.textColor = shrbText;
    
    label.backgroundColor = [UIColor clearColor];
    [headerView addSubview:label];
    label.text = [self.plistArr objectAtIndex:section][@"type"];
    return  headerView;
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [[self.plistArr objectAtIndex:section][@"info"] count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimpleTableIdentifier = @"newStoreTableViewCell";
    
    UINib *nib = [UINib nibWithNibName:@"NewStoreTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:SimpleTableIdentifier];
    
    NewStoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    if (cell == nil) {
        cell = [[NewStoreTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.modelArray removeAllObjects];
    for (NSDictionary * dict in [self.plistArr objectAtIndex:indexPath.section][@"info"]) {
        TradeModel * model = [[TradeModel alloc] init];
        [model setValuesForKeysWithDictionary:dict];
        [self.modelArray addObject:model];
    }
    
    cell.model = self.modelArray[indexPath.row];
    
    return cell;
}
@end
