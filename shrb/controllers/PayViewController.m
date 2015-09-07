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
#import "StoreTableViewCell.h"
#import "OrderModel.h"
#import "ShoppingCardDataItem.h"
#import <UIImageView+WebCache.h>
#import "TBUser.h"
#import "NewCompleteVoucherViewController.h"

@interface PayViewController ()
{
    TNCheckBoxGroup *_loveGroup;
    NSString *_cardNo;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;



@property (weak, nonatomic) IBOutlet BFPaperButton *makeSurePayBtn;

@end

@implementation PayViewController

@synthesize isMemberPay;

@synthesize merchId;
@synthesize totalPrice;
@synthesize shoppingArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.makeSurePayBtn setBackgroundColor:shrbPink];
    
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
    if (indexPath.row == 0  || indexPath.row == [self.shoppingArray count]+1|| indexPath.row == [self.shoppingArray count]+2) {
        return 44;
    }
    else if (indexPath.row == [self.shoppingArray count]+3|| indexPath.row == [self.shoppingArray count]+4|| indexPath.row == [self.shoppingArray count]+5) {
        return 55;
    }
    else {
        return 93;
    }
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.shoppingArray count]+6;
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
        cell.textLabel.text = [NSString stringWithFormat:@"共%lu件商品",(unsigned long)[self.shoppingArray count]];
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        cell.textLabel.textColor = shrbText;
        
        return cell;
    }
    
    else if (indexPath.row == [self.shoppingArray count]+1) {
        
        static NSString *SimpleTableIdentifier = @"cellId";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
        }
        for (id view in _loveGroup.subviews) {
            [view removeFromSuperview];
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
    else if (indexPath.row == [self.shoppingArray count]+2) {
        
        static NSString *SimpleTableIdentifier = @"cellId";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
        }
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"实付款:￥%.2f",self.totalPrice]];
        
        [attrString addAttribute:NSForegroundColorAttributeName value:shrbPink range:NSMakeRange(4, attrString.length-4)];
        [attrString addAttribute:NSForegroundColorAttributeName value:shrbText range:NSMakeRange(0,3)];
        [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, attrString.length)];
        
        cell.detailTextLabel.attributedText = attrString;
        return cell;
    }
    else if (indexPath.row == [self.shoppingArray count]+3) {
        
        static NSString *SimpleTableIdentifier = @"huiyuankaCellId";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
        }
        return cell;
    }
    else if (indexPath.row == [self.shoppingArray count]+4) {
        
        static NSString *SimpleTableIdentifier = @"weixinCellId";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
        }
        return cell;
    }
    else if (indexPath.row == [self.shoppingArray count]+5) {
        
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
        
        ShoppingCardDataItem *shoppingCardDataItem = [[ShoppingCardDataItem alloc] init];
        shoppingCardDataItem = self.shoppingArray[indexPath.row-1];
        
        cell.tradeNameLabel.text = shoppingCardDataItem.prodList[@"prodName"] == nil? @"商品名称" : shoppingCardDataItem.prodList[@"prodName"];
        [cell.tradeImageView sd_setImageWithURL:[NSURL URLWithString:shoppingCardDataItem.prodList[@"imgUrl"]] placeholderImage:[UIImage imageNamed:@"热点无图片"]];
        
        cell.tradeDescriptionLabel.text = shoppingCardDataItem.prodList[@"prodDesc"];
        
        NSNumber *vipPriceNumber = shoppingCardDataItem.prodList[@"vipPrice"];
        NSNumber *priceNumber = shoppingCardDataItem.prodList[@"price"];
        
        NSString *vipPrice = [vipPriceNumber stringValue];
        NSString *price = [priceNumber stringValue];
        
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@ 原价￥%@",vipPrice,price]];
        
        [attrString addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange([vipPrice length] + 2, [price length]+3)];//删除线
        [attrString addAttribute:NSForegroundColorAttributeName value:shrbPink range:NSMakeRange(0, vipPrice.length + 1)];
        [attrString addAttribute:NSForegroundColorAttributeName value:shrbLightText range:NSMakeRange(vipPrice.length + 2, price.length+3)];
        
        [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, vipPrice.length + 1)];
        [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(vipPrice.length + 2, price.length+3)];
        
        cell.priceLabel.attributedText = attrString;
        
        cell.amountTextField.text = [NSString stringWithFormat:@"%ld",(long)shoppingCardDataItem.count];
        cell.moneyLabel.text = [NSString stringWithFormat:@"￥%.2f",shoppingCardDataItem.count * [price floatValue]];
        cell.moneyLabel.textColor = shrbPink;
        
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
    if (indexPath.row >= [self.shoppingArray count] +3 && indexPath.row <=  [self.shoppingArray count]+5) {
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
                    switch (indexPath.row - [self.shoppingArray count]) {
                        case 3:
                            [self cardPay];
                            break;
                        case 4:
                            [SVProgressShow showInfoWithStatus:@"支付方式：微信"];
                            break;
                        case 5:
                            [SVProgressShow showInfoWithStatus:@"支付方式：银行卡"];
                            break;
                            
                        default:
                            break;
                    }
                    
                }
            }
        }
    }
    
}


- (void)cardPay
{
    if ([TBUser currentUser].token.length == 0) {
        
        [SVProgressShow showInfoWithStatus:@"请先登录账号!"];
        return ;
    }
    
    NSString *url=[baseUrl stringByAppendingString:@"/card/v1.0/findCardByMerch?"];
    [self.requestOperationManager GET:url parameters:@{@"userId":[TBUser currentUser].userId,@"token":[TBUser currentUser].token,@"merchId":self.merchId} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"findCardByMerch operation = %@ JSON: %@", operation,responseObject);
        
        if ([responseObject[@"code"]integerValue] == 404) {
            
            [SVProgressShow showInfoWithStatus:@"未注册会员卡,不能使用此方法支付!"];
            return ;
        }
        if ([responseObject[@"code"]integerValue] == 200) {
            
            _cardNo = responseObject[@"data"][@"cardNo"];
            NSString *url2=[baseUrl stringByAppendingString:@"/card/v1.0/pay?"];
            [self.requestOperationManager GET:url2 parameters:@{@"userId":[TBUser currentUser].userId,@"token":[TBUser currentUser].token,@"merchId":self.merchId,@"cardNo":_cardNo,@"payAmount":@(self.totalPrice)} success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"pay operation = %@ JSON: %@", operation,responseObject);
                
                if ([responseObject[@"code"]integerValue] == 202) {
                   
                    [SVProgressShow showInfoWithStatus:@"卡内余额不足,请先去会员卡界面充值"];
                }
                else if ([responseObject[@"code"]integerValue] == 200) {
                    
                    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Card" bundle:nil];
                    NewCompleteVoucherViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"NewCompleteVoucherView"];
                    [viewController setModalPresentationStyle:UIModalPresentationFullScreen];
                    viewController.merchId = self.merchId;
                    viewController.cardNo = _cardNo;
                    viewController.title = @"支付完成";
                    [SVProgressShow showWithStatus:@"正在支付..."];
                    
                    double delayInSeconds = 1;
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        [SVProgressShow dismiss];
                        [self.navigationController pushViewController:viewController animated:YES];
                    });
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"error:++++%@",error.localizedDescription);
            }];

            }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:++++%@",error.localizedDescription);
    }];
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
