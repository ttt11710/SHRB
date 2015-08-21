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


@property (weak, nonatomic) IBOutlet CallBackButton *afterSaleButton;

@end
