//
//  TBShoppingData.h
//  shrb
//
//  Created by PayBay on 15/9/1.
//  Copyright © 2015年 PayBay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShoppingCardDataItem.h"

@interface TBShoppingData : NSObject

+ (instancetype)currentShoppingData;

+ (void)setCurrentShoppingData:(TBShoppingData *)shoppingData;

- (void)countDown;

@property (nonatomic)NSInteger num;

@property (nonatomic, strong)NSMutableArray *shoppingArray;

@property (nonatomic)NSInteger countTime;


@end
