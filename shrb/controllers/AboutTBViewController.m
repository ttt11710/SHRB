//
//  AboutTBViewController.m
//  shrb
//
//  Created by PayBay on 15/9/2.
//  Copyright © 2015年 PayBay. All rights reserved.
//

#import "AboutTBViewController.h"
#import "Const.h"

@interface AboutTBViewController () <UITableViewDataSource,UITableViewDelegate>

@end

@implementation AboutTBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"关于通宝";
    
    [self creatTableView];
    
}

- (void)creatTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 842;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimpleTableIdentifier = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
    }
    //cell 选中方式
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"aboutTB"]];
    imageView.frame = CGRectMake(0, 0, screenWidth, 842);
    [cell.contentView addSubview:imageView];
    
    return cell;
}

@end
