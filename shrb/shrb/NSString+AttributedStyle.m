//
//  NSString+AttributedStyle.m
//  shrb
//
//  Created by PayBay on 15/7/21.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "NSString+AttributedStyle.h"


@implementation NSString (AttributedStyle)

- (NSAttributedString *)createrAttributedStringWithStyles:(NSArray *)styles
{
    if (self.length <= 0) {
        return nil;
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    for (int count = 0; count < styles.count; count++) {
        AttributedStyle *style = styles[count];
        
        [attributedString addAttribute:style.attributedName
                                 value:style.value
                                 range:style.range];
    }
    return attributedString;
}


@end
