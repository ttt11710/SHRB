//
//  UserCenterTableViewController.m
//  shrb
//
//  Created by PayBay on 15/6/8.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "UserCenterTableViewController.h"

@interface UserCenterTableViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *meImageView;

@end

@implementation UserCenterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.meImageView.image = [UIImage imageNamed:@"官方头像"];
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



@end
