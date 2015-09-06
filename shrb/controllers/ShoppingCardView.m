//
//  ShoppingCardView.m
//  shrb
//
//  Created by PayBay on 15/8/11.
//  Copyright © 2015年 PayBay. All rights reserved.
//

#import "ShoppingCardView.h"
#import "Const.h"
#import "SVProgressShow.h"
#import "StoreViewController.h"
#import "shrb-swift.h"
#import "OrdersViewController.h"

@implementation ShoppingNumLabel

- (void)setNum:(NSInteger)num
{
    _num = num;
    self.text = [NSString stringWithFormat:@"%ld",(long)num];
}
@end

@interface ShoppingCardView ()
{
    NSTimer *_timer;
}
@end

@implementation ShoppingCardView


@synthesize shoppingArray;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, 150, 42)];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.67];
        
        self.shoppingArray = [[NSMutableArray alloc] init];
        [self creatView];
        self.hidden = YES;
    
        [self showShoppingCard];
    }
    return self ;
}

- (void)creatView
{
    UIImageView *shoppingCardImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_float_shoppingcar_normal"]];
    shoppingCardImageView.frame = CGRectMake(10, 4, 34, 34);
    [self addSubview:shoppingCardImageView];
    
    self.shoppingNumLabel = [[ShoppingNumLabel alloc] initWithFrame:CGRectMake(10+34-5, 0, 22, 22)];
    self.shoppingNumLabel.layer.cornerRadius = 11;
    self.shoppingNumLabel.layer.masksToBounds = YES;
    self.shoppingNumLabel.textColor = [UIColor whiteColor];
    self.shoppingNumLabel.backgroundColor = shrbPink;
    self.shoppingNumLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.shoppingNumLabel];
    
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"订单将保留";
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor whiteColor];
    label.frame = CGRectMake(150-8-75, 4, 75, 21);
    [label sizeToFit];
    [self addSubview:label];
    
    
    self.countDownLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 75, 21)];
    self.countDownLabel.center = CGPointMake(label.center.x, label.center.y + 21);
    self.countDownLabel.font = [UIFont systemFontOfSize:15];
    self.countDownLabel.textAlignment = NSTextAlignmentCenter;
    self.countDownLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.countDownLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoPayView)];
    [self addGestureRecognizer:tap];
}

- (void)showShoppingCard
{
    if (self.hidden) {
        _countTime = [[NSUserDefaults standardUserDefaults] integerForKey:@"countTime"];
        if (_countTime < 1200 && _countTime > 0) {
            self.hidden = NO;
            [self countDown];
        }

    }
}

#pragma mark - 倒计时功能

- (void)countDown
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
    
}

- (void)timerFireMethod:(NSTimer *)timer
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *today = [NSDate date];//当前时间
    NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:--_countTime];
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *d = [calendar components:unitFlags fromDate:today toDate:fireDate options:0];//计算时间差
    self.countDownLabel.text = [NSString stringWithFormat:@"%ld:%ld",(long)[d minute],(long)[d second]];
    if (d.second <10) {
        self.countDownLabel.text = [NSString stringWithFormat:@"%ld:0%ld",(long)[d minute],(long)[d second]];
    }
    if (d.minute <10) {
        self.countDownLabel.text = [NSString stringWithFormat:@"0%ld:%ld",(long)[d minute],(long)[d second]];
    }
    if (d.minute <10 && d.second < 10) {
        self.countDownLabel.text = [NSString stringWithFormat:@"0%ld:0%ld",(long)[d minute],(long)[d second]];
    }
    
    if (d.minute == 0 && d.second == 0) {
        [_timer invalidate];
        self.hidden = YES;
        self.shoppingNumLabel.num = 0 ;
        _countTime = 1200;
        [SVProgressShow showInfoWithStatus:@"订单过期！"];
    }
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"countTime"];
    [[NSUserDefaults standardUserDefaults] setInteger:_countTime forKey:@"countTime"];
}

#pragma mark - 进入支付页面
- (void)gotoPayView
{
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"QRPay"];
    [[NSUserDefaults standardUserDefaults] setObject:@"HotFocusShoppingCard" forKey:@"QRPay"];
    
//    [[StoreViewController shareStoreViewController] gotoPayView];
    
//    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    OrdersViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"OrdersView"];
//    [viewController setModalPresentationStyle:UIModalPresentationFullScreen];
//    viewController.shoppingArray = self.shoppingArray;
//    [self.navigationController pushViewController:viewController animated:YES];
    
    UIViewController *activityViewController = nil;
    UIView* next = [self superview];
    UIResponder *nextResponder = [next nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        activityViewController = (UIViewController *)nextResponder;
    }
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    OrdersViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"OrdersView"];
    [viewController setModalPresentationStyle:UIModalPresentationFullScreen];
    viewController.shoppingArray = self.shoppingArray;
    [activityViewController.navigationController pushViewController:viewController animated:YES];
    
//    KYDrawerController *drawerController = (KYDrawerController *)activityViewController.navigationController.parentViewController;
//    [drawerController setDrawerState:0 animated:true];
}

@end
