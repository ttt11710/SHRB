//
//  NewCardDetailViewController.m
//  shrb
//
//  Created by PayBay on 15/6/26.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "NewCardDetailViewController.h"
#import "CardImageAndCardNumTableViewCell.h"
#import "LeftLabelTableViewCell.h"
#import "SVProgressShow.h"
#import "Const.h"
#import "PayQRViewController.h"
#import "TBUser.h"
#import <UIImageView+WebCache.h>
#import "TradingRecordTableViewController.h"
#import "NewVoucherCenterViewController.h"
#import "CardDetailTableViewCell.h"


static NewCardDetailViewController *g_NewCardDetailViewController = nil;

@interface SectionModel : NSObject
{
    BOOL            _flag;
    NSMutableArray  *_sectionDataMutableArray;
}

@property(assign, readwrite, nonatomic)BOOL flag;
@property(readonly, nonatomic)NSMutableArray *sectionDataMutableArray;



@end

@implementation SectionModel

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        _sectionDataMutableArray = [[NSMutableArray alloc] init];
        
    }
    return self;
}

@end

@interface SectionHeaderView : UIView
{
    UIImageView *_imageView;
    
    UILabel   *_titleLabel;
    
    BOOL            _flag;
    
    UIView    *_bottomLineView;
}
@property(assign, readwrite, nonatomic)BOOL flag;
@property(retain, readwrite, nonatomic)NSString  *title;
@property(assign, readwrite, nonatomic)int  number;

@end

@implementation SectionHeaderView

- (void)setFlag:(BOOL)flag
{
    _flag = flag;
    
    if (_flag)
    {
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            _imageView.layer.transform = CATransform3DIdentity;
            
        } completion:^(BOOL finished) {
            
        }];
    }
    else
    {
        
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            _imageView.layer.transform = CATransform3DMakeRotation(-180 * 3.1415926 / 180.0, 0, 0, 1);
            
        } completion:^(BOOL finished) {
            
        }];
        
        
    }
}

- (void)setTitle:(NSString *)title
{
    _titleLabel.text = title;
}

- (NSString *)title
{
    return _titleLabel.text;
}

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        self.backgroundColor = [UIColor whiteColor];
        
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back_normal.png"]];
        
        [self addSubview:_imageView];
        
        _titleLabel = [[UILabel alloc] init];
        
        _titleLabel.textColor = shrbText;
        
        [self addSubview:_titleLabel];
        
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = shrbTableViewColor;
        
        [self addSubview:_bottomLineView];
        
    }
    
    return self;
}



//布局子视图的函数
- (void)layoutSubviews
{
    _imageView.frame = CGRectMake(self.frame.size.width - 25, 15, 15, self.frame.size.height-25);
    
    _titleLabel.frame = CGRectMake(18, 0, self.frame.size.width - 100, self.frame.size.height);
    
    _bottomLineView.frame = CGRectMake(16, self.frame.size.height-1, self.frame.size.width, 1);
}

@end

@interface NewCardDetailViewController ()
{
    //model
    NSMutableArray   *_dataMutableArray;
    NSMutableArray   *_rowDataMutableArray;
    NSMutableArray  *_memberRuleArray;
    NSMutableArray  *_integralRuleArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet UIButton *voucherBtn;

@property (nonatomic, strong) NSMutableDictionary *dataDic;

@end


@implementation NewCardDetailViewController

@synthesize cardNo;
@synthesize merchId;

+ (NewCardDetailViewController *)shareNewCardDetailViewController
{
    return g_NewCardDetailViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    g_NewCardDetailViewController = self;
    
    [self loadData];
    [self initBtn];
    [self initData];
    [self initTableView];
}

- (void)loadData
{
    
    self.dataDic = [[NSMutableDictionary alloc] init];
    
    NSString *url2=[baseUrl stringByAppendingString:@"/card/v1.0/findCardDetail?"];
    [self.requestOperationManager GET:url2 parameters:@{@"userId":[TBUser currentUser].userId,@"token":[TBUser currentUser].token,@"merchId":self.merchId,@"cardNo":self.cardNo} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"findCardDetail operation = %@ JSON: %@", operation,responseObject);
        self.dataDic = responseObject[@"data"];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:++++%@",error.localizedDescription);
    }];
}

- (void)initBtn
{
    [self.payBtn setBackgroundColor:shrbPink];
    [self.voucherBtn setBackgroundColor:shrbPink];
}

