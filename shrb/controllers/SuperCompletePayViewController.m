//
//  SuperCompletePayViewController.m
//  shrb
//
//  Created by PayBay on 15/7/13.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "SuperCompletePayViewController.h"
#import "LazyFadeInView.h"

@interface SuperCompletePayViewController ()

@property (weak, nonatomic) IBOutlet LazyFadeInView *payInfoView;
@end

@implementation SuperCompletePayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
}

- (void)initView {
    self.payInfoView.text = @"消费记录：\n2015年5月20日                               PM15:47\n完成一次100元的消费交易";
    
}

- (IBAction)completePayBtn:(id)sender {
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-4] animated:YES];
}

@end
