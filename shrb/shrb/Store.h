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

@end
