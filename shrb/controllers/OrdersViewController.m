//
//  ShoppingCartViewController.m
//  shrb
//  购物车
//  Created by PayBay on 15/5/20.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "OrdersViewController.h"
#import "OrdersTableViewCell.h"
#import "PayViewController.h"
#import "ButtonTableViewCell.h"
#import "UITableView+Wave.h"
#import "Const.h"
#import "HJCAjustNumButton3.h"
#import "TNImageCheckBoxData.h"
#import "TNCheckBoxGroup.h"
#import "BecomeMemberView.h"
#import "CardTableViewCell.h"
#import "NewCardDetailViewController.h"
#import "NSString+AttributedStyle.h"
#import "StoreViewController.h"

#import "StoreTableViewCell.h"
#import "TradeModel.h"
#import "shrb-swift.h"


static OrdersViewController *g_OrdersViewController = nil;

@interface OrdersViewController ()
{
    TNCheckBoxGroup *_loveGroup;
    UITapGestureRecognizer *_tap;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *showOtherPayBtn;
@property (weak, nonatomic) IBOutlet BFPaperButton *memberPayBtn;
@property (weak, nonatomic) IBOutlet BFPaperButton *otherPayBtn;

@property (nonatomic,strong) NSMutableArray * modelArray;
@property (nonatomic, strong) NSMutableArray *plistArr;

@end

@implementation OrdersViewController

@synthesize isMember;

+ (OrdersViewController *)shareOrdersViewController
{
    return g_OrdersViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    g_OrdersViewController = self;
    
    [self initView];
    [self initBtn];
    [self initData];
    [self initTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    isMember = [[NSUserDefaults standardUserDefaults] boolForKey:@"isMember"];
    [self.tableView reloadData];
}

- (void)viewDidLayoutSubviews
{
    if (IsiPhone4s) {
        self.tableView.frame = CGRectMake(0, 64, screenWidth, screenHeight-64-44);
    }
    [self.view layoutSubviews];
}
- (void)initView
{
    //导航颜色
    self.navigationController.navigationBar.barTintColor = shrbPink;
   self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

- (void)initBtn
{
    [self.showOtherPayBtn setBackgroundColor:shrbPink];
    [self.memberPayBtn setBackgroundColor:shrbPink];
    [self.otherPayBtn setBackgroundColor:shrbPink];
}

- (void)initData
{
    NSString *storeFile = [[NSUserDefaults standardUserDefaults] stringForKey:@"storePlistName"];
    
    self.plistArr =[[[[NSMutableArray alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:storeFile ofType:@"plist"]] objectAtIndex:0] objectForKey:@"info"];
    
    self.modelArray = [[NSMutableArray alloc] init];
}

- (void)initTableView
{
    //删除多余线
    self.tableView.tableFooterView =[[UIView alloc]init];
    self.tableView.backgroundColor = shrbTableViewColor;
    
    [self.tableView reloadDataAnimateWithWave:RightToLeftWaveAnimation];
    
    //底部添加多余空间
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, screenWidth, 40.f)];
}

#pragma mark - 添加手势
- (void)addTap
{
    if (_tap == nil) {
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        self.view.userInteractionEnabled = YES;
        [self.view addGestureRecognizer:_tap];
    }
}

#pragma mark - 去除手势
- (void)removeTap
{
    [self.view removeGestureRecognizer:_tap];
    _tap = nil;
}

#pragma mark - 更新tableView
- (void)UpdateTableView
{
    isMember = [[NSUserDefaults standardUserDefaults] boolForKey:@"isMember"];
    
    UINavigationController *navController = self.navigationController;
    [self.navigationController popViewControllerAnimated:NO];
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    OrdersViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"OrdersView"];
    viewController.isMember = isMember;
    [viewController setModalPresentationStyle:UIModalPresentationFullScreen];
    
    [navController pushViewController:viewController animated:NO];

}

#pragma mark - tableView dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [self.plistArr count]) {
        return 93;
    }
    else if (indexPath.row == [self.plistArr count]) {
        return 100;
    }
    else if (indexPath.row == [self.plistArr count]+1) {
        return 80;
    }
    else {
        return 68;
    }
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isMember) {
       // _showOtherPayBtn.hidden = YES;
        return [self.plistArr count]+1;
    }
    return [self.plistArr count]+3;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//        static NSString *SimpleTableIdentifier = @"CouponsTableViewCellIdentifier";
