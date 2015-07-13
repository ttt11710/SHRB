//
//  LoginViewController.m
//  shrb
//
//  Created by PayBay on 15/7/13.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "LoginViewController.h"
#import "MainTabBarController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
}

- (IBAction)loginInBtnPressed:(id)sender {
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"IsLogin"];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancelBtnPressed:(id)sender {
    
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController popViewControllerAnimated:NO];
    
    [[MainTabBarController shareMainTabBarController] showHotView];
}


@end
