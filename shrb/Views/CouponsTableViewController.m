//
//  CouponsTableViewController.m
//  shrb
//  电子券
//  Created by PayBay on 15/5/20.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "CouponsTableViewController.h"
#import "CouponsTableViewCell.h"
#import "UITableView+Wave.h"
#import "Const.h"

@interface CouponsTableViewController ()
{
    NSMutableArray *_data;
}
@end

@implementation CouponsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView =[[UIView alloc]init];
    self.tableView.backgroundColor = HexRGB(0xF1EFEF);
    
    _data = [[NSMutableArray alloc] initWithObjects:@"1",@"2",@"3",@"4", nil];
    
    [self.tableView reloadDataAnimateWithWave:RightToLeftWaveAnimation];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [_data count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *SimpleTableIdentifier = @"couponsTableViewCellIdentifier";
    CouponsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (cell == nil) {
        cell = [[CouponsTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:SimpleTableIdentifier];
    }
    
    cell.couponsImageView.image = [UIImage imageNamed:@"官方头像"];
    cell.moneyLabel.text = @"总金额：100RMB";
    cell.numberLabel.text = [NSString stringWithFormat:@"%@张",[_data objectAtIndex:indexPath.row]];
    return cell;
}



@end
