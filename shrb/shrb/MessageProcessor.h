//
//  MessageProcessor.h
//  quan-iphone
//
//  Created by Wan Wei on 14-4-25.
//  Copyright (c) 2014年 Wan Wei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Store.h"

@interface MessageProcessor : NSObject

- (BOOL)process:(Store *)store;

@end
