//
//  NewVoucherCenterViewController.m
//  shrb
//
//  Created by PayBay on 15/8/28.
//  Copyright © 2015年 PayBay. All rights reserved.
//

#import "NewVoucherCenterViewController.h"
#import "Const.h"
#import "TBUser.h"
#import "CardDetailTableViewCell.h"
#import "VoucherAmoutTableViewCell.h"
#import "ChanrgeTypeTableViewCell.h"
#import "ButtonTableViewCell.h"
#import "CompleteVoucherViewController.h"
#import "SVProgressShow.h"
#import "NewCompleteVoucherViewController.h"


static NSInteger tag = -1;
static NSInteger amount = 0;
@interface NewVoucherCenterViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation NewVoucherCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = shrbLightCell;
    
    [self loadData];
    [self initTableView];
}

- (void)viewDidLayoutSubviews
{
    if (IsiPhone4s) {
        self.tableView.frame = CGRectMake(0, 20+44, screenWidth, screenHeight-20-44);
    }
    [self.view layoutSubviews];
}

- (void)loadData
{
    
    self.dataArray = [[NSMutableArray alloc] init];
    
    NSString *url2=[baseUrl stringByAppendingString:@"/card/v1.0/findCardRechargeTypeList?"];
    [self.requestOperationManager GET:url2 parameters:@{@"userId":[TBUser currentUser].userId,@"token":[TBUser currentUser].token} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"findCardRechargeTypeList operation = %@ JSON: %@", operation,responseObject);
        
        self.dataArray = responseObject[@"data"];
        
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:++++%@",error.localizedDescription);
    }];
}

- (void)initTableView
{
    
    //去除tableview顶部留白
    self.automaticallyAdjustsScrollViewInsets = false;

    //删除底部多余横线
    self.tableView.tableFooterView =[[UIView alloc]init];
    
//    //去除顶部空间
//    if (IsiPhone4s)
//    {
//        self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, screenWidth, 0.01f)];
//    }
//    else {
//        self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, screenWidth, 64.f)];
//    }
    
}


#pragma mark - tableView dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 || indexPath.row == [self.dataArray count]+2) {
        return 210;
    }
    else {
        return 56;
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count]+3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *SimpleTableIdentifier = @"CardDetailTableViewCellIdentifier";
        CardDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
        if (cell == nil) {
            cell = [[CardDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
        }
        //cell 选中方式
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        NSString *amountString = [self.amount stringValue];
        NSString *scoreString = [self.score stringValue];
        
        NSMutableAttributedString *moneyAttrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"金额:￥%@",amountString]];
        [moneyAttrString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, 3)];
        [moneyAttrString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255.0/255.0 green:212.0/212.0 blue:0 alpha:1] range:NSMakeRange(3, amountString.length+1)];
        [moneyAttrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, 3)];
        [moneyAttrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:24] range:NSMakeRange(3, amountString.length+1)];
        
        cell.amountLabel.attributedText = moneyAttrString;
        
        NSMutableAttributedString *integralAttrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"积分:%@",scoreString]];
        [integralAttrString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, 3)];
        [integralAttrString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255.0/255.0 green:212.0/212.0 blue:0 alpha:1] range:NSMakeRange(3, scoreString.length)];
        [integralAttrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, 3)];
        [integralAttrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:24] range:NSMakeRange(3, scoreString.length)];
        
        cell.scoreLabel.attributedText = integralAttrString;
        
        cell.cardNoLabel.text = [NSString stringWithFormat:@"卡号:%@",self.cardNo];
        
        return cell;

    }
    else if (indexPath.row == 1) {
        static NSString *SimpleTableIdentifier = @"VoucherAmoutTableViewCellIdentifier";
        VoucherAmoutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
        if (cell == nil) {
            cell = [[VoucherAmoutTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
        }
        //cell 选中方式
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }
    else if (indexPath.row == [self.dataArray count]+2) {
        
        static NSString *SimpleTableIdentifier = @"ButtonTableViewCellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
        }
        //cell 选中方式
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    else {
        static NSString *SimpleTableIdentifier = @"ChanrgeTypeTableViewCellIdentifier";
        ChanrgeTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
        if (cell == nil) {
            cell = [[ChanrgeTypeTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
        }
        //cell 选中方式
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.chanrgeTypNameLabel.text = self.dataArray[indexPath.row - 2][@"chanrgeTypName"];
        cell.tag = indexPath.row - 2;
        if (cell.tag == 0) {
            cell.chanrgeTypBtn.selected = YES;
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    for (NSIndexPath* indexPath in [self.tableView indexPathsForVisibleRows])
    {
        if (indexPath.row == 1) {
            VoucherAmoutTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            [cell.amountTextField resignFirstResponder];
        }
    }
    
    if (indexPath.row > 1  &&  indexPath.row < [self.dataArray count]+2) {
        
        for (NSIndexPath* indexPath in [self.tableView indexPathsForVisibleRows])
        {
            if (indexPath.row > 1  &&  indexPath.row < [self.dataArray count]+2) {
                ChanrgeTypeTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                cell.chanrgeTypBtn.selected = NO;
            }
        }
        
        ChanrgeTypeTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.chanrgeTypBtn.selected = YES;
        tag = cell.tag;
    }
}
- (IBAction)cardRecharge:(id)sender {
    
    
    for (NSIndexPath* indexPath in [self.tableView indexPathsForVisibleRows])
    {
        if (indexPath.row == 1) {
            VoucherAmoutTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            
            if (cell.amountTextField.text.length <= 0) {
                [SVProgressShow showInfoWithStatus:@"请输入充值金额!"];
                return;
            }
            amount = [cell.amountTextField.text integerValue];
            
        }
    }
    
    NSString *url2=[baseUrl stringByAppendingString:@"/card/v1.0/cardMemberRecharge?"];
    [self.requestOperationManager POST:url2 parameters:@{@"userId":[TBUser currentUser].userId,@"token":[TBUser currentUser].token,@"amount":@(amount),@"cardNo":self.cardNo,@"chanrgeTypeId":@"1"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"cardMemberRecharge operation = %@ JSON: %@", operation,responseObject);
        
//        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Card" bundle:nil];
//        CompleteVoucherViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"CompleteVoucherView"];
//        [viewController setModalPresentationStyle:UIModalPresentationFullScreen];
//        viewController.merchId = self.merchId;
//        viewController.cardNo = self.cardNo;
//        [SVProgressShow showWithStatus:@"充值处理中..."];
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Card" bundle:nil];
        NewCompleteVoucherViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"NewCompleteVoucherView"];
        [viewController setModalPresentationStyle:UIModalPresentationFullScreen];
        viewController.merchId = self.merchId;
        viewController.cardNo = self.cardNo;
        viewController.title =@"充值成功";
        [SVProgressShow showWithStatus:@"充值处理中..."];
        
        double delayInSeconds = 1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [SVProgressShow dismiss];
            [self.navigationController pushViewController:viewController animated:YES];
        });
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:++++%@",error.localizedDescription);
    }];
}

@end
