//
//  HotDetailViewController.m
//  shrb
//
//  Created by PayBay on 15/5/19.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "HotDetailViewController.h"
#import "HotDetailTableViewCell.h"

@interface HotDetailViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation HotDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - tableView dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 700;
}


#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimpleTableIdentifier = @"HotDetailTableCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

@end
