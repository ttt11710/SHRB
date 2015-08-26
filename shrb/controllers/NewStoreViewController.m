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
#import "SuperQRViewController.h"


#import "ProductViewController.h"
#import "ProductIsMemberViewController.h"


static NewStoreViewController *g_StoreViewController = nil;
@interface NewStoreViewController ()
{
    NSMutableDictionary *_currentNumDic;
    CGRect _rect;
    CGFloat lastContentOffset;
    BOOL showSelectTypeTableView;
}
@property (weak, nonatomic) IBOutlet UIView *selectTypeTableViewBackView;
@property (weak, nonatomic) IBOutlet UITableView *selectTypeTableView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) UIBezierPath *path;
@property (weak, nonatomic) IBOutlet UIButton *QRViewBtn;
@property (weak, nonatomic) IBOutlet UILabel *QRLabel;

@property (nonatomic,strong) NSMutableArray * modelArray;
@property (nonatomic, strong) NSMutableArray *plistArr;

@end

@implementation NewStoreViewController{
    CALayer     *layer;
}

@synthesize currentRow;

+ (NewStoreViewController *)shareStoreViewController
{
    return g_StoreViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    g_StoreViewController = self;
    
    showSelectTypeTableView = NO;
    
    [self initView];
    [self initData];
    [self initTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   // self.tabBarController.tabBar.hidden=YES;
    self.view.hidden = NO;
    
    [self btnAnimation];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.view.hidden = YES;
}

- (void)initView
{
    self.title = [[NSUserDefaults standardUserDefaults] stringForKey:@"storeName"];
    
    UIBarButtonItem *selectType = [[UIBarButtonItem alloc] initWithTitle:@"分类" style:UIBarButtonItemStylePlain target:self action:@selector(selectType)];
    self.navigationItem.rightBarButtonItem = selectType;
}

- (void)initData
{
    _currentNumDic = [[NSMutableDictionary alloc]init];
    
    NSString *storeFile = [[NSUserDefaults standardUserDefaults] stringForKey:@"storePlistName"];
    
    self.plistArr =[[NSMutableArray alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:storeFile ofType:@"plist"]];
    
    self.modelArray = [[NSMutableArray alloc] init];
    
    showSelectTypeTableView = NO;
}

- (void)initTableView
{
    //去除tableview顶部留白
    self.automaticallyAdjustsScrollViewInsets = false;
   
    //删除底部多余横线
    _tableView.tableFooterView =[[UIView alloc]init];
    
    self.selectTypeTableView.tableFooterView = [[UIView alloc] init];
    //动画
    [self.tableView reloadDataAnimateWithWave:RightToLeftWaveAnimation];
}


- (void)btnAnimation
{
    self.QRViewBtn.layer.transform = CATransform3DMakeScale(1, 0, 1);
    
    [UIView animateWithDuration:0.5 delay:1.0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        self.QRViewBtn.layer.transform = CATransform3DIdentity;
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)btnAnimation1
{
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        self.QRViewBtn.layer.transform = CATransform3DMakeScale(0.95, 0.95, 1);
        self.QRLabel.layer.transform = CATransform3DMakeScale(0.95, 0.95, 1);
        
    } completion:^(BOOL finished) {
        [self btnAnimation2];
    }];
}


- (void)btnAnimation2
{
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        self.QRViewBtn.layer.transform = CATransform3DIdentity;
        self.QRLabel.layer.transform = CATransform3DIdentity;
        
    } completion:^(BOOL finished) {
        [self btnAnimation1];
    }];
}

#pragma mark - 分类选择
- (void)selectType
{
    showSelectTypeTableView = !showSelectTypeTableView;
    if (showSelectTypeTableView) {
        self.selectTypeTableViewBackView.hidden = NO;
        
        [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.selectTypeTableView.layer.transform = CATransform3DMakeTranslation(-screenWidth/2, 0, 0);
            
        } completion:^(BOOL finished) {
            
        }];
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            self.selectTypeTableViewBackView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
            
        } completion:^(BOOL finished) {
            
        }];
    }
    else {
        
        [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.selectTypeTableView.layer.transform = CATransform3DMakeTranslation(-screenWidth/2, 0, 0);
            
        } completion:^(BOOL finished) {
            
        }];
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            self.selectTypeTableViewBackView.backgroundColor = [UIColor clearColor];
            
        } completion:^(BOOL finished) {
            
        }];

        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            self.selectTypeTableView.layer.transform = CATransform3DIdentity;
            
        } completion:^(BOOL finished) {
            
            self.selectTypeTableViewBackView.hidden = YES;
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
    if (tableView == self.selectTypeTableView) {
        return 44;
    }
    else {
        return 68;
    }
}

