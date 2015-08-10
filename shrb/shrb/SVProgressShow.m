//
//  SVProgressShow.m
//  Mercury
//
//  Created by IOS dev on 15/2/2.
//  Copyright (c) 2015年 GangXu. All rights reserved.
//

#import "SVProgressShow.h"
#import "SVProgressHUD.h"
#import "Const.h"

@implementation SVProgressShow

+ (void)setBackgroundColorAndForegroundColor
{
    [SVProgressHUD setFont:[UIFont boldSystemFontOfSize:18.0]];
    [SVProgressHUD setBackgroundColor:shrbPink];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD show];
}

+ (void)showWithStatus:(NSString *)status
{
    [self setBackgroundColorAndForegroundColor];
    [SVProgressHUD showWithStatus:status];
}

+ (void)showSuccessWithStatus:(NSString *)string
{
    [self setBackgroundColorAndForegroundColor];
    [SVProgressHUD showSuccessWithStatus:string];
}

+ (void)showErrorWithStatus:(NSString *)string
{
    [self setBackgroundColorAndForegroundColor];
    [SVProgressHUD showErrorWithStatus:string];
}

+ (void)showInfoWithStatus:(NSString *)string
{
    [self setBackgroundColorAndForegroundColor];
    [SVProgressHUD showInfoWithStatus:string];
}

+ (void)dismiss
{
    [SVProgressHUD dismiss];
}
@end
