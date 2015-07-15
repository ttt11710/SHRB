//
//  HotDetailViewController.m
//  shrb
//  热点详情
//  Created by PayBay on 15/5/19.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "HotDetailViewController.h"
#import "HotDetailTableViewCell.h"
#import <DCAnimationKit/UIView+DCAnimationKit.h>
#import <BFPaperButton/BFPaperButton.h>
#import "SVProgressShow.h"
#import "HotFocusModel.h"
#import "Const.h"
#import "DOPScrollableActionSheet.h"

@interface HotDetailViewController ()
{
    UIView *_moreView;
    UIButton *_collectBtn;
    UIButton *_shareBtn;
    
    NSMutableArray *_array;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,strong) NSMutableArray * plistArr;

@end

@implementation HotDetailViewController

@synthesize storeNum;

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self makeNavigationBar];
    [self initData];
    [self initTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden=YES;
}

- (void)makeNavigationBar
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addBtnPressed)];
    
    _moreView = [[UIView alloc] initWithFrame:CGRectMake(screenWidth-85, 20+44-8, 80, 35*2)];
    _moreView.hidden = YES;
    _collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _collectBtn.frame = CGRectMake(0, 0, 80, 35);
    [_collectBtn setTitle:@"收藏" forState:UIControlStateNormal];
    [_collectBtn setTitleColor:shrbPink forState:UIControlStateNormal];
    [_collectBtn setBackgroundImage:[UIImage imageNamed:@"button_highlight"] forState:UIControlStateHighlighted];
    [_collectBtn setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
    [_collectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    _collectBtn.layer.borderColor = shrbPink.CGColor;
    _collectBtn.layer.borderWidth = 1;
    [_collectBtn addTarget:self action:@selector(collectBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [_moreView addSubview:_collectBtn];
    
    _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _shareBtn.frame = CGRectMake(0, _collectBtn.frame.size.height-1, 80, 35);
    [_shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    [_shareBtn setTitleColor:shrbPink forState:UIControlStateNormal];
    [_shareBtn setBackgroundImage:[UIImage imageNamed:@"button_highlight"] forState:UIControlStateHighlighted];
    [_shareBtn setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
    _shareBtn.layer.borderColor = shrbPink.CGColor;
    _shareBtn.layer.borderWidth = 1;
    [_shareBtn addTarget:self action:@selector(shareBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [_shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    [_moreView addSubview:_shareBtn];
    
    [self.navigationController.view addSubview:_moreView];
    
}

- (void)initData
{
    self.dataArray = [[NSMutableArray alloc] init];
    self.plistArr =[[NSMutableArray alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"store" ofType:@"plist"]];
}

- (void)initTableView
{
    //去除tableview顶部留白
    self.automaticallyAdjustsScrollViewInsets = false;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //上下震动动画
    [self.tableView bounce:nil];
}

#pragma mark - tableView dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenWidth - 68, 0)];
    UIFont* theFont = [UIFont systemFontOfSize:15.0];
    label.numberOfLines = 0;
    [label setFont:theFont];
    [label setText:_array[storeNum][@"storeDetail"]];
    
    
    [label sizeToFit];// 显示文本需要的长度和宽度
    
    if (label.frame.size.height+160 < screenHeight-(20+44+44)) {
        return screenHeight-(20+44+44);
    }
    else {
       return label.frame.size.height+160;
    }
}


#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimpleTableIdentifier = @"HotDetailTableCellIdentifier";
    HotDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    [self.dataArray removeAllObjects];
    for (NSDictionary * dict in self.plistArr) {
        HotFocusModel * model = [[HotFocusModel alloc] init];
        [model setValuesForKeysWithDictionary:dict];
        [self.dataArray addObject:model];
    }
    
    cell.model = self.dataArray[storeNum];
    return cell;
}

#pragma mark - 更多按钮
- (void)addBtnPressed
{
    _moreView.hidden = NO;
}

#pragma mark - 收藏
- (void)collectBtnPressed
{
    _moreView.hidden = YES;
    [SVProgressShow showWithStatus:@"收藏中..."];
    double delayInSeconds = 1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [SVProgressShow showSuccessWithStatus:@"收藏成功！"];
    });
}

#pragma mark - 分享
- (void)shareBtnPressed
{
    _moreView.hidden = YES;
    
    DOPAction *action1 = [[DOPAction alloc] initWithName:@"Wechat" iconName:@"weixin" handler:^{
        [SVProgressShow showSuccessWithStatus:@"微信分享成功！"];
    }];
    DOPAction *action2 = [[DOPAction alloc] initWithName:@"QQ" iconName:@"qq" handler:^{
        [SVProgressShow showSuccessWithStatus:@"QQ分享成功！"];
    }];
    DOPAction *action3 = [[DOPAction alloc] initWithName:@"WxFriends" iconName:@"wxFriends" handler:^{
        [SVProgressShow showSuccessWithStatus:@"微信朋友圈分享成功！"];
    }];
    DOPAction *action4 = [[DOPAction alloc] initWithName:@"Qzone" iconName:@"qzone" handler:^{
        [SVProgressShow showSuccessWithStatus:@"QQ空间分享成功！"];
    }];
    DOPAction *action5 = [[DOPAction alloc] initWithName:@"Weibo" iconName:@"weibo" handler:^{
        [SVProgressShow showSuccessWithStatus:@"新浪微博分享成功！"];
    }];
    DOPAction *action6 = [[DOPAction alloc] initWithName:@"SMS" iconName:@"sms" handler:^{
        [SVProgressShow showSuccessWithStatus:@"短信发送成功！"];
    }];
    DOPAction *action7 = [[DOPAction alloc] initWithName:@"Email" iconName:@"email" handler:^{
        [SVProgressShow showSuccessWithStatus:@"邮件发送成功！"];
    }];
    
    
    NSArray *actions;
    actions = @[@"Share",
                @[action1, action2, action3, action4],
                @"",
                @[action5, action6, action7]];
    DOPScrollableActionSheet *as = [[DOPScrollableActionSheet alloc] initWithActionArray:actions];
    [as show];

}

#pragma mark - 进入商店
- (IBAction)gotoStoreView:(id)sender {
    
    [SVProgressShow showWithStatus:@"进入店铺..."];
    
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(todoSomething) object:nil];
    [self performSelector:@selector(todoSomething) withObject:nil afterDelay:0.4f];
}

#pragma mark - 延时显示状态然后跳转
- (void)todoSomething
{
    NSString * typesOfShops = [[NSUserDefaults standardUserDefaults] stringForKey:@"typesOfShops"];
    
    //supermarket
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UIViewController *viewController;
    if ([typesOfShops isEqualToString:@"supermarket"]) {
        //超市
        viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"newstoreView"];
    }
    else if ([typesOfShops isEqualToString:@"order"]) {
        //点餐
        viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"storeView"];
    }
    else {
        //小店 暂时和超市一样
        viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"newstoreView"];
    }
    
    [viewController setModalPresentationStyle:UIModalPresentationFullScreen];
    [self.navigationController pushViewController:viewController animated:YES];
    [SVProgressShow dismiss];
}
@end
