//
//  CommodityModel.h
//  shrb
//
//  Created by PayBay on 15/6/19.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import <Foundation/Foundation.h>
/*热点商店模型*/
@interface TradeModel : NSObject
@property(nonatomic,copy) NSString * tradeImage;            //商品图片
@property(nonatomic,copy) NSString * tradeName;             //商品名
@property(nonatomic,copy) NSString * memberPrice;           //会员价
@property(nonatomic,copy) NSString * originalPrice;         //原价

@end
