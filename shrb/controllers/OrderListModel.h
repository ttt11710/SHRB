//
//  OrderListModel.h
//  shrb
//
//  Created by PayBay on 15/8/21.
//  Copyright © 2015年 PayBay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderListModel : NSObject
/*订单列表*/
@property(nonatomic,copy) NSString * storeLogoImageView;    //会员卡图片
@property(nonatomic,copy) NSString * storeNameLabel;        //商店名称
@property(nonatomic,copy) NSString * stateLabel;         //交易状态
@property(nonatomic,copy) NSString * orderImageView;           //订单图片
@property(nonatomic,copy) NSString * orderNum;           //订单号
@property(nonatomic,copy) NSString * address;            //消费地址
@property(nonatomic,copy) NSString * date;               //消费日期
@property(nonatomic,copy) NSString * moneyLabel;         //消费金额
@property(nonatomic,copy) NSString * refundmoney;        //退款金额

@end
