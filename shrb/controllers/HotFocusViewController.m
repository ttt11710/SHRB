//
//  HotViewController.m
//  shrb
//  热点
//  Created by PayBay on 15/5/20.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "HotFocusViewController.h"
#import "HotFocusTableViewCell.h"
#import "HotFocusModel.h"
#import "HotDetailViewController.h"
#import "UITableView+Wave.h"
#import "Const.h"
#import <CBZSplashView/CBZSplashView.h>
#import "KYCuteView.h"
#import "SVProgressShow.h"
#import "NewStoreViewController.h"
#import "StoreViewController.h"
#import "TQTableViewCellRemoveController.h"

//#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface HotFocusViewController () <TQTableViewCellRemoveControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,strong) NSMutableArray * plistArr;


@property (nonatomic,strong) TQTableViewCellRemoveController *cellRemoveController;

@end

@implementation HotFocusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initController];
    [self initData];
    [self initTableView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)initController
{
    //导航颜色
    self.navigationController.navigationBar.barTintColor = shrbPink;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    //工具栏图片 选中颜色
    self.tabBarController.tabBar.selectedItem.selectedImage = [UIImage imageNamed:@"恋人_highlight"];
    self.tabBarController.tabBar.tintColor = shrbPink;
    
    //动画 全屏
    UIImage *icon = [UIImage imageNamed:@"官方头像"];
    UIColor *color = shrbPink;
    CBZSplashView *splashView = [CBZSplashView splashViewWithIcon:icon backgroundColor:color];
    [self.view addSubview:splashView];
    [splashView startAnimation];

}

- (void)initData
{
    self.dataArray = [[NSMutableArray alloc] init];
    self.plistArr =[[NSMutableArray alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"store" ofType:@"plist"]];
}

- (void)initTableView
{
    //删除底部多余横线
    self.tableView.tableFooterView =[[UIView alloc]init];
    //动画
    [self.tableView reloadDataAnimateWithWave:RightToLeftWaveAnimation];
    
    self.tableView.backgroundColor = shrbTableViewColor;
    
    self.cellRemoveController = [[TQTableViewCellRemoveController alloc] initWithTableView:self.tableView];
    self.cellRemoveController.delegate = self;
}

