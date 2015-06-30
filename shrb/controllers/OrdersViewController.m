//
//  ShoppingCartViewController.m
//  shrb
//  购物车
//  Created by PayBay on 15/5/20.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "OrdersViewController.h"
#import "OrdersTableViewCell.h"
#import "PayViewController.h"
#import "ButtonTableViewCell.h"
#import "UITableView+Wave.h"
#import "Const.h"
#import "HJCAjustNumButton3.h"
#import "TNImageCheckBoxData.h"
#import "TNCheckBoxGroup.h"

@interface OrdersViewController ()
{
    NSMutableArray *_data;
    TNCheckBoxGroup *_loveGroup;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *showOtherPayBtn;

@end

@implementation OrdersViewController

@synthesize isMember;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    isMember = [[NSUserDefaults standardUserDefaults] boolForKey:@"isMember"];
    [self.tableView reloadData];
}

- (void)initData
{
    _data = [[NSMutableArray alloc] initWithObjects:@"冰拿铁",@"卡布奇诺", nil];
}

- (void)initTableView
{
    //删除多余线
    self.tableView.tableFooterView =[[UIView alloc]init];
    self.tableView.backgroundColor = HexRGB(0xF1EFEF);
    
    [self.tableView reloadDataAnimateWithWave:RightToLeftWaveAnimation];
}

#pragma mark - tableView dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [_data count]+3) {
        return 46;
    }
    return indexPath.row <= [_data count]+1?80:100;
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isMember) {
        _showOtherPayBtn.hidden = YES;
        return [_data count]+2;
    }
    return [_data count]+4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row <= [_data count]+2) {
        static NSString *SimpleTableIdentifier = @"ShoppingCartTableViewCellIdentifier";
        OrdersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (cell == nil) {
            cell = [[OrdersTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
        }
        
        if (indexPath.row <= [_data count]) {
            if (indexPath.row < [_data count]) {
                cell.tradeNameLabel.text = [_data objectAtIndex:indexPath.row];
                cell.couponsImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",[_data objectAtIndex:indexPath.row]]];
                cell.priceLabel.text = @"会员价：30元  原价：40元";
                
                //
                HJCAjustNumButton3 *numbutton = [[HJCAjustNumButton3 alloc] init];
                numbutton.frame = CGRectMake(screenWidth-90, 30, 80, 30);
                // 内容更改的block回调
                numbutton.callBack = ^(NSString *currentNum){
                    NSLog(@"%@", currentNum);
                    NSLog(@"%ld",(long)indexPath.row);
                };
                
                // 加到父控件上
                [cell addSubview:numbutton];

            }
            else  {
                cell.tradeNameLabel.text = @"添加";
                cell.couponsImageView.image = [UIImage imageNamed:@"上传相片"];
                cell.priceLabel.text = @"";
            }
            cell.couponsImageView.hidden = NO;
            cell.tradeNameLabel.hidden = NO;
            cell.priceLabel.hidden = NO;
            cell.settlementTextView.hidden = YES;
            cell.checkImageView.hidden = YES;
            cell.couponLabel.hidden = YES;
            cell.ruleTextView.hidden = YES;
            
        }
        else
        {
            cell.couponsImageView.hidden = YES;
            cell.tradeNameLabel.hidden = YES;
            cell.priceLabel.hidden = YES;
            if (indexPath.row == [_data count]+1)
            {
                cell.settlementTextView.hidden = NO;
               // cell.checkImageView.hidden = NO;
               // cell.couponLabel.hidden = NO;
                cell.checkImageView.hidden = YES;
                cell.couponLabel.hidden = YES;
                cell.ruleTextView.hidden = YES;
                cell.settlementTextView.text = @"总价：500RMB\n会员价：350RMB";
                cell.couponLabel.font = [UIFont systemFontOfSize:14];
                cell.couponLabel.text = @"100RMB电子券";
                
                TNImageCheckBoxData *manData = [[TNImageCheckBoxData alloc] init];
                manData.identifier = @"man";
                manData.labelText = @"100RMB电子券";
                manData.checked = YES;
                manData.checkedImage = [UIImage imageNamed:@"checked"];
                manData.uncheckedImage = [UIImage imageNamed:@"unchecked"];
                
                _loveGroup = [[TNCheckBoxGroup alloc] initWithCheckBoxData:@[manData] style:TNCheckBoxLayoutVertical];
                [_loveGroup create];
                _loveGroup.position = CGPointMake(screenWidth-_loveGroup.frame.size.width-5, 40);
                
                [cell addSubview:_loveGroup];
                
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loveGroupChanged:) name:GROUP_CHANGED object:_loveGroup];
                
            }
            else
            {
                cell.settlementTextView.hidden = YES;
                cell.checkImageView.hidden = YES;
                cell.couponLabel.hidden = YES;
                cell.ruleTextView.hidden = NO;
                cell.ruleTextView.textAlignment = NSTextAlignmentLeft;
                cell.ruleTextView.text = @"会员好处：范德萨发几款的结果看见啊\n\n会员规则:芭芭拉回复将恢复快热好可恶";
            }
            
        }
        return cell;
    }
    else
    {
        static NSString *SimpleTableIdentifier = @"ButtonTableViewCellIdentifier";
        ButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (cell == nil) {
            cell = [[ButtonTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
        }
        
        [cell.buttonModel setTitle:@"注册" forState:UIControlStateNormal];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [_data count]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma  mark - storyboard传值
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    PayViewController *payViewController = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"memberPayidentifier"]) {
        payViewController.isMemberPay = YES;
    }
    else if([segue.identifier isEqualToString:@"othersPayidentifier"])
    {
        payViewController.isMemberPay = NO;
    }
}

- (void)loveGroupChanged:(NSNotification *)notification {
    
    NSLog(@"Checked checkboxes %@", _loveGroup.checkedCheckBoxes);
    NSLog(@"Unchecked checkboxes %@", _loveGroup.uncheckedCheckBoxes);
    
}

@end
