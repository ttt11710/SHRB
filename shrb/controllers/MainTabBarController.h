//
//  MainTabBarController.h
//  quan-iphone
//
//  Created by Wan Wei on 14-4-23.
//  Copyright (c) 2014年 Wan Wei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BFPaperTabBarController.h>

@interface MainTabBarController : BFPaperTabBarController

+ (MainTabBarController *)shareMainTabBarController;
- (void)showHotView;
@end
