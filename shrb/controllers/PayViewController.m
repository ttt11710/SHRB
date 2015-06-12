//
//  PayViewController.m
//  shrb
//  支付界面
//  Created by PayBay on 15/5/20.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "PayViewController.h"
#import "CompletePayViewController.h"
#import "BFPaperButton.h"

@interface PayViewController ()
@property (weak, nonatomic) IBOutlet UIView *memberPayView;
@property (weak, nonatomic) IBOutlet UIView *othersPayView;
@property (weak, nonatomic) IBOutlet BFPaperButton *memberSubmitBtn;

@end

@implementation PayViewController

@synthesize isMemberPay;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _othersPayView.hidden = self.isMemberPay?  YES: NO;
    _memberPayView.hidden = !_othersPayView.hidden;
    _memberSubmitBtn.hidden = _memberPayView.hidden;
    
}

#pragma  mark - storyboard传值
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    CompletePayViewController *completePayViewController = segue.destinationViewController;
    completePayViewController.isMemberPay = self.isMemberPay;
}

@end
