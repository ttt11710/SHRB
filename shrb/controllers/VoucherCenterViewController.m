//
//  VoucherCenterViewController.m
//  shrb
//
//  Created by PayBay on 15/6/15.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "VoucherCenterViewController.h"
#import "SVProgressShow.h"
#import "Const.h"
#import "CompleteVoucherViewController.h"

@interface VoucherCenterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;
@property (weak, nonatomic) IBOutlet UIButton *alipayBtn;
@property (weak, nonatomic) IBOutlet UIButton *internetbankBtn;

@end

@implementation VoucherCenterViewController

@synthesize viewControllerName;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark textfield的deletage事件
//键盘即将显示的时候回调
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    CGFloat d =  screenHeight - (textField.frame.origin.y +  textField.frame.size.height);
    if (d < 216)
    {
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            self.view.layer.transform = CATransform3DTranslate(self.view.layer.transform, 0, -(216 - d + 40), 0);
            
        } completion:^(BOOL finished) {
            
        }];
        
    }
}
//键盘即将消失的时候回调
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        self.view.layer.transform = CATransform3DIdentity;
        
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - 单击键盘return键回调
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.moneyTextField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if ([[touches anyObject]view]!= self.moneyTextField) {
        [self.moneyTextField resignFirstResponder];
    }
}
#pragma mark - 支付宝充值
- (IBAction)alipayBtnPressde:(id)sender {
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Card" bundle:nil];
    CompleteVoucherViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"CompleteVoucherView"];
    [viewController setModalPresentationStyle:UIModalPresentationFullScreen];
    viewController.viewControllerName = viewControllerName;
    
    [SVProgressShow showWithStatus:@"充值处理中..."];
    
    self.internetbankBtn.userInteractionEnabled = NO;
    double delayInSeconds = 1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [SVProgressShow dismiss];
        [self.navigationController pushViewController:viewController animated:YES];
        self.internetbankBtn.userInteractionEnabled = YES;
    });
}

#pragma mark - 银联充值
- (IBAction)internetbankBtnPressed:(id)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Card" bundle:nil];
    CompleteVoucherViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"CompleteVoucherView"];
    [viewController setModalPresentationStyle:UIModalPresentationFullScreen];
    viewController.viewControllerName = viewControllerName;
    
    [SVProgressShow showWithStatus:@"充值处理中..."];
    self.alipayBtn.userInteractionEnabled = NO;
    double delayInSeconds = 1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [SVProgressShow dismiss];
        [self.navigationController pushViewController:viewController animated:YES];
        self.alipayBtn.userInteractionEnabled = YES;
    });
}

@end
