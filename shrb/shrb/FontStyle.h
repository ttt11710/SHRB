//
//  FontStyle.h
//  shrb
//
//  Created by PayBay on 15/7/21.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "AttributedStyle.h"

@interface FontStyle : AttributedStyle

+ (FontStyle *)withFont:(UIFont *)font range:(NSRange)range;

@end
