//
//  CardModel.h
//  shrb
//
//  Created by PayBay on 15/6/19.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

/*会员卡模型*/
@interface CardModel : NSObject
@property(nonatomic,copy) NSString * memberCardImage;    //会员卡图片
@property(nonatomic,copy) NSString * money;              //金额
@property(nonatomic,copy) NSString * cardNumber;         //卡号
@property(nonatomic,copy) NSString * integral;           //积分
@property(nonatomic,copy) NSString * expenseNum;         //消费记录
@property(nonatomic,copy) NSString * orderNum;           //订单号
@property(nonatomic,copy) NSString * expensePrice;       //消费金额
@property(nonatomic,copy) NSString * address;            //消费地址
@property(nonatomic,copy) NSString * date;               //消费日期
@property(nonatomic,copy) NSString * backCardImage;      //卡片背景
@property(nonatomic,copy) NSString * emitterCellImage;   //粒子图片
@property(nonatomic) CGFloat emitterPositionX;
@property(nonatomic) CGFloat xAcceleration;
@property(nonatomic) CGFloat yAcceleration;
@property(nonatomic) CGFloat spinRange;



@property(nonatomic,copy) NSString * vipImgUrl;             //会员卡图片
@property(nonatomic,copy) NSString * amount;                //金额
@property(nonatomic,copy) NSString * cardNo;                //卡号
@property(nonatomic,copy) NSString * score;                 //积分
@property(nonatomic,copy) NSString * imgUrl1;
@property(nonatomic,copy) NSString * imgUrl2;
@property(nonatomic,copy) NSString * imgUrl3;
@property(nonatomic,copy) NSString * imgUrl4;
@property(nonatomic,copy) NSString * merchName;
@property(nonatomic,copy) NSString * merchId;                //商户ID


@end
