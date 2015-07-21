//
//  ForeGroundColorStyle.h
//  shrb
//
//  Created by PayBay on 15/7/21.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "AttributedStyle.h"

#define ForeGroundColor(color, range)  [ForeGroundColorStyle withColor:(color) range:(range)]
@interface ForeGroundColorStyle : AttributedStyle

+ (ForeGroundColorStyle *)withColor:(UIColor *)color range:(NSRange)range;

@end
