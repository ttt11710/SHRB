//
//  BecomeMemberViewController.m
//  shrb
//  完成注册
//  Created by PayBay on 15/5/20.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "BecomeMemberViewController.h"
#import "OrdersViewController.h"
#import "SVProgressShow.h"
#import "Const.h"

@interface BecomeMemberViewController ()

@end

@implementation BecomeMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma  mark - 成为会员
- (IBAction)becomeMemberBtnPressed:(id)sender {
    
    //跳转到指定页面
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isMember"];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isMember"];
    
    [SVProgressShow showSuccessWithStatus:@"duang的一声，您成为会员啦！"];
    
    double delayInSeconds = 1.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [SVProgressShow dismiss];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-3] animated:YES];
    });

}


@end
