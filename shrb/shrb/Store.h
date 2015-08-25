//
//  Store.h
//  shrb
//
//  Created by PayBay on 15/8/3.
//  Copyright © 2015年 PayBay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Store : NSObject

@property (nonatomic, strong) NSString *storeId;
@property (nonatomic, strong) NSString *storePlistName;
@property (nonatomic, strong) NSString *storeLabel;
@property (nonatomic, strong) NSString *storeDetail;
@property (nonatomic, assign) NSString *storeLogo;
@property (nonatomic, assign) id images;
@property (nonatomic, strong) NSString *simpleStoreDetail;
@property (nonatomic, strong) NSString *storeName;


//新接后台
@property(nonatomic,copy) NSArray * imgUrls;        //图片
@property(nonatomic,copy) NSString * merchDesc;     //商户描述


@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *cardImgUrl;
@property (nonatomic, strong) NSString *cityCode;
@property (nonatomic, strong) NSString *imgUrl1;
@property (nonatomic, strong) NSString *imgUrl2;
@property (nonatomic, strong) NSString *imgUrl3;
@property (nonatomic, strong) NSString *imgUrl4;
@property (nonatomic, assign) NSString *merchId;
@property (nonatomic, strong) NSString *merchName;
@property (nonatomic, strong) NSString *merchTile;
@property (nonatomic, strong) NSString *merchType;
@property (nonatomic, strong) NSString *openTime;
@property (nonatomic, strong) NSString *rechargeRate;
@property (nonatomic, strong) NSString *remainAmount;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *updateTime;
@property (nonatomic, strong) NSString *tradeRate;
@property (nonatomic, assign) NSString *vipDiscount;
@property (nonatomic, strong) NSString *vipImgUrl;

@end
