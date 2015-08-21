//
//  OrderModel.h
//  shrb
//
//  Created by PayBay on 15/8/19.
//  Copyright © 2015年 PayBay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderModel : NSObject

@property(nonatomic,copy) NSString * tradeImage;            //商品图片
@property(nonatomic,copy) NSString * tradeName;             //商品名
@property(nonatomic,copy) NSString * memberPrice;           //会员价
@property(nonatomic,copy) NSString * originalPrice;         //原价
@property(nonatomic,copy) NSString * tradeDescription;      //商品描述
@property(nonatomic,copy) NSString * amount;                //数量
@property(nonatomic,copy) NSString * money;                 //总价

@end
