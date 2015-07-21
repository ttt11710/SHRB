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
#import "BecomeMemberView.h"
#import "CardTableViewCell.h"
#import "NewCardDetailViewController.h"
#import "NSString+AttributedStyle.h"


static OrdersViewController *g_OrdersViewController = nil;

@interface OrdersViewController ()
{
    NSMutableArray *_data;
    TNCheckBoxGroup *_loveGroup;
    UITapGestureRecognizer *_tap;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *showOtherPayBtn;

@end

@implementation OrdersViewController

@synthesize isMember;

+ (OrdersViewController *)shareOrdersViewController
{
    return g_OrdersViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    g_OrdersViewController = self;
    
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
    self.tableView.backgroundColor = shrbTableViewColor;
    
    [self.tableView reloadDataAnimateWithWave:RightToLeftWaveAnimation];
}

#pragma mark - 添加手势
- (void)addTap
{
    if (_tap == nil) {
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        self.view.userInteractionEnabled = YES;
        [self.view addGestureRecognizer:_tap];
    }
}

#pragma mark - 去除手势
- (void)removeTap
{
    [self.view removeGestureRecognizer:_tap];
    _tap = nil;
}

#pragma mark - 更新tableView
- (void)UpdateTableView
{
    isMember = [[NSUserDefaults standardUserDefaults] boolForKey:@"isMember"];
    
    UINavigationController *navController = self.navigationController;
    [self.navigationController popViewControllerAnimated:NO];
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    OrdersViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"OrdersView"];
    viewController.isMember = isMember;
    [viewController setModalPresentationStyle:UIModalPresentationFullScreen];
    
    [navController pushViewController:viewController animated:NO];

}

#pragma mark - tableView dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [_data count]+3) {
        return 200;
    }
    else if (indexPath.row <= [_data count]+1) {
        return 68;
    }
    else {
        return isMember?160:120;
    }
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isMember) {
        _showOtherPayBtn.hidden = YES;
        return [_data count]+3;
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
                
                NSString *string = @"会员价：30元  原价：40元";
                
                cell.priceLabel.attributedText = [string createrAttributedStringWithStyles:
                                                  @[
                                                    [ForeGroundColorStyle withColor:[UIColor redColor] range:NSMakeRange(4, 2)],
                                                    [ForeGroundColorStyle withColor:[UIColor redColor] range:NSMakeRange(12, 2)],
                                                    [FontStyle withFont:[UIFont systemFontOfSize:18.f] range:NSMakeRange(4, 2)],
                                                    [FontStyle withFont:[UIFont systemFontOfSize:18.f] range:NSMakeRange(12, 2)]
                                                    ]];

                
                
                //
                HJCAjustNumButton3 *numbutton = [[HJCAjustNumButton3 alloc] init];
                numbutton.frame = CGRectMake(screenWidth-85, 15, 75, 25);
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
            cell.settlementLable.hidden = YES;
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
                cell.settlementLable.hidden = NO;
               // cell.checkImageView.hidden = NO;
               // cell.couponLabel.hidden = NO;
                cell.checkImageView.hidden = YES;
                cell.couponLabel.hidden = YES;
                cell.ruleTextView.hidden = YES;
                cell.settlementLable.text = @"总价：500RMB\n会员价：350RMB";
                cell.couponLabel.font = [UIFont systemFontOfSize:14];
                cell.couponLabel.text = @"100RMB电子券";
                
                
                
                TNImageCheckBoxData *manData = [[TNImageCheckBoxData alloc] init];
                manData.identifier = @"man";
                manData.labelText = @"2张电子券 100RMB";
                manData.labelColor = [UIColor colorWithRed:78.0/255.0 green:78.0/255.0 blue:78.0/255.0 alpha:1];
                manData.labelFont = [UIFont systemFontOfSize:14.0];
                manData.checked = YES;
                manData.checkedImage = [UIImage imageNamed:@"checked"];
                manData.uncheckedImage = [UIImage imageNamed:@"unchecked"];
                
                if (_loveGroup == nil) {
                    _loveGroup = [[TNCheckBoxGroup alloc] initWithCheckBoxData:@[manData] style:TNCheckBoxLayoutVertical];
                    [_loveGroup create];
    
                    CGFloat x = IsiPhone4s? screenWidth-_loveGroup.frame.size.width:screenWidth-24 -_loveGroup.frame.size.width;
                  
                    _loveGroup.position = CGPointMake(x, 40);
                    
                    [cell addSubview:_loveGroup];
                }
                
                
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loveGroupChanged:) name:GROUP_CHANGED object:_loveGroup];
                
            }
            else
            {
                if (isMember) {
                    
                    static NSString *SimpleTableIdentifier = @"CardTableViewCellIdentifier";
                    CardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
                    if (cell == nil) {
                        cell = [[CardTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
                    }
                    //cell 选中方式
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.accessoryType = UITableViewCellAccessoryNone;
                   // cell.model = self.dataArray[indexPath.row];
                    
                    return cell;
                }
                else {
                    cell.settlementLable.hidden = YES;
                    cell.checkImageView.hidden = YES;
                    cell.couponLabel.hidden = YES;
                    cell.ruleTextView.hidden = NO;
                    cell.ruleTextView.textAlignment = NSTextAlignmentLeft;
                    cell.ruleTextView.text = @"会员好处：成为会员可以享受会员折扣，付款可直接用会员卡，并有更多优惠哦！\n\n会员规则:会员卡充值后不可以取现，可以注销，同时扣除手续费5%。";
                }
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
        
        [cell.buttonModel setTitle:@"会员注册" forState:UIControlStateNormal];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [_data count]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (isMember) {
        //会员卡详情页面
        if (indexPath.row == [_data count]+2) {
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Card" bundle:nil];
            NewCardDetailViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"CardDetailView"];
            [viewController setModalPresentationStyle:UIModalPresentationFullScreen];
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
}

#pragma mark - 键盘消失
-(void)tap {
    
    [[BecomeMemberView shareBecomeMemberView] textFieldResignFirstResponder];
    
    [self removeTap];
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

#pragma mark - 电子券打钩
- (void)loveGroupChanged:(NSNotification *)notification {
    
    NSLog(@"Checked checkboxes %@", _loveGroup.checkedCheckBoxes);
    NSLog(@"Unchecked checkboxes %@", _loveGroup.uncheckedCheckBoxes);
    
}
@end
