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
#import "NSString+AttributedStyle.h"
#import "CompleteVoucherViewController.h"
#import "StoreTableViewCell.h"
#import "OrderModel.h"

@interface PayViewController ()
{
    TNCheckBoxGroup *_loveGroup;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;



@property (weak, nonatomic) IBOutlet BFPaperButton *makeSurePayBtn;

@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,strong) NSMutableArray * modelArray;

@end

@implementation PayViewController

@synthesize isMemberPay;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.makeSurePayBtn setBackgroundColor:shrbPink];
    
    self.dataArray = [[NSMutableArray alloc] initWithObjects:
                      @{
                        @"tradeImage" : @"提拉米苏",
                        @"tradeName" : @"提拉米苏",
                        @"tradeDescription":@"是的范德萨发发",
                        @"memberPrice":@"30",
                        @"originalPrice":@"55",
                        @"amount":@"10",
                        @"money":@"450",
                        },
                      @{
                        @"tradeImage" : @"蜂蜜提子可颂",
                        @"tradeName" : @"蜂蜜提子可颂",
                        @"tradeDescription":@"放发放烦人烦人发热方式法萨芬热热发生地方",
                        @"memberPrice":@"40",
                        @"originalPrice":@"45",
                        @"amount":@"2",
                        @"money":@"70",
                        },
                      @{
                        @"tradeImage" : @"芝士可颂",
                        @"tradeName" : @"芝士可颂",
                        @"tradeDescription":@"人发热方式法萨芬银行悍匪号放假一天很听话规定符合他后天热后有何用好人",
                        @"memberPrice":@"25",
                        @"originalPrice":@"30",
                        @"amount":@"5",
                        @"money":@"450",
                        },
                      nil];
    
    self.modelArray = [[NSMutableArray alloc] init];
    
    [self initTableView];
    
}

- (void)initTableView
{
    //去除tableview顶部留白
    self.automaticallyAdjustsScrollViewInsets = false;
    
    //删除底部多余横线
    self.tableView.tableFooterView =[[UIView alloc]init];
    self.tableView.backgroundColor = shrbTableViewColor;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, screenWidth, 60.f)];
}

- (void)viewDidLayoutSubviews {
    
    if (IsiPhone4s) {
            self.tableView.frame = CGRectMake(0, 64, screenWidth, screenHeight - 64-44);
    }
    [self.view layoutSubviews];
}

