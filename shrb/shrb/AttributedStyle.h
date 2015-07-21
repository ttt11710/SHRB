//
//  AttributedStyle.h
//  shrb
//
//  Created by PayBay on 15/7/21.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AttributedStyle : NSObject

@property (nonatomic, strong) NSString *attributedName; //属性值
@property (nonatomic, strong) id        value;          //值
@property (nonatomic)         NSRange   range;          //取值范围


//遍历构造器
+(AttributedStyle *)attributedName:(NSString *)attributedName value:(id)value range:(NSRange)range;
@end
