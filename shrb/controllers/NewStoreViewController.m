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

@property (nonatomic,strong) NSMutableArray * modelArray;
@property (nonatomic, strong) NSMutableArray *plistArr;

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
    
    [self.view insertSubview:selectTypeTableViewBackView aboveSubview:self.view];
    [self.view insertSubview:selectTypeTableView aboveSubview:self.view];
}

- (void)initData
{
    _currentNumDic = [[NSMutableDictionary alloc]init];
    
    self.plistArr =[[NSMutableArray alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"holy" ofType:@"plist"]];
    
    self.modelArray = [[NSMutableArray alloc] init];
    
    showSelectTypeTableView = NO;
}

- (void)initTableView
{
    //删除底部多余横线
    _tableView.tableFooterView =[[UIView alloc]init];
    //动画
    [self.tableView reloadDataAnimateWithWave:RightToLeftWaveAnimation];
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
    [self.modelArray addObject:@{
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
        return [self.plistArr count];
    }
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView != selectTypeTableView) {
        return [self.plistArr objectAtIndex:section][@"type"];
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
    CGFloat height ;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, height)] ;
    [headerView setBackgroundColor:shrbSectionColor];
    
    if (tableView != selectTypeTableView) {
        height = 30;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, (height-18)*0.5, tableView.bounds.size.width - 10, 18)];
        label.textColor = shrbText;
        
        label.backgroundColor = [UIColor clearColor];
        [headerView addSubview:label];
        label.text = [self.plistArr objectAtIndex:section][@"type"];
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
        return [self.plistArr count];
    }
    else {
        return [[self.plistArr objectAtIndex:section][@"info"] count];
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
    
        cell.textLabel.text = [self.plistArr objectAtIndex:indexPath.row][@"type"];
        
        return cell;
    }
    else {
        static NSString *SimpleTableIdentifier = @"CouponsTableViewCellIdentifier";
        StoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (cell == nil) {
            cell = [[StoreTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
        }
        [self.modelArray removeAllObjects];
        for (NSDictionary * dict in [self.plistArr objectAtIndex:indexPath.section][@"info"]) {
            TradeModel * model = [[TradeModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            [self.modelArray addObject:model];
        }
        
        cell.model = self.modelArray[indexPath.row];
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
            viewController.currentSection = indexPath.section;
            viewController.currentRow = indexPath.row;
            [viewController setModalPresentationStyle:UIModalPresentationFullScreen];
            
            
            [self.navigationController pushViewController:viewController animated:YES];
            
        }
        else {
            ProductTableViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"ProductTableView"];
            viewController.currentSection = indexPath.section;
            viewController.currentRow = indexPath.row;
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
