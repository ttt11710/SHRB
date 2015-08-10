//
//  SuperOrderViewController.m
//  shrb
//
//  Created by PayBay on 15/8/6.
//  Copyright © 2015年 PayBay. All rights reserved.
//

#import "SuperOrderViewController.h"
#import "UITableView+Wave.h"
#import "Const.h"
#import "OrdersTableViewCell.h"
#import "NSString+AttributedStyle.h"
#import <BFPaperButton.h>

@interface SuperOrderViewController ()
{
    NSMutableArray *_data;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet BFPaperButton *submitOrderBtn;

@end

@implementation SuperOrderViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initTableView];
    
    self.submitOrderBtn.backgroundColor = shrbPink;
}

- (void)initData
{
    _data = [[NSMutableArray alloc] initWithObjects:@"纯色拼接修身外套",@"简约拉链夹克",@"纯棉9分直筒裤",@"男士休闲羊毛西服", nil];
}

- (void)initTableView
{
    //删除多余线
    self.tableView.tableFooterView =[[UIView alloc]init];
    self.tableView.backgroundColor = shrbTableViewColor;
    
    [self.tableView reloadDataAnimateWithWave:RightToLeftWaveAnimation];
}

#pragma mark - tableView dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 44;
    }
    else if (indexPath.row <= [_data count]) {
        return 68;
    }
    else {
        return 100;
    }
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_data count]+3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *simpleTableIdentifier = @"cellId";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
        }
        cell.textLabel.text = [NSString stringWithFormat:@"共%lu件商品",(unsigned long)[_data count]];
        cell.textLabel.textColor = shrbText;
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        
        return cell;
    }
    else if (indexPath.row <= [_data count]) {
        static NSString *simpleTableIdentifier = @"ShoppingCartTableViewCellIdentifier";
        OrdersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (cell == nil) {
            cell = [[OrdersTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
        }
        
        cell.couponsImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",[_data objectAtIndex:indexPath.row-1]]];
        cell.tradeNameLabel.text = [_data objectAtIndex:indexPath.row-1];
        NSString *string = @"会员价：30元  原价：40元";
        
        cell.priceLabel.attributedText = [string createrAttributedStringWithStyles:
                                          @[
                                            [ForeGroundColorStyle withColor:[UIColor redColor] range:NSMakeRange(4, 2)],
                                            [ForeGroundColorStyle withColor:[UIColor redColor] range:NSMakeRange(12, 2)],
                                            [FontStyle withFont:[UIFont systemFontOfSize:18.f] range:NSMakeRange(4, 2)],
                                            [FontStyle withFont:[UIFont systemFontOfSize:18.f] range:NSMakeRange(12, 2)]
                                            ]];
        
        cell.numTextField.text = @"1";
        
        return cell;
    }
    
    else if (indexPath.row == [_data count]+2)
    {
        static NSString *simpleTableIdentifier = @"blankcellId";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
        }
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width)];
        cell.backgroundColor = shrbTableViewColor;
        return cell;
    }
    else {
        static NSString *simpleTableIdentifier = @"orderMoneyId";
        OrdersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (cell == nil) {
            cell = [[OrdersTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
        }
        
        cell.totalLabel.text = @"总价:450元";
        cell.memberTotalLabel.text = @"会员价:350元";
        
        TNImageCheckBoxData *manData = [[TNImageCheckBoxData alloc] init];
        manData.identifier = @"man";
        manData.labelText = @"100RMB电子券";
        manData.labelColor = [UIColor colorWithRed:78.0/255.0 green:78.0/255.0 blue:78.0/255.0 alpha:1];
        manData.labelFont = [UIFont systemFontOfSize:14.0];
        manData.checked = YES;
        manData.checkedImage = [UIImage imageNamed:@"checked"];
        manData.uncheckedImage = [UIImage imageNamed:@"unchecked"];
        
        if ([cell.checkCouponsView.checkedCheckBoxes count] == 0 ) {
            [cell.checkCouponsView myInitWithCheckBoxData:@[manData] style:TNCheckBoxLayoutVertical];
            [cell.checkCouponsView create];
        }
        
        return cell;

    }
}


@end
