//
//  SuccessAppleRefundViewController.m
//  shrb
//
//  Created by PayBay on 15/9/2.
//  Copyright © 2015年 PayBay. All rights reserved.
//

#import "SuccessAppleRefundViewController.h"
#import "Const.h"

@interface SuccessAppleRefundViewController ()

@end

@implementation SuccessAppleRefundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"退款成功";
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"success"]];
    imageView.frame = CGRectMake(screenWidth/2-35, screenHeight/2-100, 70, 70);
    [self.view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:18];
    label.text = @"恭喜，退款成功";
    [label sizeToFit];
    label.textAlignment = NSTextAlignmentCenter;
    label.center = CGPointMake(screenWidth/2, screenHeight/2);
    [self.view addSubview:label];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.text = @"预计3个工作日内退至您的账户";
    label.font = [UIFont systemFontOfSize:18];
    [label2 sizeToFit];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.center = CGPointMake(screenWidth/2, screenHeight/2+22);
    [self.view addSubview:label2];
    
    
}

@end
