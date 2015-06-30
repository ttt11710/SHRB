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
    
    self.dataArray = [[NSMutableArray alloc] initWithObjects:@"冰拿铁",@"卡布奇诺", nil];
    //删除底部多余横线
    self.tableView.tableFooterView =[[UIView alloc]init];
    self.tableView.backgroundColor = HexRGB(0xF1EFEF);
}


#pragma mark - tableView dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 44;
    }
    else if (indexPath.row == [self.dataArray count]+1){
        
            return self.isMemberPay? 140:160;
    }
    else {
        return 80;
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
        cell.textLabel.text = @"共2件商品";
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
            manData.labelText = @"100RMB电子券";
            manData.checked = YES;
            manData.checkedImage = [UIImage imageNamed:@"checked"];
            manData.uncheckedImage = [UIImage imageNamed:@"unchecked"];
            
            _loveGroup = [[TNCheckBoxGroup alloc] initWithCheckBoxData:@[manData] style:TNCheckBoxLayoutVertical];
            [_loveGroup create];
            _loveGroup.position = CGPointMake(screenWidth-_loveGroup.frame.size.width-5, 4);
            
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
            manData.labelText = @"100RMB电子券";
            manData.checked = YES;
            manData.checkedImage = [UIImage imageNamed:@"checked"];
            manData.uncheckedImage = [UIImage imageNamed:@"unchecked"];
            
            _loveGroup = [[TNCheckBoxGroup alloc] initWithCheckBoxData:@[manData] style:TNCheckBoxLayoutVertical];
            [_loveGroup create];
            _loveGroup.position = CGPointMake(screenWidth-_loveGroup.frame.size.width-5, 4);
            
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
        
        cell.orderImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",[self.dataArray objectAtIndex:indexPath.row-1]]];
        cell.orderNameLabel.text = [self.dataArray objectAtIndex:indexPath.row-1];
    
        return cell;
    }
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

#pragma mark - 网银支付Btn
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
