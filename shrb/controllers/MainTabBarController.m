//
//  MainTabBarController.m
//  quan-iphone
//
//  Created by Wan Wei on 14-4-23.
//  Copyright (c) 2014年 Wan Wei. All rights reserved.
//

#import "MainTabBarController.h"


static MainTabBarController *g_MainTabBarController = nil;
@interface MainTabBarController ()<UITabBarControllerDelegate>
{
    NSUInteger _currentSelectedIndex;
}

@end

@implementation MainTabBarController {
    NSInteger _newMessageCount;
}

+ (MainTabBarController *)shareMainTabBarController
{
    return g_MainTabBarController;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    
    _currentSelectedIndex = -1 ;
    g_MainTabBarController = self;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _newMessageCount = 0;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    self.tabBar.hidden = NO;
    viewController.tabBarItem.badgeValue = nil;
    if (self.selectedIndex == 1) {
        _newMessageCount = 0;
    }
    else if (self.selectedIndex == 0) {
        if (_currentSelectedIndex == 0) {
            
        }
    }
    _currentSelectedIndex = self.selectedIndex;
}

- (void)showHotView
{
   // self.selectedIndex = 0 ;
    [self selectTabAtIndex:0 animated:YES];
}
@end
