//
//  AttributedStyle.m
//  shrb
//
//  Created by PayBay on 15/7/21.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "AttributedStyle.h"

@implementation AttributedStyle

+(AttributedStyle *)attributedName:(NSString *)attributedName value:(id)value range:(NSRange)range
{
    AttributedStyle *style = [[self class] new];
    style.attributedName = attributedName;
    style.value          = value;
    style.range          = range;
    
    return style;
}
@end
