//
//  CardAndCouponsViewController.m
//  shrb
//
//  Created by PayBay on 15/6/15.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "CardAndCouponsViewController.h"
#import "Const.h"
#import "KYCuteView.h"
#import "BFPaperButton.h"

@interface CardAndCouponsViewController ()
{
    KYCuteView *_badgeLabel;
}

@property (weak, nonatomic) IBOutlet BFPaperButton *couponsBtn;
//@property (weak, nonatomic) IBOutlet KYCuteView *badgeLabel;

@end

@implementation CardAndCouponsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBadgeLabel];
    [self initController];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)initBadgeLabel
{
    _badgeLabel = [[KYCuteView alloc]initWithPoint:CGPointMake((screenWidth-80)*0.5+15, -10) superView:self.couponsBtn];
    _badgeLabel.viscosity = 20;
    _badgeLabel.bubbleWidth = 25;
    _badgeLabel.bubbleColor = [UIColor redColor];
    [_badgeLabel setUp];
    [_badgeLabel addGesture];
    _badgeLabel.bubbleLabel.text = @"2";
    _badgeLabel.bubbleLabel.textColor = [UIColor whiteColor];
}

- (void)initController
{
    //导航颜色
    self.navigationController.navigationBar.barTintColor = shrbPink;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.tabBarController.tabBar.selectedItem.selectedImage = [UIImage imageNamed:@"寻觅_highlight"];
}

#pragma mark - 进入卡片View
- (IBAction)CardView:(id)sender {
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Card" bundle:nil];
    UIViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"cardTableViewController"];
    [viewController setModalPresentationStyle:UIModalPresentationFullScreen];
    
    [self.navigationController pushViewController:viewController animated:YES];
    
    
}

#pragma mark - 进入电子券View
- (IBAction)CouponsView:(id)sender {
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Card" bundle:nil];
    UIViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"couponsTableViewId"];
    [viewController setModalPresentationStyle:UIModalPresentationFullScreen];
    [self.navigationController pushViewController:viewController animated:YES];
    
}

@end
