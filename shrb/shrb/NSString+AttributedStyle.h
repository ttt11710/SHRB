//
//  NSString+AttributedStyle.h
//  shrb
//
//  Created by PayBay on 15/7/21.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AttributedStyle.h"
#import "ForeGroundColorStyle.h"
#import "FontStyle.h"

@interface NSString (AttributedStyle)

- (NSAttributedString *)createrAttributedStringWithStyles:(NSArray *)styles;

@end