#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView != self.selectTypeTableView) {
        return [self.plistArr count];
    }
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView != self.selectTypeTableView) {
        return [self.plistArr objectAtIndex:section][@"type"];
    }
    else
        return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView != self.selectTypeTableView) {
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
    
    if (tableView != self.selectTypeTableView) {
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
    if (tableView == self.selectTypeTableView) {
        return [self.plistArr count];
    }
    else {
        return [[self.plistArr objectAtIndex:section][@"info"] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.selectTypeTableView) {
        static NSString *SimpleTableIdentifier = @"cellId";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
        cell.textLabel.text = [self.plistArr objectAtIndex:indexPath.row][@"type"];
        cell.textLabel.textColor = shrbText;
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
    
    if (tableView == self.selectTypeTableView) {
        showSelectTypeTableView = !showSelectTypeTableView;
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            self.selectTypeTableView.layer.transform = CATransform3DIdentity;
            self.selectTypeTableViewBackView.backgroundColor = [UIColor clearColor];
            
        } completion:^(BOOL finished) {
            
            self.selectTypeTableViewBackView.hidden = YES;
            
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.row] animated:YES scrollPosition:UITableViewScrollPositionTop];
        }];
    }
    else {
        
        BOOL isMember = [[NSUserDefaults standardUserDefaults] boolForKey:@"isMember"];
        if (isMember) {
            
            ProductIsMemberViewController *viewController = [[ProductIsMemberViewController alloc] init];
            viewController.currentRow = indexPath.row;
            viewController.currentSection = indexPath.section;
            [self.navigationController pushViewController:viewController animated:YES];
            
            
        }
        else {
            
            ProductViewController *viewController = [[ProductViewController alloc] init];
            
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
}

#pragma mark - tableView滚动调用
-(void)scrollViewWillBeginDragging:(UIScrollView*)scrollView {
    
    lastContentOffset = scrollView.contentOffset.y;
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (scrollView.contentOffset.y < lastContentOffset )
//    {
//        //向上
//        _topBtn.hidden = NO;
//        
//    } else if (scrollView. contentOffset.y >lastContentOffset){
//        //向下
//        CATransition *animation = [CATransition animation];
//        animation.type = kCATransitionMoveIn;
//        animation.duration = 1.0f;
//        [_topBtn.layer addAnimation:animation forKey:nil];
//        _topBtn.hidden = YES;
//    }
//    if (scrollView.contentOffset.y == 0) {
//        _topBtn.hidden = YES;
//    }
//}

//#pragma mark - tableView滚回最前面
//- (IBAction)tabViewSetContentToTop:(id)sender {
//    
//    //到顶部
//    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
//}


#pragma mark - 扫码支付
- (IBAction)goToQRView:(id)sender {
    
//    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"IsLogin"];
//    if (!isLogin) {
//        [SVProgressShow showInfoWithStatus:@"请先登录账号！"];
//        return ;
//    }
    if ([self validateCamera]) {
        
        [self showQRViewController];
        
    } else {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有摄像头或摄像头不可用" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

- (BOOL)validateCamera {
    
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] &&
    [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

#pragma mark - 进入扫码页面
- (void)showQRViewController {
    
    SuperQRViewController *qrVC = [[SuperQRViewController alloc] init];
    [self.navigationController pushViewController:qrVC animated:YES];
}

#pragma  mark - storyboard传值
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    OrdersViewController *shoppingCartViewController = segue.destinationViewController;
    shoppingCartViewController.isMember = [[NSUserDefaults standardUserDefaults] boolForKey:@"isMember"];
}

@end
