//
//  PayViewController.m
//  shrb
//
//  Created by PayBay on 15/5/20.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "PayViewController.h"
#import "CompletePayViewController.h"

@interface PayViewController ()
@property (weak, nonatomic) IBOutlet UIView *memberPayView;
@property (weak, nonatomic) IBOutlet UIView *othersPayView;

@end

@implementation PayViewController

@synthesize isMemberPay;
- (void)viewDidLoad {
    [super viewDidLoad];
    
   _othersPayView.hidden = self.isMemberPay?  YES: NO;
    _memberPayView.hidden = !_othersPayView.hidden;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    CompletePayViewController *completePayViewController = segue.destinationViewController;
    completePayViewController.isMemberPay = self.isMemberPay;
}

@end
