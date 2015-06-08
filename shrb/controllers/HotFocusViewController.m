//
//  HotViewController.m
//  shrb
//
//  Created by PayBay on 15/5/20.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "HotFocusViewController.h"
#import "HotFocusTableViewCell.h"

@interface HotFocusViewController ()
{
    NSMutableArray *_data;
}

@end

@implementation HotFocusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _data = [[NSMutableArray alloc] initWithObjects:@"未成为会员",@"已是会员",@"已是会员",@"已是会员", nil];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    HotFocusTableViewCell *cell =(HotFocusTableViewCell *)sender;
    NSLog(@"cell.tag = %ld",(long)cell.tag);
    if (cell.tag < 1) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isMember"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isMember"];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isMember"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isMember"];
    }
}

//BOOL isMemberPay =  [[NSUserDefaults standardUserDefaults] objectForKey:@"isMember"];
@end
