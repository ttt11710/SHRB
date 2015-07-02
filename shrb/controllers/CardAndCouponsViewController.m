//
//  CardAndCouponsViewController.m
//  shrb
//
//  Created by PayBay on 15/6/15.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "CardAndCouponsViewController.h"
#import "Const.h"

@interface CardAndCouponsViewController ()

@end

@implementation CardAndCouponsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
