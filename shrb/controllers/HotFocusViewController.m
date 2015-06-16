//
//  HotViewController.m
//  shrb
//  热点
//  Created by PayBay on 15/5/20.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "HotFocusViewController.h"
#import "HotFocusTableViewCell.h"
#import "UITableView+Wave.h"
#import "Const.h"
#import <CBZSplashView/CBZSplashView.h>

//#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface HotFocusViewController ()
{
    NSMutableArray *_data;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation HotFocusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //导航颜色
    self.navigationController.navigationBar.barTintColor = shrbPink;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.tabBarController.tabBar.selectedItem.selectedImage = [UIImage imageNamed:@"恋人_highlight.png"];
    
    self.tabBarController.tabBar.tintColor = shrbPink;
    
    UIImage *icon = [UIImage imageNamed:@"官方头像"];
    UIColor *color = shrbPink;
    CBZSplashView *splashView = [CBZSplashView splashViewWithIcon:icon backgroundColor:color];
    [self.view addSubview:splashView];
    [splashView startAnimation];
    
    self.tableView.tableFooterView =[[UIView alloc]init];
    
    _data = [[NSMutableArray alloc] initWithObjects:@"未成为会员",@"已是会员",@"已是会员",@"已是会员", nil];
    [self.tableView reloadDataAnimateWithWave:RightToLeftWaveAnimation];
    
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

#pragma mark - tableView dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimpleTableIdentifier = @"HotMembersTableViewCellIdentifier";
    HotFocusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (cell == nil) {
        cell = [[HotFocusTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
    }
    
    [cell.memberBtn setTitle:[_data objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    cell.hotImageView.image = [UIImage imageNamed:@"官方头像"];
    cell.tag = indexPath.row;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row ==0 ) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isMember"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isMember"];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isMember"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isMember"];
    }

    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"HotDetailView"];
    [viewController setModalPresentationStyle:UIModalPresentationFullScreen];
    
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.navigationController pushViewController:viewController animated:YES];
    });
}

@end
