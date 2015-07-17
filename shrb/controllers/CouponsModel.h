//
//  CouponsModel.h
//  shrb
//
//  Created by PayBay on 15/6/19.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import <Foundation/Foundation.h>

/*电子券卡模型*/
@interface CouponsModel : NSObject

@property(nonatomic,copy) NSString * couponsImage;    //电子券图片
@property(nonatomic,copy) NSString * money;              //金额
@property(nonatomic,copy) NSString * count;         //张数
@property(nonatomic,copy) NSString * expirationDate;         //截止日期
@property(nonatomic)BOOL canUse;

@end
