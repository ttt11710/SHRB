//
//  StoreViewController.m
//  shrb
//  商店首页
//  Created by PayBay on 15/5/20.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "NewStoreViewController.h"
#import "StoreTableViewCell.h"
#import "TradeModel.h"
#import "OrdersViewController.h"
#import "ProductDescriptionView.h"
#import "UITableView+Wave.h"
#import "Const.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "SVProgressShow.h"
#import "ProductTableViewController.h"
#import "ProductIsMemberTableViewController.h"

static NewStoreViewController *g_StoreViewController = nil;
@interface NewStoreViewController ()
{
    NSMutableDictionary *_currentNumDic;
    CGRect _rect;
    CGFloat lastContentOffset;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) UIBezierPath *path;
@property (weak, nonatomic) IBOutlet UIButton *topBtn;
@property (nonatomic,strong) NSMutableArray * dataArray;

@end

@implementation NewStoreViewController{
    CALayer     *layer;
}

+ (NewStoreViewController *)shareStoreViewController
{
    return g_StoreViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    g_StoreViewController = self;
    
    [self initData];
    [self initTableView];
}

- (void)initData
{
    
    _currentNumDic = [[NSMutableDictionary alloc]init];
    
    //假数据
    NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:
                             @{
                               @"tradeImage" : @"提拉米苏",
                               @"tradeName" : @"提拉米苏",
                               @"memberPrice":@"34",
                               @"originalPrice":@"45",
                               },
                             @{
                               @"tradeImage" : @"蜂蜜提子可颂",
                               @"tradeName" : @"蜂蜜提子可颂",
                               @"memberPrice":@"45",
                               @"originalPrice":@"55",                               },
                             @{
                               @"tradeImage" : @"芝士可颂",
                               @"tradeName" : @"芝士可颂",
                               @"memberPrice":@"22",
                               @"originalPrice":@"33",
                               },
                             @{
                               @"tradeImage" : @"牛奶",
                               @"tradeName" : @"牛奶",
                               @"memberPrice":@"44",
                               @"originalPrice":@"55",
                               },
                             @{
                               @"tradeImage" : @"抹茶拿铁",
                               @"tradeName" : @"抹茶拿铁",
                               @"memberPrice":@"25",
                               @"originalPrice":@"34",
                               },
                             @{
                               @"tradeImage" : @"英式红茶",
                               @"tradeName" : @"英式红茶",
                               @"memberPrice":@"11",
                               @"originalPrice":@"45",
                               },
                             @{
                               @"tradeImage" : @"冰拿铁",
                               @"tradeName" : @"冰拿铁",
                               @"memberPrice":@"23",
                               @"originalPrice":@"55",
                               },
                             @{
                               @"tradeImage" : @"卡布奇诺",
                               @"tradeName" : @"卡布奇诺",
                               @"memberPrice":@"23",
                               @"originalPrice":@"56",
                               },
                             @{
                               @"tradeImage" : @"焦糖玛奇朵",
                               @"tradeName" : @"焦糖玛奇朵",
                               @"memberPrice":@"12",
                               @"originalPrice":@"67",
                               },
                             @{
                               @"tradeImage" : @"美式咖啡",
                               @"tradeName" : @"美式咖啡",
                               @"memberPrice":@"12",
                               @"originalPrice":@"67",
                               },
                             @{
                               @"tradeImage" : @"拿铁",
                               @"tradeName" : @"拿铁",
                               @"memberPrice":@"23",
                               @"originalPrice":@"56",
                               },
                             @{
                               @"tradeImage" : @"浓缩咖啡",
                               @"tradeName" : @"浓缩咖啡",
                               @"memberPrice":@"23",
                               @"originalPrice":@"67",
                               },
                             @{
                               @"tradeImage" : @"摩卡",
                               @"tradeName" : @"摩卡",
                               @"memberPrice":@"56",
                               @"originalPrice":@"77",
                               },
                             @{
                               @"tradeImage" : @"香草拿铁",
                               @"tradeName" : @"香草拿铁",
                               @"memberPrice":@"34",
                               @"originalPrice":@"67",
                               },
                             nil ];
    
    self.dataArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary * dict in array) {
        TradeModel * model = [[TradeModel alloc] init];
        [model setValuesForKeysWithDictionary:dict];
        [self.dataArray addObject:model];
    }
    
}

- (void)initTableView
{
    //删除底部多余横线
    _tableView.tableFooterView =[[UIView alloc]init];
    //动画
    [self.tableView reloadDataAnimateWithWave:RightToLeftWaveAnimation];
}

#pragma mark - 更新tableView
- (void)UpdateTableView
{
    [self.dataArray addObject:@{
                                @"tradeImage" : @"冰拿铁",
                                @"tradeName" : @"冰拿铁",
                                @"memberPrice":@"23",
                                @"originalPrice":@"55",
                                }];
    [SVProgressShow showWithStatus:@"更新订单中..."];
    double delayInSeconds = 1.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [SVProgressShow dismiss];
        [self.tableView reloadData];
        [self.tableView scrollRectToVisible:CGRectMake(0, 0, screenWidth, screenHeight) animated:YES];
    });
}

#pragma mark - tableView dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68;
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimpleTableIdentifier = @"CouponsTableViewCellIdentifier";
    StoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (cell == nil) {
        cell = [[StoreTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
    }
    
    cell.model = self.dataArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    NewProductDescriptionViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"NewProductDescriptionView"];
//    viewController.currentIndex = indexPath.row;
    BOOL isMember = [[NSUserDefaults standardUserDefaults] boolForKey:@"isMember"];
    if (isMember) {
        ProductIsMemberTableViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"ProductIsMemberTableView"];
        viewController.currentIndex = indexPath.row;
        [viewController setModalPresentationStyle:UIModalPresentationFullScreen];
        
        
            [self.navigationController pushViewController:viewController animated:YES];
      
    }
    else {
        ProductTableViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"ProductTableView"];
        viewController.currentIndex = indexPath.row;
        [viewController setModalPresentationStyle:UIModalPresentationFullScreen];
    
            [self.navigationController pushViewController:viewController animated:YES];
    }
    
}

#pragma mark - tableView滚动调用
-(void)scrollViewWillBeginDragging:(UIScrollView*)scrollView {
    
    lastContentOffset = scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y < lastContentOffset )
    {
        //向上
        _topBtn.hidden = NO;
        
    } else if (scrollView. contentOffset.y >lastContentOffset){
        //向下
        CATransition *animation = [CATransition animation];
        animation.type = kCATransitionMoveIn;
        animation.duration = 1.0f;
        [_topBtn.layer addAnimation:animation forKey:nil];
        _topBtn.hidden = YES;
    }
    if (scrollView.contentOffset.y == 0) {
        _topBtn.hidden = YES;
    }
}

#pragma mark - tableView滚回最前面
- (IBAction)tabViewSetContentToTop:(id)sender {
    
    //到顶部
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
}

#pragma  mark - storyboard传值
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    OrdersViewController *shoppingCartViewController = segue.destinationViewController;
    shoppingCartViewController.isMember = [[NSUserDefaults standardUserDefaults] boolForKey:@"isMember"];
}

@end
