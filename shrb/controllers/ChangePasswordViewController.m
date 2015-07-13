//
//  ChangePasswordViewController.m
//  shrb
//
//  Created by PayBay on 15/7/13.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController ()

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidLayoutSubviews {
    
    UIButton *backbutton=[UIButton buttonWithType:UIButtonTypeCustom];
    [backbutton setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    backbutton.alpha=0.6;
    backbutton.frame=CGRectMake(10, 20, 50, 50);
    [backbutton addTarget:self action:@selector(backEven) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backbutton];
}

-(void)backEven{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)sureBtnPressed:(id)sender {
    
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}


@end
