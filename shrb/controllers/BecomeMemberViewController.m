//
//  BecomeMemberViewController.m
//  shrb
//
//  Created by PayBay on 15/5/20.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "BecomeMemberViewController.h"
#import "OrdersViewController.h"

@interface BecomeMemberViewController ()

@end

@implementation BecomeMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isMember"];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isMember"];
    
    OrdersViewController *shoppingCartViewController = segue.destinationViewController;
    shoppingCartViewController.isMember = [[NSUserDefaults standardUserDefaults] boolForKey:@"isMember"];
}

- (IBAction)becomeMemberBtnPressed:(id)sender {
    //跳转到指定页面
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isMember"];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isMember"];
    
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:3] animated:YES];
}
@end
