//
//  ShoppingCardDataItem.h
//  shrb
//
//  Created by PayBay on 15/8/31.
//  Copyright © 2015年 PayBay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShoppingCardDataItem : NSObject

@property (readwrite, nonatomic)NSInteger count;
@property (copy, readwrite, nonatomic)NSMutableDictionary *prodList;

@end