- (void)initData
{
    _dataMutableArray = [[NSMutableArray alloc] init];
    _rowDataMutableArray = [[NSMutableArray alloc] initWithObjects:@"会员规则\n1、会员卡注册不需缴纳任何费用。\n2、针对不同商家使用同一张会员卡，但优惠金额由商家决定。\n3、会员卡注销时需缴纳余额5%的手续费，且注销后不再享受会员优惠。",@"积分规则\n1、免费注册会员，即刻赠送20积分。\n2、成功交易一笔订单可获得积分，不同商品积分标准不同。\n3、消费时可使用积分抵消现金，不同商品使用标准不同。", nil];
    
    _memberRuleArray = [[NSMutableArray alloc] initWithObjects:@"会员规则\n1、会员卡注册不需缴纳任何费用。\n2、针对不同商家使用同一张会员卡，但优惠金额由商家决定。\n3、会员卡注销时需缴纳余额5%的手续费，且注销后不再享受会员优惠。", nil];
    
    _integralRuleArray = [[NSMutableArray alloc] initWithObjects:@"积分规则\n1、免费注册会员，即刻赠送20积分。\n2、成功交易一笔订单可获得积分，不同商品积分标准不同。\n3、消费时可使用积分抵消现金，不同商品使用标准不同。", nil];
    
    for (int i=0; i<2; i++)
    {
        
        SectionModel *sectionModel = [[SectionModel alloc] init];
        
        sectionModel.flag = NO;//展开的
        
        for (int j=0; j<1; j++)
        {
            if (i == 0) {
                [sectionModel.sectionDataMutableArray addObject:[_memberRuleArray objectAtIndex:0]];
            }
            else {
                [sectionModel.sectionDataMutableArray addObject:[_integralRuleArray objectAtIndex:0]];
            }
        }
        
        
        [_dataMutableArray addObject:sectionModel];
    }

}

- (void)initTableView
{
    //删除底部多余横线
    self.tableView.tableFooterView =[[UIView alloc]init];
    
    self.tableView.backgroundColor = shrbTableViewColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

#pragma mark - tableView dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
       // return 130;
        return 180;
    }
    else if (indexPath.section == 3) {
        return 44;
    }
    else  {
        
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenWidth - 16, 0)];
        UIFont* theFont = [UIFont systemFontOfSize:17.0];
        label.numberOfLines = 0;
        [label setFont:theFont];
        [label setText:_rowDataMutableArray[indexPath.section-1]];
        
        
        [label sizeToFit];// 显示文本需要的长度和宽度
        return label.frame.size.height+20;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0 || section == 3?0:44;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 1 || section == 2) {
        SectionHeaderView  *sectionHeaderView = [[SectionHeaderView alloc] init];
        
        sectionHeaderView.tag = section-1;
        
        if (section == 1) {
            sectionHeaderView.title = [NSString stringWithFormat:@"金额:%@元",self.dataDic[@"amount"]];
        }
        else {
            sectionHeaderView.title = [NSString stringWithFormat:@"积分:%@分",self.dataDic[@"score"]];
        }
        
        SectionModel *sectionModel = [_dataMutableArray objectAtIndex:section-1];
        sectionHeaderView.flag=sectionModel.flag;
        UITapGestureRecognizer  *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionClick:)];
        
        [sectionHeaderView addGestureRecognizer:tapGestureRecognizer];
        
        return sectionHeaderView;
    }
    return nil;
}

