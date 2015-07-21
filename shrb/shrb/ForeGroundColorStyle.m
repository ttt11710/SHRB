//
//  ForeGroundColorStyle.m
//  shrb
//
//  Created by PayBay on 15/7/21.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "ForeGroundColorStyle.h"

@implementation ForeGroundColorStyle

+ (ForeGroundColorStyle *)withColor:(UIColor *)color range:(NSRange)range {
    ForeGroundColorStyle *style = [ForeGroundColorStyle attributedName:NSForegroundColorAttributeName
                                                                 value:color
                                                                 range:range];
    
    return style;
}
@end
