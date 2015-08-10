//
//  SuperCompletePayViewController.m
//  shrb
//
//  Created by PayBay on 15/7/13.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "SuperCompletePayViewController.h"
#import "LazyFadeInView.h"
#import "Const.h"
#import <BFPaperButton.h>

@interface SuperCompletePayViewController ()

@property (weak, nonatomic) IBOutlet LazyFadeInView *payInfoView;
@property (weak, nonatomic) IBOutlet BFPaperButton *completeBtn;
@end

@implementation SuperCompletePayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
}

- (void)initView {
    self.payInfoView.text = @"消费记录：\n2015年5月20日                               PM15:47\n完成一次100元的消费交易";
    self.payInfoView.backgroundColor = shrbLightPink;
    
    self.completeBtn.backgroundColor = shrbPink;
    
}

- (IBAction)completePayBtn:(id)sender {
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    
  //  [self.navigationController.viewControllers count]-4
}

@end
