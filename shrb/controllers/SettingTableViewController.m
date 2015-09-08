//
//  SettingTableViewController.m
//  shrb
//
//  Created by PayBay on 15/6/16.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "SettingTableViewController.h"
#import "Const.h"
#import "SVProgressShow.h"
#import "TBUser.h"

@interface SettingTableViewController ()

@property (nonatomic,strong)AFHTTPRequestOperationManager *requestOperationManager;

@end

@implementation SettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatReq];
    [self initTableView];
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

- (void)initTableView
{
    self.tableView.backgroundColor = shrbTableViewColor;
    //删除多余线
    self.tableView.tableFooterView =[[UIView alloc]init];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.row == 2 || indexPath.row == 7)?8: 64;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 9;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
        UIViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"updatePayPass"];
        [viewController setModalPresentationStyle:UIModalPresentationFullScreen];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    if (indexPath.row == 1) {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
        UIViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"updatePass"];
        [viewController setModalPresentationStyle:UIModalPresentationFullScreen];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
    if(indexPath.row == 8)
    {
        NSString *url=[baseUrl stringByAppendingString:@"/user/v1.0/logout?"];
        [self.requestOperationManager POST:url parameters:@{@"userId":[TBUser currentUser].userId,@"token":[TBUser currentUser].token} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"logout operation = %@ JSON: %@", operation,responseObject);
            
            switch ([responseObject[@"code"] integerValue]) {
                case 200:
                {
                    [TBUser setCurrentUser:nil];
                    
                    [SVProgressShow showSuccessWithStatus:@"注销成功!"];
                    [self.navigationController popViewControllerAnimated:YES];
                    [SVProgressShow dismiss];
                }
                    break;
                case 404:
                case 500:
                case 503:
                    [SVProgressShow showErrorWithStatus:responseObject[@"msg"]];
                    break;
                    
                default:
                    break;
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error:++++%@",error.localizedDescription);
        }];
    }
    
}

@end
