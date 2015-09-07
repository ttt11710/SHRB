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
#import "StoreTableViewCell.h"
#import <UIImageView+WebCache.h>
#import "SuperAndStorePayViewController.h"

@interface SuperOrderViewController ()
{
    NSMutableArray *_data;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet BFPaperButton *submitOrderBtn;

@end

@implementation SuperOrderViewController

@synthesize merchId;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initTableView];
    
    self.submitOrderBtn.backgroundColor = shrbPink;
}

- (void)viewDidLayoutSubviews
{
    if (IsiPhone4s) {
        self.tableView.frame = CGRectMake(0, 64, screenWidth, screenHeight-64-44);
    }
    [self.view layoutSubviews];
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
        return 93;
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
        static NSString *simpleTableIdentifier = @"CouponsTableViewCellIdentifier";
        StoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (cell == nil) {
            cell = [[StoreTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        
        cell.tradeNameLabel.text = [_data objectAtIndex:indexPath.row-1];
        [cell.tradeImageView sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"热点无图片"]];
        cell.tradeDescriptionLabel.text = [_data objectAtIndex:indexPath.row-1];
        
        //        NSNumber *vipPriceNumber = shoppingCardDataItem.prodList[@"vipPrice"];
        //        NSNumber *priceNumber = shoppingCardDataItem.prodList[@"price"];
        
        //        NSString *vipPrice = [vipPriceNumber stringValue];
        //        NSString *price = [priceNumber stringValue];
        
        NSString *vipPrice = @"300";
        NSString *price = @"280";
        
        
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@ 原价￥%@",vipPrice,price]];
        
        [attrString addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange([vipPrice length] + 2, [price length]+3)];//删除线
        [attrString addAttribute:NSForegroundColorAttributeName value:shrbPink range:NSMakeRange(0, vipPrice.length + 1)];
        [attrString addAttribute:NSForegroundColorAttributeName value:shrbLightText range:NSMakeRange(vipPrice.length + 2, price.length+3)];
        
        [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, vipPrice.length + 1)];
        [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(vipPrice.length + 2, price.length+3)];
        
        cell.priceLabel.attributedText = attrString;
        
//        cell.amountTextField.text = [NSString stringWithFormat:@"%ld",(long)shoppingCardDataItem.count];
//        cell.moneyLabel.text = [NSString stringWithFormat:@"￥%.2f",shoppingCardDataItem.count * [price floatValue]];
        
        cell.amountTextField.text = @"3";
        cell.moneyLabel.text = @"￥900";
        
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

#pragma  mark - storyboard传值
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    SuperAndStorePayViewController *superAndStorePayViewController = segue.destinationViewController;
    superAndStorePayViewController.merchId = self.merchId;
}


@end
