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
#import "NewStoreCollectController.h"
#import "DB.h"
#import "Migrations.h"
#import "MessageProcessor.h"
#import "HotListSelectViewController.h"


//#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface HotFocusViewController () <TQTableViewCellRemoveControllerDelegate>
{
    MessageProcessor *_messageProcessor;;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,strong) NSMutableArray * plistArr;

@property (nonatomic,strong) TQTableViewCellRemoveController *cellRemoveController;

@end

@implementation HotFocusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _messageProcessor = [[MessageProcessor alloc] init];
    
    [self initData];
    [self getDataFormDB];
    
    [self initController];
    
    [self initTableView];
    [self cardAnimation];
    
    CGRect rect = [[UIApplication sharedApplication] statusBarFrame];
    
    CGRect rectNav = self.navigationController.navigationBar.frame;
    
    CGRect rectTab = self.tabBarController.tabBar.frame;
    
  //  [self loadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   // self.tabBarController.tabBar.hidden = NO;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
  //  self.tabBarController.tabBar.hidden = YES;
}



#pragma mark - 网络请求数据
- (void)loadData
{

    DB *db = [DB openDb];
    
    NSString *url=[baseUrl stringByAppendingString:@""];
    
    //http://api.map.baidu.com/telematics/v3/weather?&ak=Q0qFFiynCewS75iBPQ9TkChH&location=上海&output=json
    [self.requestOperationManager POST:url parameters:@{@"location":@"上海",@"output":@"json"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *d=(NSDictionary *)responseObject ;
        NSLog(@"d = %@",d);
        
        [self insertDataToDB];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败");
    }];
}

#pragma mark - 数据库插入数据
- (void)insertDataToDB
{
    for (NSDictionary * dict in self.plistArr) {
        NSLog(@"dict = %@",dict);
        Store *store = [[Store alloc] init];
        [store setValuesForKeysWithDictionary:dict];
        [_messageProcessor process:store];
    }
}

#pragma mark - 获取数据库数据
- (void)getDataFormDB
{
    DB *db = [DB openDb];
    FMResultSet *rs = [db executeQuery:@"select * from store"];
    
    [self.dataArray removeAllObjects];
    while ([rs next]) {
        Store *store = [[Store alloc] init];
        store.storeId = [rs stringForColumn:@"storeid"];
        store.storePlistName = [rs stringForColumn:@"storeplistname"];
        store.storeLabel = [rs stringForColumn:@"storelabel"];
        store.storeDetail = [rs stringForColumn:@"storedetail"];
        store.storeLogo = [rs stringForColumn:@"storelogo"];
        store.images = [rs stringForColumn:@"images"];
        store.simpleStoreDetail = [rs stringForColumn:@"simplestoredetail"];
        store.storeName = [rs stringForColumn:@"storename"];
        
        [self.dataArray addObject:store];
        
    }
    if ([self.dataArray count] == 0) {
        for (NSDictionary * dict in self.plistArr) {
            Store * store = [[Store alloc] init];
            [store setValuesForKeysWithDictionary:dict];
            [self.dataArray addObject:store];
        }
    }
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
    //tableView 去分界线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //删除底部多余横线
    self.tableView.tableFooterView =[[UIView alloc]init];
    //动画
    [self.tableView reloadDataAnimateWithWave:RightToLeftWaveAnimation];
    
   // self.tableView.backgroundColor = shrbTableViewColor;
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    self.cellRemoveController = [[TQTableViewCellRemoveController alloc] initWithTableView:self.tableView];
    self.cellRemoveController.delegate = self;
}

- (void)cardAnimation
{
    for (NSIndexPath* indexPath in [self.tableView indexPathsForVisibleRows])
    {
        HotFocusTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        cell.hotImageView.layer.transform = CATransform3DMakeScale(1, 0, 1);
        cell.shadowView.layer.transform = CATransform3DMakeScale(1, 0, 1);
        cell.storeLabelImage.layer.transform = CATransform3DMakeScale(1, 0, 1);
        
        //点击弹动动画
        
        [UIView animateWithDuration:1.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            cell.hotImageView.layer.transform = CATransform3DIdentity;
            cell.shadowView.layer.transform = CATransform3DIdentity;
            cell.storeLabelImage.layer.transform = CATransform3DIdentity;
        } completion:nil];
    }
}

#pragma mark - tableView dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return screenWidth/8*5+12+21;
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
    
//    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
//        
//        cell.hotImageView.layer.transform = CATransform3DMakeScale(5, 5, 1);
//        
//        
//    } completion:^(BOOL finished) {
//        
//        [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(todoSomething:) object:nil];
//        [self performSelector:@selector(todoSomething:) withObject:indexPath afterDelay:0.0f];
//        cell.hotImageView.layer.transform = CATransform3DIdentity;
//    }];
}


#pragma mark - 延时显示状态然后跳转
- (void)todoSomething:(NSIndexPath *)indexPath
{
    NSString * typesOfShops = [[NSUserDefaults standardUserDefaults] stringForKey:@"typesOfShops"];
    
    //supermarket
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    
    
    if ([typesOfShops isEqualToString:@"supermarket"]) {
        //超市
//        NewStoreViewController *newStoreViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"newstoreView"];
//        newStoreViewController.currentRow = indexPath.row;
//        [newStoreViewController setModalPresentationStyle:UIModalPresentationFullScreen];
//        [self.navigationController pushViewController:newStoreViewController animated:YES];
//        [SVProgressShow dismiss];
        
        NewStoreCollectController *newStoreCollectController = [[NewStoreCollectController alloc] init];
        newStoreCollectController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:newStoreCollectController animated:YES];
        [SVProgressShow dismiss];
    }
    else if ([typesOfShops isEqualToString:@"order"]) {
        //点餐
        StoreViewController *storeViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"storeView"];
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

#pragma mark - 刷选商店
- (IBAction)selectStore:(id)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HotListSelectViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"HotListSelectViewController"];
    [viewController setModalPresentationStyle:UIModalPresentationFullScreen];
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}


@end









