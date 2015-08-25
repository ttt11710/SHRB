//
//  HotFocusModel.h
//  shrb
//
//  Created by PayBay on 15/6/19.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import <Foundation/Foundation.h>
/*热点商店模型*/
@interface HotFocusModel : NSObject

@property(nonatomic,copy) NSString * status;        //会员状态
@property(nonatomic,copy) NSString * storeId; //店铺Id
@property(nonatomic,copy) NSString * storeLogo; //店铺logo
@property(nonatomic,copy) NSString * storeName;     //商店名称
@property(nonatomic,copy) NSString * storeLabel;     //商店标签
@property(nonatomic,copy) NSString * simpleStoreDetail;   //商店描述(一句话)
@property(nonatomic,copy) NSString * storeDetail; //店铺详情
@property(nonatomic,copy) NSArray * images;   //zhaopian


@end