#pragma mark - tableView dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 244;
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.plistArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimpleTableIdentifier = @"HotMembersTableViewCellIdentifier";
    HotFocusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (cell == nil) {
        cell = [[HotFocusTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
    }
    
    [self.dataArray removeAllObjects];
    for (NSDictionary * dict in self.plistArr) {
        HotFocusModel * model = [[HotFocusModel alloc] init];
        [model setValuesForKeysWithDictionary:dict];
        [self.dataArray addObject:model];
    }

    cell.model = self.dataArray[indexPath.row];

//    if (indexPath.row == 0) {
//        KYCuteView *badgeLabel = [[KYCuteView alloc]initWithPoint:CGPointMake(60, 4) superView:cell];
//        badgeLabel.viscosity = 8;
//        badgeLabel.bubbleWidth = 20;
//        badgeLabel.bubbleColor = [UIColor redColor];
//        [badgeLabel setUp];
//        [badgeLabel addGesture];
//        badgeLabel.bubbleLabel.text = @"2";
//        badgeLabel.bubbleLabel.textColor = [UIColor whiteColor];
//        
//        NSString *badgeNum = badgeLabel.bubbleLabel.text;
//        NSInteger num =  [badgeNum integerValue];
//        badgeLabel.frontView.hidden = num == 0?YES:NO;
//    }
    
    cell.tag = indexPath.row;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
     NSString*storePlistName = self.plistArr[indexPath.row][@"storePlistName"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"storePlistName"];
    [[NSUserDefaults standardUserDefaults] setObject:storePlistName forKey:@"storePlistName"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"storeName"];
    [[NSUserDefaults standardUserDefaults] setObject:self.plistArr[indexPath.row][@"storeName"] forKey:@"storeName"];
    
    
    //是否会员
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isMember"];
    if ([storePlistName isEqualToString:@"16N"] || [storePlistName isEqualToString:@"holy"] ) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isMember"];
    }
    else {
       [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isMember"];
    }
    
    //店铺类型
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"typesOfShops"];
    if ([storePlistName isEqualToString:@"16N"] || [storePlistName isEqualToString:@"yunifang"] ) {
        [[NSUserDefaults standardUserDefaults] setObject:@"supermarket" forKey:@"typesOfShops"];
    }
    else {
        [[NSUserDefaults standardUserDefaults] setObject:@"order" forKey:@"typesOfShops"];
    }
    
    
    HotFocusTableViewCell* cell = (HotFocusTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
//    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    HotDetailViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"HotDetailView"];
//    viewController.storeNum = indexPath.row;
//    [viewController setModalPresentationStyle:UIModalPresentationFullScreen];
//    
//    [self.navigationController pushViewController:viewController animated:YES];
    
    [SVProgressShow showWithStatus:@"进入店铺..."];
    
    //点击弹动动画
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        cell.hotImageView.layer.transform = CATransform3DMakeScale(0.8, 0.8, 1);
        cell.shadowView.layer.transform = CATransform3DMakeScale(0.8, 0.8, 1);
        cell.storeLabelImage.layer.transform = CATransform3DMakeScale(0.8, 0.8, 1);
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            cell.hotImageView.layer.transform = CATransform3DIdentity;
            cell.shadowView.layer.transform = CATransform3DIdentity;
            cell.storeLabelImage.layer.transform = CATransform3DIdentity;
            
        } completion:^(BOOL finished) {
            
            [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(todoSomething:) object:nil];
            [self performSelector:@selector(todoSomething:) withObject:indexPath afterDelay:0.0f];
            
        }];
        
    }];
}


#pragma mark - 延时显示状态然后跳转
- (void)todoSomething:(NSIndexPath *)indexPath
{
    NSString * typesOfShops = [[NSUserDefaults standardUserDefaults] stringForKey:@"typesOfShops"];
    
    //supermarket
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    
    
    if ([typesOfShops isEqualToString:@"supermarket"]) {
        //超市
        NewStoreViewController *newStoreViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"newstoreView"];
        newStoreViewController.currentRow = indexPath.row;
        [newStoreViewController setModalPresentationStyle:UIModalPresentationFullScreen];
        [self.navigationController pushViewController:newStoreViewController animated:YES];
        [SVProgressShow dismiss];
    }
    else if ([typesOfShops isEqualToString:@"order"]) {
        //点餐
        StoreViewController *storeViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"storeView"];
        storeViewController.currentRow = indexPath.row;
        [storeViewController setModalPresentationStyle:UIModalPresentationFullScreen];
        [self.navigationController pushViewController:storeViewController animated:YES];
        [SVProgressShow dismiss];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.alpha = 1;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    cell.alpha = 0;
    cell.transform = CGAffineTransformMakeTranslation(0, 0);
}


- (void)didRemoveTableViewCellWithIndexPath:(NSIndexPath *)indexPath
{
    
    NSMutableArray* deleteArr = [NSMutableArray arrayWithObject:[self.plistArr objectAtIndex:indexPath.row]];
    [self.plistArr removeObjectAtIndex:indexPath.row];
    
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
    [self.tableView endUpdates];
    
//    NSMutableArray *insertion = [[NSMutableArray alloc]init];
//    [insertion addObject:[NSIndexPath indexPathForRow:self.plistArr.count inSection:0]];
//    
//    [self.plistArr addObjectsFromArray:deleteArr];
//    [self.tableView beginUpdates];
//    [self.tableView insertRowsAtIndexPaths:insertion withRowAnimation:UITableViewRowAnimationTop];
//    [self.tableView endUpdates];
    
    [self.plistArr addObjectsFromArray:deleteArr];
    [self.tableView reloadData];
}


@end









