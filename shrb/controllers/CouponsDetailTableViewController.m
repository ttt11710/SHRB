//
//  CouponsDetailTableViewController.m
//  shrb
//
//  Created by PayBay on 15/6/8.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "CouponsDetailTableViewController.h"
#import "CouponsDetailTableViewCell.h"
#import "StoreViewController.h"

@interface CouponsDetailTableViewController ()
{
    NSMutableArray *_data;
}
@end

@implementation CouponsDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _data = [[NSMutableArray alloc] initWithObjects:@"1",@"2",@"3",@"4", nil];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_data count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *SimpleTableIdentifier = @"CouponsDetailTableViewCellIdentifier";
    CouponsDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    if (cell == nil) {
        cell = [[CouponsDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:SimpleTableIdentifier];
    }
    
    cell.couponsImageView.image = [UIImage imageNamed:@"官方头像"];
    cell.moneyLabel.text = @"金额：30RMB";
    cell.expirationDateLabel.text = @"截止日期：2016.1.1";
    cell.userCouponsBtn.tag = indexPath.row;
    return cell;
}
- (IBAction)userCouponsBtnPressed:(UIButton *)sender {
    NSLog(@"sender.tag = %ld",(long)sender.tag);
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    StoreViewController *storeViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"storeView"];
    [storeViewController setModalPresentationStyle:UIModalPresentationFullScreen];
    [self.navigationController pushViewController:storeViewController animated:YES];
}

@end
