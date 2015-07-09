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
    
    UIView *selectTypeTableViewBackView;
    UITableView *selectTypeTableView;
    BOOL showSelectTypeTableView;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) UIBezierPath *path;
@property (weak, nonatomic) IBOutlet UIButton *topBtn;
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic, strong) NSMutableDictionary *dataDic;

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
    
    
    [self initView];
    [self initData];
    [self initTableView];
}


- (void)initView
{
    UIBarButtonItem *selectType = [[UIBarButtonItem alloc] initWithTitle:@"分类" style:UIBarButtonItemStylePlain target:self action:@selector(selectType)];
    self.navigationItem.rightBarButtonItem = selectType;
    
    selectTypeTableViewBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 20+44, screenWidth, screenHeight-20-40)];
    selectTypeTableViewBackView.backgroundColor = [UIColor clearColor];
    selectTypeTableViewBackView.hidden = YES;
    
    selectTypeTableView = [[UITableView alloc] initWithFrame:CGRectMake(screenWidth, 20+44, screenWidth/2, screenHeight-20-44) style:UITableViewStylePlain];
    selectTypeTableView.delegate = self;
    selectTypeTableView.dataSource = self;
    
}

- (void)initData
{
    
    _currentNumDic = [[NSMutableDictionary alloc]init];
    
    
    //假数据
    NSMutableArray *dessertArray = [[NSMutableArray alloc] initWithObjects:
                             @{
                               @"tradeImage" : @"白头偕老双皮奶",
                               @"tradeName" : @"白头偕老双皮奶",
                               @"memberPrice":@"34",
                               @"originalPrice":@"45",
                               },
                             @{
                               @"tradeImage" : @"果果们醉了",
                               @"tradeName" : @"果果们醉了",
                               @"memberPrice":@"45",
                               @"originalPrice":@"55",                               },
                             @{
                               @"tradeImage" : @"红与黑",
                               @"tradeName" : @"红与黑",
                               @"memberPrice":@"22",
                               @"originalPrice":@"33",
                               },
                             @{
                               @"tradeImage" : @"戒不掉的杨枝甘露",
                               @"tradeName" : @"戒不掉的杨枝甘露",
                               @"memberPrice":@"44",
                               @"originalPrice":@"55",
                               },
                             @{
                               @"tradeImage" : @"满满的幸福",
                               @"tradeName" : @"满满的幸福",
                               @"memberPrice":@"25",
                               @"originalPrice":@"34",
                               },
                             @{
                               @"tradeImage" : @"萌萌哒烤芒果",
                               @"tradeName" : @"萌萌哒考芒果",
                               @"memberPrice":@"11",
                               @"originalPrice":@"45",
                               },
                             @{
                               @"tradeImage" : @"水果很芒",
                               @"tradeName" : @"水果很芒",
                               @"memberPrice":@"23",
                               @"originalPrice":@"55",
                               },
                             @{
                               @"tradeImage" : @"我们仨",
                               @"tradeName" : @"我们仨",
                               @"memberPrice":@"23",
                               @"originalPrice":@"56",
                               },
                             @{
                               @"tradeImage" : @"致柔软的青春",
                               @"tradeName" : @"致柔软的青春",
                               @"memberPrice":@"12",
                               @"originalPrice":@"67",
                               },
                             nil ];
    
    NSMutableArray *sweetmeatsArray = [[NSMutableArray alloc] initWithObjects:
                                    @{
                                      @"tradeImage" : @"蛋糕",
                                      @"tradeName" : @"蛋糕",
                                      @"memberPrice":@"34",
                                      @"originalPrice":@"45",
                                      },
                                    @{
                                      @"tradeImage" : @"柠檬磅蛋糕",
                                      @"tradeName" : @"柠檬磅蛋糕",
                                      @"memberPrice":@"45",
                                      @"originalPrice":@"55",                               },
                                    @{
                                      @"tradeImage" : @"贝壳蛋糕",
                                      @"tradeName" : @"贝壳蛋糕",
                                      @"memberPrice":@"22",
                                      @"originalPrice":@"33",
                                      },
                                    @{
                                      @"tradeImage" : @"布朗尼",
                                      @"tradeName" : @"布朗尼",
                                      @"memberPrice":@"44",
                                      @"originalPrice":@"55",
                                      },
                                    @{
                                      @"tradeImage" : @"马卡龙",
                                      @"tradeName" : @"马卡龙",
                                      @"memberPrice":@"25",
                                      @"originalPrice":@"34",
                                      },
                                    @{
                                      @"tradeImage" : @"泡芙塔",
                                      @"tradeName" : @"泡芙塔",
                                      @"memberPrice":@"11",
                                      @"originalPrice":@"45",
                                      },
                                    @{
                                      @"tradeImage" : @"纸杯蛋糕",
                                      @"tradeName" : @"纸杯蛋糕",
                                      @"memberPrice":@"23",
                                      @"originalPrice":@"55",
                                      },
                                    @{
                                      @"tradeImage" : @"蓝莓磅蛋糕",
                                      @"tradeName" : @"蓝莓磅蛋糕",
                                      @"memberPrice":@"23",
                                      @"originalPrice":@"56",
                                      },
                                    nil ];
    NSMutableArray *coffeeArray = [[NSMutableArray alloc] initWithObjects:
                                       @{
                                         @"tradeImage" : @"卡布奇诺",
                                         @"tradeName" : @"卡布奇诺",
                                         @"memberPrice":@"34",
                                         @"originalPrice":@"45",
                                         },
                                       @{
                                         @"tradeImage" : @"美式咖啡",
                                         @"tradeName" : @"美式咖啡",
                                         @"memberPrice":@"45",
                                         @"originalPrice":@"55",                               },
                                       @{
                                         @"tradeImage" : @"摩卡",
                                         @"tradeName" : @"摩卡",
                                         @"memberPrice":@"22",
                                         @"originalPrice":@"33",
                                         },
                                       @{
                                         @"tradeImage" : @"拿铁",
                                         @"tradeName" : @"拿铁",
                                         @"memberPrice":@"44",
                                         @"originalPrice":@"55",
                                         },
                                       @{
                                         @"tradeImage" : @"意式浓缩咖啡",
                                         @"tradeName" : @"意式浓缩咖啡",
                                         @"memberPrice":@"25",
                                         @"originalPrice":@"34",
                                         },
                                   nil ];
    NSMutableArray *teaArray = [[NSMutableArray alloc] initWithObjects:
                                @{
                                  @"tradeImage" : @"草本清新",
                                  @"tradeName" : @"草本清新",
                                  @"memberPrice":@"34",
                                  @"originalPrice":@"45",
                                  },
                                @{
                                  @"tradeImage" : @"粉红佳人",
                                  @"tradeName" : @"粉红佳人",
                                  @"memberPrice":@"45",
                                  @"originalPrice":@"55",                               },
                                @{
                                  @"tradeImage" : @"炭培乌龙",
                                  @"tradeName" : @"炭培乌龙",
                                  @"memberPrice":@"22",
                                  @"originalPrice":@"33",
                                  },
                                @{
                                  @"tradeImage" : @"夏日柠檬",
                                  @"tradeName" : @"夏日柠檬",
                                  @"memberPrice":@"44",
                                  @"originalPrice":@"55",
                                  },
                                @{
                                  @"tradeImage" : @"EarlGreyTea",
                                  @"tradeName" : @"EarlGreyTea",
                                  @"memberPrice":@"25",
                                  @"originalPrice":@"34",
                                  },
                                @{
                                  @"tradeImage" : @"TeaCup",
                                  @"tradeName" : @"TeaCup",
                                  @"memberPrice":@"25",
                                  @"originalPrice":@"34",
                                  },
                                nil ];
    NSMutableArray *drinkArray = [[NSMutableArray alloc] initWithObjects:
                                @{
                                  @"tradeImage" : @"草莓奶昔",
                                  @"tradeName" : @"草莓奶昔",
                                  @"memberPrice":@"34",
                                  @"originalPrice":@"45",
                                  },
                                @{
                                  @"tradeImage" : @"哈密瓜汁",
                                  @"tradeName" : @"哈密瓜汁",
                                  @"memberPrice":@"45",
                                  @"originalPrice":@"55",                               },
                                @{
                                  @"tradeImage" : @"芒果椰奶",
                                  @"tradeName" : @"芒果椰奶",
                                  @"memberPrice":@"22",
                                  @"originalPrice":@"33",
                                  },
                                @{
                                  @"tradeImage" : @"芒果汁",
                                  @"tradeName" : @"芒果汁",
                                  @"memberPrice":@"44",
                                  @"originalPrice":@"55",
                                  },
                                @{
                                  @"tradeImage" : @"猕猴桃汁",
                                  @"tradeName" : @"猕猴桃汁",
                                  @"memberPrice":@"25",
                                  @"originalPrice":@"34",
                                  },
                                @{
                                  @"tradeImage" : @"牛油果奶昔",
                                  @"tradeName" : @"牛油果奶昔",
                                  @"memberPrice":@"25",
                                  @"originalPrice":@"34",
                                  },
                                nil ];
    
    
    self.dataArray = [[NSMutableArray alloc] init];
    
//    for (NSDictionary * dict in dessertArray) {
//        TradeModel * model = [[TradeModel alloc] init];
//        [model setValuesForKeysWithDictionary:dict];
//        [self.dataArray addObject:model];
//    }
    
    self.dataDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:dessertArray,@"甜品",sweetmeatsArray,@"西点",coffeeArray,@"咖啡",teaArray,@"茶",drinkArray,@"饮品", nil];
    

    
    for (NSDictionary * dict in self.dataDic[@"甜品"]) {
        TradeModel * model = [[TradeModel alloc] init];
        [model setValuesForKeysWithDictionary:dict];
        [self.dataArray addObject:model];
    }
    for (NSDictionary * dict in self.dataDic[@"饮品"]) {
        TradeModel * model = [[TradeModel alloc] init];
        [model setValuesForKeysWithDictionary:dict];
        [self.dataArray addObject:model];
    }
    for (NSDictionary * dict in self.dataDic[@"西点"]) {
        TradeModel * model = [[TradeModel alloc] init];
        [model setValuesForKeysWithDictionary:dict];
        [self.dataArray addObject:model];
    }
    for (NSDictionary * dict in self.dataDic[@"咖啡"]) {
        TradeModel * model = [[TradeModel alloc] init];
        [model setValuesForKeysWithDictionary:dict];
        [self.dataArray addObject:model];
    }
    for (NSDictionary * dict in self.dataDic[@"茶"]) {
        TradeModel * model = [[TradeModel alloc] init];
        [model setValuesForKeysWithDictionary:dict];
        [self.dataArray addObject:model];
    }
    
    showSelectTypeTableView = NO;
    
}

