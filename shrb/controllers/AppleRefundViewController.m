//
//  AppleRefundViewController.m
//  shrb
//
//  Created by PayBay on 15/8/21.
//  Copyright © 2015年 PayBay. All rights reserved.
//

#import "AppleRefundViewController.h"
#import "Const.h"
#import "AppleRefundTableViewCell.h"
#import "IQActionSheetPickerView.h"
#import "SuccessAppleRefundViewController.h"

@interface AppleRefundViewController () <IQActionSheetPickerViewDelegate>
{
    NSMutableArray *_pickMutableArray;;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation AppleRefundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"申请退款";
    
    [self initData];
    [self initTableView];
}

- (void)initData
{
    _pickMutableArray = [[NSMutableArray alloc] initWithObjects:@"  退货原因",@"  商品破损",@"  商品错发/漏发",@"  商品质量问题",@"  未按约定时间发货", nil];
}

- (void)initTableView
{
    //去除tableview顶部留白
    self.automaticallyAdjustsScrollViewInsets = false;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - tableView dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 580;
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimpleTableIdentifier = @"cellId";
    AppleRefundTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    cell.returnGoodsReasonLabel.text = @"  退货原因";
    cell.callBack = ^(NSString *money){
        
        NSLog(@"提交请求%@",money);
        
    };
    
    cell.returnCallBack = ^(NSString *string){
        
        IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"Single Picker" delegate:self];
        [picker setTag:indexPath.row];
        [picker setTitlesForComponenets:@[_pickMutableArray]];
        [picker selectRow:0 inComponent:0 animated:YES];
        [picker show];
  
    };
    return cell;
}

-(void)actionSheetPickerView:(IQActionSheetPickerView *)pickerView didSelectTitles:(NSArray *)titles
{
    AppleRefundTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[[self.tableView indexPathsForVisibleRows] objectAtIndex:0]];
    cell.returnGoodsReasonLabel.text = titles[0];
}

- (IBAction)appleRufundBtnPressed:(id)sender {
    
    SuccessAppleRefundViewController *successAppleRefundViewController = [[SuccessAppleRefundViewController alloc] init];
    [self.navigationController pushViewController:successAppleRefundViewController animated:YES];
}

@end
