//
//  PayViewController.m
//  shrb
//  支付界面
//  Created by PayBay on 15/5/20.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "PayViewController.h"
#import "CompletePayViewController.h"
#import "BFPaperButton.h"
#import "SVProgressShow.h"
#import "Const.h"
#import "DeskNumTableViewCell.h"
#import "PayOrderTableViewCell.h"
#import "MemberPayTableViewCell.h"
#import "OtherPayTableViewCell.h"
#import "TNCheckBoxData.h"
#import "TNCheckBoxGroup.h"
#import "CompleteVoucherViewController.h"

@interface PayViewController ()
{
    TNCheckBoxGroup *_loveGroup;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet BFPaperButton *makeSurePayBtn;

@property (nonatomic,strong) NSMutableArray * dataArray;

@end

@implementation PayViewController

@synthesize isMemberPay;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = [[NSMutableArray alloc] initWithObjects:
                      @{
                        @"tradeImage" : @"提拉米苏",
                        @"tradeName" : @"提拉米苏",
                        @"amount":@"10",
                        @"money":@"450",
                        },
                      @{
                        @"tradeImage" : @"蜂蜜提子可颂",
                        @"tradeName" : @"蜂蜜提子可颂",
                        @"amount":@"2",
                        @"money":@"60",
                        },
                      @{
                        @"tradeImage" : @"芝士可颂",
                        @"tradeName" : @"芝士可颂",
                        @"amount":@"1",
                        @"money":@"25",
                        
                        },
                      nil];
    //删除底部多余横线
    self.tableView.tableFooterView =[[UIView alloc]init];
    self.tableView.backgroundColor = HexRGB(0xF1EFEF);
}

- (void)viewDidLayoutSubviews {
    
    if (!self.isMemberPay)
    {
        self.tableView.frame = CGRectMake(0, 20+44, screenWidth, screenHeight - 20 - 44);
    }
}

#pragma mark - tableView dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 44;
    }
    else if (indexPath.row == [self.dataArray count]+1){
        
            return self.isMemberPay? 120:160;
    }
    else {
        return 60;
    }
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count]+2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
        }
        cell.textLabel.text = [NSString stringWithFormat:@"共%d件商品",[self.dataArray count]];
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        cell.textLabel.textColor = HexRGB(0x4e4e4e);
        
        return cell;
    }
    
    else if (indexPath.row == [self.dataArray count]+1) {
        
        if (self.isMemberPay) {
            
            self.makeSurePayBtn.hidden = NO;
            
            static NSString *SimpleTableIdentifier = @"MemberPayTableViewCellIdentifier";
            MemberPayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            if (cell == nil) {
                cell = [[MemberPayTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
            }
            
            cell.checkLabel.hidden = YES;
            TNImageCheckBoxData *manData = [[TNImageCheckBoxData alloc] init];
            manData.identifier = @"man";
            manData.labelText = @"2张电子券 100RMB";
            manData.checked = YES;
            manData.checkedImage = [UIImage imageNamed:@"checked"];
            manData.uncheckedImage = [UIImage imageNamed:@"unchecked"];
            
            _loveGroup = [[TNCheckBoxGroup alloc] initWithCheckBoxData:@[manData] style:TNCheckBoxLayoutVertical];
            [_loveGroup create];
            
            CGFloat x = IsiPhone4s? screenWidth-_loveGroup.frame.size.width:screenWidth-24 -_loveGroup.frame.size.width;
            
            _loveGroup.position = CGPointMake(x, 4);
            
            [cell addSubview:_loveGroup];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loveGroupChanged:) name:GROUP_CHANGED object:_loveGroup];
            
            return cell;
        }
        else {
            
            self.makeSurePayBtn.hidden = YES;
            
            static NSString *SimpleTableIdentifier = @"OtherPayTableViewCellIdentifier";
            OtherPayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            if (cell == nil) {
                cell = [[OtherPayTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
            }
            cell.checkLabel.hidden = YES;
            TNImageCheckBoxData *manData = [[TNImageCheckBoxData alloc] init];
            manData.identifier = @"man";
            manData.labelText = @"2张电子券 100RMB";
            manData.checked = YES;
            manData.checkedImage = [UIImage imageNamed:@"checked"];
            manData.uncheckedImage = [UIImage imageNamed:@"unchecked"];
            
            _loveGroup = [[TNCheckBoxGroup alloc] initWithCheckBoxData:@[manData] style:TNCheckBoxLayoutVertical];
            [_loveGroup create];
            
            CGFloat x = IsiPhone4s? screenWidth-_loveGroup.frame.size.width:screenWidth-24 -_loveGroup.frame.size.width;
            
            _loveGroup.position = CGPointMake(x, 40);
            
            [cell addSubview:_loveGroup];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loveGroupChanged:) name:GROUP_CHANGED object:_loveGroup];
            return cell;
        }
        
    }
    else
    {
        static NSString *SimpleTableIdentifier = @"PayOrderTableViewCellIdentifier";
        PayOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (cell == nil) {
            cell = [[PayOrderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
        }
        
        cell.orderImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",[self.dataArray objectAtIndex:indexPath.row-1][@"tradeImage"]]];
        cell.orderNameLabel.text = [self.dataArray objectAtIndex:indexPath.row-1][@"tradeName"];
        cell.amountTextField.text = [self.dataArray objectAtIndex:indexPath.row-1][@"amount"];
        cell.moneyLabel.text = [NSString stringWithFormat:@"共%@元",[self.dataArray objectAtIndex:indexPath.row-1][@"money"]];

        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[MemberPayTableViewCell shareMemberPayTableViewCell] passwordTextFieldResignFirstResponder];
}

#pragma mark - 支付宝支付Btn
- (IBAction)alipayBtnPressed:(id)sender {
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"CompletePayView"];
    [viewController setModalPresentationStyle:UIModalPresentationFullScreen];
    
    [SVProgressShow showWithStatus:@"付款处理中..."];
    double delayInSeconds = 1.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [SVProgressShow dismiss];
        [self.navigationController pushViewController:viewController animated:YES];
    });
}

#pragma mark - 银联支付Btn
- (IBAction)InternetbankBtnPressed:(id)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"CompletePayView"];
    [viewController setModalPresentationStyle:UIModalPresentationFullScreen];
    
    [SVProgressShow showWithStatus:@"付款处理中..."];
    double delayInSeconds = 1.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [SVProgressShow dismiss];
        [self.navigationController pushViewController:viewController animated:YES];
    });

}

#pragma mark - 会员卡支付Btn
- (IBAction)payBtnPressed:(id)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Card" bundle:nil];
    CompleteVoucherViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"CompleteVoucherView"];
    [viewController setModalPresentationStyle:UIModalPresentationFullScreen];
    
    [SVProgressShow showWithStatus:@"充值处理中..."];
    
    double delayInSeconds = 1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [SVProgressShow dismiss];
        [self.navigationController pushViewController:viewController animated:YES];
    });
}

- (void)loveGroupChanged:(NSNotification *)notification {
    
    NSLog(@"Checked checkboxes %@", _loveGroup.checkedCheckBoxes);
    NSLog(@"Unchecked checkboxes %@", _loveGroup.uncheckedCheckBoxes);
    
}
#pragma  mark - storyboard传值
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    CompletePayViewController *completePayViewController = segue.destinationViewController;
    completePayViewController.isMemberPay = self.isMemberPay;
}

@end