- (void)sectionClick:(UITapGestureRecognizer  *)tapGestureRecognizer
{
    SectionHeaderView  *sectionHeaderView = (SectionHeaderView *)tapGestureRecognizer.view;
    
    SectionModel * sectionModel = [_dataMutableArray objectAtIndex:sectionHeaderView.tag];
    
    sectionModel.flag =  !(sectionModel.flag);
    
    sectionHeaderView.flag = sectionModel.flag;
    
    NSMutableArray   *indexPathsMutableArray = [[NSMutableArray alloc] init];
    
    for (int i=0; i<[sectionModel.sectionDataMutableArray count]; i++)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:sectionHeaderView.tag+1];
        
        [indexPathsMutableArray addObject:indexPath];
    }
    
    
    NSArray   *indexPathsArray = [indexPathsMutableArray copy];
    
    if (sectionModel.flag)
    {
        [_tableView insertRowsAtIndexPaths:indexPathsArray withRowAnimation:UITableViewRowAnimationFade];
    }
    else
    {
        [_tableView deleteRowsAtIndexPaths:indexPathsArray withRowAnimation:UITableViewRowAnimationFade];
    }
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    }
    else if(section == 3)
    {
        return 2;
    }
    else
    {
        SectionModel *sectionModel = [_dataMutableArray objectAtIndex:section-1];
        if (sectionModel.flag)
        {
            return [sectionModel.sectionDataMutableArray count];
        }
        else
        {
            return 0;
        }

    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return section == 0?1:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
//        static NSString *SimpleTableIdentifier = @"CardImageAndCardNumTableViewCellIdentifier";
//        CardImageAndCardNumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
//        cell.selectionStyle=UITableViewCellSelectionStyleNone;
//        if (cell == nil) {
//            cell = [[CardImageAndCardNumTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
//        }
//        //cell 选中方式
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        [cell.cardImgUrlImageView sd_setImageWithURL:[NSURL URLWithString:self.dataDic[@"cardImgUrl"]] placeholderImage:[UIImage imageNamed:@"官方头像"]];
//        cell.cardNoLabel.text = [NSString stringWithFormat:@"卡号:%@",self.dataDic[@"cardNo"]];
        
        static NSString *SimpleTableIdentifier = @"CardDetailTableViewCellIdentifier";
        CardDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
        if (cell == nil) {
            cell = [[CardDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
        }
        //cell 选中方式
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.cardBackImageView sd_setImageWithURL:[NSURL URLWithString:self.dataDic[@"cardImgUrl"]] placeholderImage:[UIImage imageNamed:@"cardBack"]];
        
        cell.merchNameLabel.text = self.dataDic[@"merchName"];
        
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
    else if (indexPath.section == 3)
    {
        static NSString *SimpleTableIdentifier = @"LeftLabelTableViewCellIdentifier";
        LeftLabelTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (cell == nil) {
            cell = [[LeftLabelTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
        }
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.row == 0) {
            cell.leftLabel.text = @"交易记录";
        }
        else {
            cell.leftLabel.text = @"试用门店电话及地址";
        }

        return cell;
    }
    else {
        
        static NSString *SimpleTableIdentifier = @"LeftLabelTableViewCellIdentifier";
        LeftLabelTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (cell == nil) {
            cell = [[LeftLabelTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
        }
        
        SectionModel *sectionModel = [_dataMutableArray objectAtIndex:[indexPath section]-1];
        cell.leftLabel.text = [sectionModel.sectionDataMutableArray objectAtIndex:[indexPath row]];
        cell.backgroundColor = shrbTableViewColor;
        
        return cell;

    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3 && indexPath.row == 0) {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Card" bundle:nil];
        TradingRecordTableViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"TradingRecordTableView"];
        [viewController setModalPresentationStyle:UIModalPresentationFullScreen];
        viewController.cardNo = self.cardNo;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if (indexPath.section == 3 && indexPath.row == 1) {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Card" bundle:nil];
        UIViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"UserStoreInfoTableView"];
        [viewController setModalPresentationStyle:UIModalPresentationFullScreen];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

#pragma mark - 扫码支付
- (IBAction)payBtnPressed:(id)sender {
    
    if ([self validateCamera]) {
        
        [self showQRViewController];
        
    } else {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有摄像头或摄像头不可用" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}


- (BOOL)validateCamera {
    
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] &&
    [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (void)showQRViewController {
    
    PayQRViewController *qrVC = [[PayQRViewController alloc] init];
    qrVC.merchId = self.merchId;
    [self.navigationController pushViewController:qrVC animated:YES];
}

#pragma mark - 完成支付
- (void)completePay
{
    [SVProgressShow showSuccessWithStatus:@"支付成功！"];
}

#pragma mark - 进入充值界面
- (IBAction)goVoucherCenterBtnPressed:(id)sender {
    
     NSString *QRPay = [[NSUserDefaults standardUserDefaults] stringForKey:@"QRPay"];
    if ( [QRPay isEqualToString:@"SupermarketOrOrder"]) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"QRPay"];
        [[NSUserDefaults standardUserDefaults] setObject:@"SupermarketOrOrderVoucher" forKey:@"QRPay"];
    }
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Card" bundle:nil];
    NewVoucherCenterViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"NewVoucherCenterView"];
    [viewController setModalPresentationStyle:UIModalPresentationFullScreen];
    viewController.cardNo = self.cardNo;
    viewController.amount = self.dataDic[@"amount"];
    viewController.score = self.dataDic[@"score"];
    viewController.merchId = self.merchId;
    viewController.cardImgUrl = self.dataDic[@"cardImgUrl"];
    [self.navigationController pushViewController:viewController animated:YES];
    
}



#pragma mark - 故事版传值
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    NSString *QRPay = [[NSUserDefaults standardUserDefaults] stringForKey:@"QRPay"];
    if ([segue.identifier isEqualToString:@"gotoVoucherCenter"])
    {
        if ( [QRPay isEqualToString:@"SupermarketOrOrder"]) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"QRPay"];
            [[NSUserDefaults standardUserDefaults] setObject:@"SupermarketOrOrderVoucher" forKey:@"QRPay"];
        }
    }
}

@end