- (void)initTableView
{
    //删除底部多余横线
    _tableView.tableFooterView =[[UIView alloc]init];
    //动画
    [self.tableView reloadDataAnimateWithWave:RightToLeftWaveAnimation];
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    [self.view addSubview:selectTypeTableViewBackView];
    [self.view addSubview:selectTypeTableView];

}
#pragma mark - 分类选择
- (void)selectType
{
    showSelectTypeTableView = !showSelectTypeTableView;
    if (showSelectTypeTableView) {
        selectTypeTableViewBackView.hidden = NO;
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            selectTypeTableView.layer.transform = CATransform3DMakeTranslation(-screenWidth/2, 0, 0);
            selectTypeTableViewBackView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
            
        } completion:^(BOOL finished) {
            
        }];
    }
    else {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            selectTypeTableView.layer.transform = CATransform3DIdentity;
            selectTypeTableViewBackView.backgroundColor = [UIColor clearColor];
            
        } completion:^(BOOL finished) {
            
            selectTypeTableViewBackView.hidden = YES;
        }];
    }
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
    if (tableView == selectTypeTableView) {
        return 44;
    }
    else {
        return 68;
    }
}

#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView != selectTypeTableView) {
        return [self.dataDic count];
    }
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSEnumerator * enumeratorKey = [self.dataDic keyEnumerator];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    //快速枚举遍历所有KEY的值
    for (NSObject *object in enumeratorKey) {
        [array addObject:object];
    }
    if (tableView != selectTypeTableView) {
        return [array objectAtIndex:section];
    }
    else
        return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView != selectTypeTableView) {
        return 30;
    }
    else
        return 0;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSEnumerator * enumeratorKey = [self.dataDic keyEnumerator];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    //快速枚举遍历所有KEY的值
    for (NSObject *object in enumeratorKey) {
        [array addObject:object];
    }

    CGFloat height ;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, height)] ;
    [headerView setBackgroundColor:shrbSectionColor];
    
    if (tableView != selectTypeTableView) {
        height = 30;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, (height-18)*0.5, tableView.bounds.size.width - 10, 18)];
        label.textColor = shrbText;
        
        label.backgroundColor = [UIColor clearColor];
        [headerView addSubview:label];
        label.text = [array objectAtIndex:section];;
        return headerView;
    }
    else {
        height = 0 ;
        return headerView;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == selectTypeTableView) {
        return [self.dataDic count];
    }
    else {
        if (section == 0) {
            return [self.dataDic[@"甜品"] count];
        }
        else if (section == 1){
            return [self.dataDic[@"饮品"] count];
        }
        else if (section == 2){
            return [self.dataDic[@"西点"] count];
        }
        else if (section == 3){
            return [self.dataDic[@"咖啡"] count];
        }
        else {
            return [self.dataDic[@"茶"] count];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == selectTypeTableView) {
        static NSString *SimpleTableIdentifier = @"cellId";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        NSEnumerator * enumeratorKey = [self.dataDic keyEnumerator];
        NSMutableArray *array = [[NSMutableArray alloc] init];
        //快速枚举遍历所有KEY的值
        for (NSObject *object in enumeratorKey) {
            [array addObject:object];
        }
        cell.textLabel.text = array[indexPath.row];
        
        return cell;
    }
    else {
        static NSString *SimpleTableIdentifier = @"CouponsTableViewCellIdentifier";
        StoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (cell == nil) {
            cell = [[StoreTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
        }
        if (indexPath.section == 0) {
            cell.model = self.dataArray[indexPath.row];
        }
        else if (indexPath.section == 1) {
            cell.model = self.dataArray[indexPath.row+[self.dataDic[@"甜品"] count]];
        }
        else if (indexPath.section == 2) {
            cell.model = self.dataArray[indexPath.row+[self.dataDic[@"甜品"] count]+[self.dataDic[@"饮品"] count]];
        }
        else if (indexPath.section == 3) {
            cell.model = self.dataArray[indexPath.row+[self.dataDic[@"甜品"] count]+[self.dataDic[@"饮品"] count]+[self.dataDic[@"西点"] count]];
        }
        else {
            cell.model = self.dataArray[indexPath.row+[self.dataDic[@"甜品"] count]+[self.dataDic[@"饮品"] count]+[self.dataDic[@"西点"] count]+[self.dataDic[@"咖啡"] count]];
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == selectTypeTableView) {
        showSelectTypeTableView = !showSelectTypeTableView;
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            selectTypeTableView.layer.transform = CATransform3DIdentity;
            selectTypeTableViewBackView.backgroundColor = [UIColor clearColor];
            
        } completion:^(BOOL finished) {
            
            selectTypeTableViewBackView.hidden = YES;
            
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.row] animated:YES scrollPosition:UITableViewScrollPositionTop];
        }];
    }
    else {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
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