//        StoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
//        cell.selectionStyle=UITableViewCellSelectionStyleNone;
//        if (cell == nil) {
//            cell = [[StoreTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
//        }
//        
//        [self.modelArray removeAllObjects];
//        for (NSDictionary * dict in [self.plistArr objectAtIndex:0][@"info"]) {
//            TradeModel * model = [[TradeModel alloc] init];
//            [model setValuesForKeysWithDictionary:dict];
//            [self.modelArray addObject:model];
//        }
//        
//        cell.model = self.modelArray[indexPath.row];
//        return cell;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [self.plistArr count]) {
        static NSString *SimpleTableIdentifier = @"CouponsTableViewCellIdentifier";
        StoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (cell == nil) {
            cell = [[StoreTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
        }
        
        [self.modelArray removeAllObjects];
        for (NSDictionary * dict in self.plistArr) {
            TradeModel * model = [[TradeModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            [self.modelArray addObject:model];
        }
        
        cell.model = self.modelArray[indexPath.row];
        
        HJCAjustNumButton3 *numbutton = [[HJCAjustNumButton3 alloc] init];
        numbutton.frame = CGRectMake(screenWidth-85, 34, 75, 25);
        // 内容更改的block回调
        numbutton.callBack = ^(NSString *currentNum){
        };
        
        // 加到父控件上
        [cell addSubview:numbutton];
        return cell;
        
        // @"会员好处：成为会员可以享受会员折扣，付款可直接用会员卡，并有更多优惠哦！\n\n会员规则:会员卡充值后不可以取现，可以注销，同时扣除手续费5%。";
    }
    else if (indexPath.row == [self.plistArr count])
    {
        static NSString *simpleTableIdentifier = @"OrdersTableViewCellId";
        OrdersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (cell == nil) {
            cell = [[OrdersTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
        }
        
        cell.totalLabel.text = @"总价:450元";
        cell.memberTotalLabel.text = @"会员价:350元";
        
        TNImageCheckBoxData *manData = [[TNImageCheckBoxData alloc] init];
        manData.identifier = @"man";
        manData.labelText = @"100RMB电子券";
        manData.labelColor = [UIColor colorWithRed:78.0/255.0 green:78.0/255.0 blue:78.0/255.0 alpha:1];
        manData.labelFont = [UIFont systemFontOfSize:14.0];
        manData.checked = YES;
        manData.checkedImage = [UIImage imageNamed:@"checked"];
        manData.uncheckedImage = [UIImage imageNamed:@"unchecked"];
        
        if ([cell.checkCouponsView.checkedCheckBoxes count] == 0 ) {
            [cell.checkCouponsView myInitWithCheckBoxData:@[manData] style:TNCheckBoxLayoutVertical];
            [cell.checkCouponsView create];
        }
        return cell;
    }
    else if (indexPath.row == [self.plistArr count]+1)
    {
        
        static NSString *SimpleTableIdentifier = @"cellId";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
        }
        
        return cell;
    }
    else
    {
        static NSString *SimpleTableIdentifier = @"ButtonTableViewCellIdentifier";
        ButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (cell == nil) {
            cell = [[ButtonTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
        }
        
        [cell.buttonModel setTitle:@"会员注册" forState:UIControlStateNormal];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    KYDrawerController *drawerController = (KYDrawerController *)self.navigationController.parentViewController;
//    [drawerController setDrawerState:DrawerStateClosed animated:true];
//    
//    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(todoSomething) object:nil];
//    [self performSelector:@selector(todoSomething) withObject:nil afterDelay:0.3f];
    
//    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Card" bundle:nil];
//    NewCardDetailViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"CardDetailView"];
//    [viewController setModalPresentationStyle:UIModalPresentationFullScreen];
//    [self.navigationController pushViewController:viewController animated:YES];
    
    if (indexPath.row == [self.plistArr count]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (isMember) {
        //会员卡详情页面
        if (indexPath.row == [self.plistArr count]+2) {
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Card" bundle:nil];
            NewCardDetailViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"CardDetailView"];
            [viewController setModalPresentationStyle:UIModalPresentationFullScreen];
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
}

- (void)todoSomething
{
    [[StoreViewController shareStoreViewController] pushCardDetailView];
    
}
#pragma mark - 键盘消失
-(void)tap {
    
    [[BecomeMemberView shareBecomeMemberView] textFieldResignFirstResponder];
    
    [self removeTap];
}

#pragma  mark - storyboard传值
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    PayViewController *payViewController = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"memberPayidentifier"]) {
        payViewController.isMemberPay = YES;
    }
    else if([segue.identifier isEqualToString:@"othersPayidentifier"])
    {
        payViewController.isMemberPay = NO;
    }
}

#pragma mark - 电子券打钩
- (void)loveGroupChanged:(NSNotification *)notification {
    
    NSLog(@"Checked checkboxes %@", _loveGroup.checkedCheckBoxes);
    NSLog(@"Unchecked checkboxes %@", _loveGroup.uncheckedCheckBoxes);
    
}
@end
