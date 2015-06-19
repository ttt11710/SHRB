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
@property(nonatomic,copy) NSString * storeName;     //商店名称
@property(nonatomic,copy) NSString * storeDetail;   //商店描述

@end