#pragma mark - tableView dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0  || indexPath.row == [self.dataArray count]+1|| indexPath.row == [self.dataArray count]+2) {
        return 44;
    }
    else if (indexPath.row == [self.dataArray count]+3|| indexPath.row == [self.dataArray count]+4|| indexPath.row == [self.dataArray count]+5) {
        return 55;
    }
    else {
        return 93;
    }
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count]+6;
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
        cell.textLabel.text = [NSString stringWithFormat:@"共%lu件商品",(unsigned long)[self.dataArray count]];
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        cell.textLabel.textColor = shrbText;
        
        return cell;
    }
    
    else if (indexPath.row == [self.dataArray count]+1) {
            
            static NSString *SimpleTableIdentifier = @"cellId";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
            }
            TNImageCheckBoxData *manData = [[TNImageCheckBoxData alloc] init];
            manData.identifier = @"man";
            manData.labelText = @"2张电子券 100RMB";
            manData.checked = YES;
            manData.checkedImage = [UIImage imageNamed:@"checked"];
            manData.uncheckedImage = [UIImage imageNamed:@"unchecked"];
            
            _loveGroup = [[TNCheckBoxGroup alloc] initWithCheckBoxData:@[manData] style:TNCheckBoxLayoutVertical];
            [_loveGroup create];
            
            CGFloat x = IsiPhone4s? screenWidth-_loveGroup.frame.size.width:screenWidth-24 -_loveGroup.frame.size.width;
            
            _loveGroup.position = CGPointMake(x, 11.5);
            
            [cell addSubview:_loveGroup];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loveGroupChanged:) name:GROUP_CHANGED object:_loveGroup];
            return cell;
        }
    else if (indexPath.row == [self.dataArray count]+2) {
        
        static NSString *SimpleTableIdentifier = @"cellId";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
        }
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"实付款:￥420"];
        
        [attrString addAttribute:NSForegroundColorAttributeName value:shrbPink range:NSMakeRange(4, 4)];
        [attrString addAttribute:NSForegroundColorAttributeName value:shrbText range:NSMakeRange(0,3)];
        [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, attrString.length)];
        
        cell.detailTextLabel.attributedText = attrString;
        return cell;
    }
    else if (indexPath.row == [self.dataArray count]+3) {
        
        static NSString *SimpleTableIdentifier = @"huiyuankaCellId";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
        }
        return cell;
    }
    else if (indexPath.row == [self.dataArray count]+4) {
        
        static NSString *SimpleTableIdentifier = @"weixinCellId";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
        }
        return cell;
    }
    else if (indexPath.row == [self.dataArray count]+5) {
        
        static NSString *SimpleTableIdentifier = @"yinhangCellId";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
        }
        return cell;
    }
    else
    {
        static NSString *SimpleTableIdentifier = @"CouponsTableViewCellIdentifier";
        StoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (cell == nil) {
            cell = [[StoreTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
        }
        
        [self.modelArray removeAllObjects];
        for (NSDictionary * dict in self.dataArray) {
            OrderModel * model = [[OrderModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            [self.modelArray addObject:model];
        }
        
        cell.orderModel = self.modelArray[indexPath.row-1];
        
//        cell.orderImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",[self.dataArray objectAtIndex:indexPath.row-1][@"tradeImage"]]];
//        cell.orderNameLabel.text = [self.dataArray objectAtIndex:indexPath.row-1][@"tradeName"];
//        cell.amountTextField.text = [self.dataArray objectAtIndex:indexPath.row-1][@"amount"];
//        NSString *string = [NSString stringWithFormat:@"共%@元",[self.dataArray objectAtIndex:indexPath.row-1][@"money"]];
//        
//        cell.moneyLabel.attributedText = [string createrAttributedStringWithStyles:
//                                          @[
//                                            [ForeGroundColorStyle withColor:[UIColor redColor] range:NSMakeRange(1, string.length-2)],
//                                            [FontStyle withFont:[UIFont systemFontOfSize:18.f] range:NSMakeRange(1, string.length-2)]
//                                            ]];

        

        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[MemberPayTableViewCell shareMemberPayTableViewCell] passwordTextFieldResignFirstResponder];
    
    for (NSIndexPath* indexPath in [self.tableView indexPathsForVisibleRows])
    {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        for (id view in cell.contentView.subviews)
        {
            if ([view isKindOfClass:[UIButton class]])
            {
                [(UIButton *)view setImage:[UIImage imageNamed:@"payUncheck"] forState:UIControlStateNormal];
            }
        }
    }
    if (indexPath.row >= [self.dataArray count] +3 && indexPath.row <=  [self.dataArray count]+5) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        for (id view in cell.contentView.subviews)
        {
            if ([view isKindOfClass:[UIButton class]])
            {
                if ([[(UIButton *)view currentImage] isEqual:[UIImage imageNamed:@"payUncheck"]]) {
                    [(UIButton *)view setImage:[UIImage imageNamed:@"paycheck"] forState:UIControlStateNormal];
                }
                
                else if ([[(UIButton *)view currentImage] isEqual:[UIImage imageNamed:@"paycheck"]]) {
                    [(UIButton *)view setImage:[UIImage imageNamed:@"payUncheck"] forState:UIControlStateNormal];
                }
            }
        }
    }
}

#pragma mark - 支付宝支付Btn
- (IBAction)alipayBtnPressed:(id)sender {

    [self notMmeberpushView:@"支付宝"];
}

#pragma mark - 银联支付Btn
- (IBAction)InternetbankBtnPressed:(id)sender {
    
    [self notMmeberpushView:@"银联"];
}

- (void)notMmeberpushView:(NSString *)string
{
    NSString *QRPay =  [[NSUserDefaults standardUserDefaults] stringForKey:@"QRPay"];
    
    //超市商品页扫码支付
    if ([QRPay isEqualToString:@"SupermarketNewStore"])
    {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"superCompletePayView"];
        [viewController setModalPresentationStyle:UIModalPresentationFullScreen];
        
        [SVProgressShow showWithStatus:@"付款处理中..."];
        double delayInSeconds = 1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [SVProgressShow dismiss];
            [self.navigationController pushViewController:viewController animated:YES];
        });
    }
    //非会员支付
    else {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *viewController  =  [mainStoryboard instantiateViewControllerWithIdentifier:@"orderCompletePayView"];
        [viewController setModalPresentationStyle:UIModalPresentationFullScreen];
        
        [SVProgressShow showWithStatus:@"付款处理中..."];
        double delayInSeconds = 1.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [SVProgressShow dismiss];
            [self.navigationController pushViewController:viewController animated:YES];
        });
    }
}
#pragma mark - 会员卡支付Btn
- (IBAction)payBtnPressed:(id)sender {
    
    for (NSIndexPath* indexPath in [self.tableView indexPathsForVisibleRows])
    {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        for (id view in cell.contentView.subviews)
        {
            if ([view isKindOfClass:[UIButton class]])
            {
                if ([[(UIButton *)view currentImage] isEqual:[UIImage imageNamed:@"paycheck"]]) {
                    switch (indexPath.row - [self.dataArray count]) {
                        case 3:
                            NSLog(@"支付方式：会员卡");
                            break;
                        case 4:
                            NSLog(@"支付方式：微信");
                            break;
                        case 5:
                            NSLog(@"支付方式：银行卡");
                            break;
                            
                        default:
                            break;
                    }
                    
                }
            }
        }
    }
    
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

#pragma mark - 单选框点击调用
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
