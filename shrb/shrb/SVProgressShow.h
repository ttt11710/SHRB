//
//  SVProgressShow.h
//  Mercury
//
//  Created by IOS dev on 15/2/2.
//  Copyright (c) 2015年 GangXu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SVProgressShow : NSObject

+ (void)setBackgroundColorAndForegroundColor;
+ (void)showWithStatus:(NSString *)status;
+ (void)showSuccessWithStatus:(NSString *)string;
+ (void)showErrorWithStatus:(NSString *)string;
+ (void)showInfoWithStatus:(NSString *)string;
+ (void)dismiss;

@end
