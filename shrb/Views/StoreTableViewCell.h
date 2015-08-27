//
//  CouponsTableViewCell.h
//  shrb
//
//  Created by PayBay on 15/5/20.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TradeModel;
@class OrderModel;
@class CallBackButton;

@interface StoreTableViewCell : UITableViewCell
@property (nonatomic,strong) TradeModel * model;

@property (nonatomic,strong) OrderModel * orderModel;


@property (weak, nonatomic) IBOutlet UIImageView *tradeImageView;
@property (weak, nonatomic) IBOutlet UILabel *tradeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tradeDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *MemberLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (weak, nonatomic) IBOutlet CallBackButton *afterSaleButton;

@end
