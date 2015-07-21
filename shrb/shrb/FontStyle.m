//
//  FontStyle.m
//  shrb
//
//  Created by PayBay on 15/7/21.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "FontStyle.h"

@implementation FontStyle

+ (FontStyle *)withFont:(UIFont *)font range:(NSRange)range
{
    FontStyle *style = [FontStyle attributedName:NSFontAttributeName
                                           value:font
                                           range:range];
    
    return style;
    
}

@end
