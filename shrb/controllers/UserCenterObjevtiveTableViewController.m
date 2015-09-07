//
//  UserCenterTableViewController.m
//  shrb
//  我的首页
//  Created by PayBay on 15/6/8.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserCenterObjevtiveTableViewController.h"
#import "SVProgressShow.h"
#import "Const.h"
#import "OrderViewController.h"
#import "TBUser.h"
#import <UIImageView+WebCache.h>
#import "AboutTBViewController.h"
#import "CollectObjectiveTableViewController.h"

@interface UserCenterObjevtiveTableViewController ()

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UILabel *memberNumLabel;
@property (weak, nonatomic) IBOutlet UIImageView *memberImageView;

@property (nonatomic,strong)AFHTTPRequestOperationManager *requestOperationManager;

@end

@implementation UserCenterObjevtiveTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatReq];
    [self initController];
    [self initTableView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBarHidden = NO;
    
    [self loginState];

}


- (void)loginState
{
    NSString *url2=[baseUrl stringByAppendingString:@"/user/v1.0/info?"];
    [self.requestOperationManager POST:url2 parameters:@{@"userId":[TBUser currentUser].userId,@"token":[TBUser currentUser].token} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"user info operation = %@ JSON: %@", operation,responseObject);
        
        switch ([responseObject[@"code"] integerValue]) {
            case 404:
                [TBUser setCurrentUser:nil];
                self.loginBtn.hidden = NO;
                self.memberImageView.userInteractionEnabled = NO;
                self.memberNumLabel.hidden = YES;
                break;
            case 200: {
                self.memberImageView.userInteractionEnabled = YES;
                self.loginBtn.hidden = YES;
                [self.memberImageView sd_setImageWithURL:[NSURL URLWithString:[TBUser currentUser].imgUrl] placeholderImage:[UIImage imageNamed:@"默认女头像"]];
                self.memberNumLabel.hidden = NO;
                self.memberNumLabel.text = [NSString stringWithFormat:@"通包号:%@",[TBUser currentUser].userId];
            }
                break;
                
            default:
                break;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:++++%@",error.localizedDescription);
    }];

}
- (void)viewDidLayoutSubviews
{
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)creatReq
{
    self.requestOperationManager=[AFHTTPRequestOperationManager manager];
    
    self.requestOperationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    AFJSONResponseSerializer *serializer=[AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    self.requestOperationManager.responseSerializer=serializer;
    
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setTimeoutInterval:10*60];
    self.requestOperationManager.requestSerializer=requestSerializer;
}

- (void)initController
{
    //导航颜色
    self.navigationController.navigationBar.barTintColor = shrbPink;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.tabBarController.tabBar.selectedItem.selectedImage = [UIImage imageNamed:@"我的_highlight"];
}

- (void)initTableView
{
    //删除多余线
    self.tableView.tableFooterView =[[UIView alloc]init];
    
    self.tableView.backgroundColor = shrbTableViewColor;
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section == 0? 130:44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
        case 3:
            return 1;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 3;
            break;
        default:
            return 0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0? 0:8;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //基本信息
    if (indexPath.section == 0)
    {
        [SVProgressShow showWithStatus:@"查询状态中..."];
        NSString *url2=[baseUrl stringByAppendingString:@"/user/v1.0/info?"];
        [self.requestOperationManager POST:url2 parameters:@{@"userId":[TBUser currentUser].userId,@"token":[TBUser currentUser].token} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"user info operation = %@ JSON: %@", operation,responseObject);
            
            switch ([responseObject[@"code"] integerValue]) {
                case 404:
                    [TBUser setCurrentUser:nil];
                    self.loginBtn.hidden = NO;
                    self.memberImageView.userInteractionEnabled = NO;
                    self.memberNumLabel.hidden = YES;
                    [SVProgressShow showInfoWithStatus:@"请重新登录!"];
                    break;
                case 200: {
                    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
                    UIViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"infoView"];
                    [viewController setModalPresentationStyle:UIModalPresentationFullScreen];
                    [self.navigationController pushViewController:viewController animated:YES];
                    [SVProgressShow dismiss];
                }
                    break;
                    
                default:
                    break;
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error:++++%@",error.localizedDescription);
            [SVProgressShow showErrorWithStatus:@"查询失败!"];
        }];
    }
    else if (indexPath.section == 1)
    {
        //我的订单
        if (indexPath.row == 0) {
            
//            if (!isLogin) {
//            
//                [SVProgressShow showInfoWithStatus:@"登录账号才能查看我的订单"];
//                
//                return ;
//            }
        
            OrderViewController *orderViewController = [[OrderViewController alloc] init];
            orderViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:orderViewController animated:YES];
        }
        //我的收藏
        else if (indexPath.row == 1) {
            if ([TBUser currentUser].token.length == 0) {
                
                [SVProgressShow showInfoWithStatus:@"登录账号才能查看我的收藏"];
                
                return ;
            }

            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
            UIViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"collectObjectiveView"];
            [viewController setModalPresentationStyle:UIModalPresentationFullScreen];
            viewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:viewController animated:YES];
    
        }
    }
    else  if (indexPath.section == 2) {
        //帮助中心
        if (indexPath.row == 0) {
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
            UIViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"helpCenterView"];
            [viewController setModalPresentationStyle:UIModalPresentationFullScreen];
            viewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:viewController animated:YES];
        }
        //客服
        else if (indexPath.row == 1) {
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
            UIViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"shrbServiceView"];
            [viewController setModalPresentationStyle:UIModalPresentationFullScreen];
            viewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:viewController animated:YES];
        }
        //关于通宝
        else {
            AboutTBViewController *aboutTBViewController = [[AboutTBViewController alloc] init];
            aboutTBViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:aboutTBViewController animated:YES];
        }
    }
    else {
        //设置
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
        UIViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"settingView"];
        [viewController setModalPresentationStyle:UIModalPresentationFullScreen];
        viewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}


#pragma mark - 登录按钮
- (IBAction)loginBtnPressed:(id)sender {
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    UIViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"NewLoginView"];
    [viewController setModalPresentationStyle:UIModalPresentationFullScreen];
    [viewController setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
