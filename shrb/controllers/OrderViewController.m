//
//  OrderViewController.m
//  Mercury
//
//  Created by IOS dev on 15/3/9.
//  Copyright (c) 2015年 GangXu. All rights reserved.
//

#import "OrderViewController.h"
#import "Const.h"
#import "NTButton.h"
#import "AppDelegate.h"


#import "OrderListTableViewController.h"
#import "RefundOrderViewController.h"

@interface OrderViewController ()
{
    UIImageView *_tabBarView;//自定义的覆盖原先的tarbar的控件
    NTButton * _previousBtn;//记录前一次选中的按钮
    
    UIView *_scrollView;
}
@end

@implementation OrderViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    self.title = @"我的订单";
    
    self.tabBar.hidden = YES;
    
    self.view.backgroundColor = [UIColor whiteColor];
    _tabBarView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20+44, screenWidth, 42)];
    _tabBarView.backgroundColor = [UIColor colorWithRed:250.0/255.0 green:239.0/255.0 blue:232.0/255.0 alpha:1];
    _tabBarView.userInteractionEnabled = YES;
    _tabBarView.backgroundColor = [UIColor whiteColor];
    
//    _tabBarView.layer.shadowOffset=CGSizeMake( 0, 0.5);
//    _tabBarView.layer.shadowOpacity=1.0;
//    _tabBarView.layer.shadowColor=[UIColor colorWithRed:249.0/255.0 green:72.0/255.0 blue:119.0/255.0 alpha:0.3].CGColor;

    [self.view addSubview:_tabBarView];
    
    _scrollView = [[UIView alloc] initWithFrame:CGRectMake(0, _tabBarView.frame.size.height-2, _tabBarView.frame.size.width/2, 2)];
    _scrollView.backgroundColor = shrbPink;
    [_tabBarView addSubview:_scrollView];
    
    UIStoryboard *userStoryboard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
    OrderListTableViewController *orderListTableViewController = [userStoryboard instantiateViewControllerWithIdentifier:@"orderlistView"];
    orderListTableViewController.hidesBottomBarWhenPushed = YES;
    [orderListTableViewController setModalPresentationStyle:UIModalPresentationFullScreen];
    
    UINavigationController *navi1 = [[UINavigationController alloc] initWithRootViewController:orderListTableViewController];
    navi1.tabBarController.hidesBottomBarWhenPushed = YES;
    
    RefundOrderViewController *refundOrderViewController = [userStoryboard instantiateViewControllerWithIdentifier:@"refundorderView"];
    [refundOrderViewController setModalPresentationStyle:UIModalPresentationFullScreen];
    refundOrderViewController.hidesBottomBarWhenPushed = YES;
    
    UINavigationController *navi2 = [[UINavigationController alloc] initWithRootViewController:refundOrderViewController];
    navi2.tabBarController.hidesBottomBarWhenPushed = YES;
    
    self.viewControllers = [NSArray arrayWithObjects:navi1,navi2, nil];
    
    [self creatButtonWithNormalName:@"订单记录" andSelectName:@"未评价高亮"  andIndex:0];
    [self creatButtonWithNormalName:@"退款记录" andSelectName:@"已评价高亮"  andIndex:1];
    if (_previousBtn == nil)
    {
        NTButton * button = _tabBarView.subviews[1];
        [self changeViewController:button];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
}
#pragma mark 创建一个按钮
- (void)creatButtonWithNormalName:(NSString *)normal andSelectName:(NSString *)selected  andIndex:(int)index{
    
    NTButton * customButton = [NTButton buttonWithType:UIButtonTypeCustom];
    customButton.tag = index;
    
    CGFloat buttonW = _tabBarView.frame.size.width / 2;
    CGFloat buttonH = _tabBarView.frame.size.height;
    
    customButton.frame = CGRectMake(buttonW * index, 0, buttonW, buttonH);
    
    [customButton setBackgroundImage:[UIImage imageNamed:@"未评价选中高亮"] forState:UIControlStateDisabled];
    //[customButton setBackgroundImage:[UIImage imageNamed:selected] forState:UIControlStateDisabled];
    
    [customButton setTitle:normal forState:UIControlStateNormal];
    [customButton setTitleColor:shrbPink forState:UIControlStateDisabled];
    [customButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    customButton.titleLabel.font=[UIFont systemFontOfSize:18];
    
    [customButton addTarget:self action:@selector(changeViewController:) forControlEvents:UIControlEventTouchDown];
    
    customButton.imageView.contentMode = UIViewContentModeCenter;
    
    [_tabBarView addSubview:customButton];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(_tabBarView.frame.size.width/2-3, 0, 6, _tabBarView.frame.size.height - 2.5)];
    imageView.backgroundColor = [UIColor whiteColor];
   // [_tabBarView addSubview:imageView];
}

#pragma mark 按钮被点击时调用
- (void)changeViewController:(NTButton *)sender
{
    self.selectedIndex = sender.tag; //切换不同控制器的界面
    
    sender.enabled = NO;
    
    if (_previousBtn != sender) {
        
        _previousBtn.enabled = YES;
        
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            if (sender.tag == 1) {
                _scrollView.layer.transform = CATransform3DMakeTranslation(_tabBarView.frame.size.width/2, 0, 0);
            }
            else {
                _scrollView.layer.transform = CATransform3DIdentity;
            }
        } completion:^(BOOL finished) {
            
        }];
    }
    _previousBtn = sender;
    
    self.selectedViewController.hidesBottomBarWhenPushed = YES;
    self.selectedViewController = self.viewControllers[sender.tag];
        
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
