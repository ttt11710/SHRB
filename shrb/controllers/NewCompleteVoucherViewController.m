//
//  NewCompleteVoucherViewController.m
//  shrb
//
//  Created by PayBay on 15/9/2.
//  Copyright © 2015年 PayBay. All rights reserved.
//

#import "NewCompleteVoucherViewController.h"
#import "TBUser.h"
#import "Const.h"
#import "CardDetailTableViewCell.h"
#import <UIImageView+WebCache.h>
#import "SVProgressShow.h"

@interface NewCompleteVoucherViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableDictionary *dataDic;

@end

@implementation NewCompleteVoucherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SVProgressShow showWithStatus:@"加载中..."];
    
    [self loadData];
    
    [self initTableView];
}

- (void)viewDidLayoutSubviews
{
    if (IsiPhone4s) {
        self.tableView.frame = CGRectMake(0, 64, screenWidth, screenHeight-44);
    }
    [self.view layoutSubviews];
}

- (void)loadData
{
    self.dataDic = [[NSMutableDictionary alloc] init];
    
    NSString *url2=[baseUrl stringByAppendingString:@"/card/v1.0/findCardDetail?"];
    [self.requestOperationManager GET:url2 parameters:@{@"userId":[TBUser currentUser].userId,@"token":[TBUser currentUser].token,@"merchId":self.merchId,@"cardNo":self.cardNo} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"findCardDetail operation = %@ JSON: %@", operation,responseObject);
        
        switch ([responseObject[@"code"] integerValue]) {
            case 200:
                self.dataDic = responseObject[@"data"];
                [self.tableView reloadData];
                [SVProgressShow dismiss];
                break;
            case 201:
            case 500:
                [SVProgressShow showErrorWithStatus:responseObject[@"mes"]];
                break;
                
            default:
                break;
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:++++%@",error.localizedDescription);
    }];
}

- (void)initTableView
{
    //删除底部多余横线
    self.tableView.tableFooterView =[[UIView alloc]init];
    
    //去除tableview顶部留白
    self.automaticallyAdjustsScrollViewInsets = false;
}


- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat height = 30 ;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, height)] ;
    [headerView setBackgroundColor:shrbLightCell];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, (height-18)*0.5, tableView.bounds.size.width - 10, 18)];
        label.textColor = shrbText;
    label.text = @"30天内积分记录";
    label.backgroundColor = [UIColor clearColor];
    [headerView addSubview:label];
    
    return headerView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 1? 30 :0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
#pragma mark - tableView dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 || indexPath.section == 2) {
        return screenWidth/170*90 + 60;
    }
    else {
        return 44;
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        static NSString *SimpleTableIdentifier = @"CardDetailTableViewCellIdentifier";
        CardDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
        if (cell == nil) {
            cell = [[CardDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
        }
        //cell 选中方式
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.cardBackImageView sd_setImageWithURL:[NSURL URLWithString:self.dataDic[@"cardImgUrl"]] placeholderImage:[UIImage imageNamed:@"cardBack"]];
        
        NSString *amountString = [self.dataDic[@"amount"] stringValue];
        NSString *scoreString = [self.dataDic[@"score"] stringValue];
        
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
    else  {
        
        static NSString *SimpleTableIdentifier = @"cellId";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:SimpleTableIdentifier];
        }
        //cell 选中方式
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"充值交易100元";
        cell.textLabel.textColor = shrbLightText;
        
        cell.detailTextLabel.text= @"2015-5-20 PM15:47";
        cell.detailTextLabel.textColor = shrbSectionColor;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
        
        return cell;
    }
}

#pragma  mark - 完成充值Btn
- (IBAction)completeVoucherBtnPressed:(id)sender {
    
    
    NSString *QRPay =  [[NSUserDefaults standardUserDefaults] stringForKey:@"QRPay"];
    
    //超市或者点餐扫码 点餐支付
    if ([QRPay isEqualToString:@"SupermarketOrOrder"]) {
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
    //首页购物车
    else if ([QRPay isEqualToString:@"HotFocusShoppingCard"]) {
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
    //超市扫码
    else if ([QRPay isEqualToString:@"SupermarketNewStore"]) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:NO];
    }
    //卡包扫描和充值
    else if ([QRPay isEqualToString:@"Card"]){
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:NO];
    }
    //超市或者点餐充值
    else if ([QRPay isEqualToString:@"SupermarketOrOrderVoucher"]) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-4] animated:YES];
    }
}

@end
