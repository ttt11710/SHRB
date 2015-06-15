//
//  UserCenterTableViewController.m
//  shrb
//  我的首页
//  Created by PayBay on 15/6/8.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "UserCenterTableViewController.h"
#import "Const.h"

@interface UserCenterTableViewController ()
@property (weak, nonatomic) IBOutlet UIButton *meHeadBtn;

@end

@implementation UserCenterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //导航颜色
    self.navigationController.navigationBar.barTintColor = shrbPink;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.tabBarController.tabBar.selectedItem.selectedImage = [UIImage imageNamed:@"我的_highlight.png"];
    
    //删除多余线
    self.tableView.tableFooterView =[[UIView alloc]init];
    
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

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section == 0?100:60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
    return section == 0?1:section==1?2:3;
}

- (IBAction)changeMeHear:(id)sender {
    
    
}


@end
