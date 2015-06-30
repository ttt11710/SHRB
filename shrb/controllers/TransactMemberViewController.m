//
//  TransactViewController.m
//  shrb
//  注册会员
//  Created by PayBay on 15/5/21.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "TransactMemberViewController.h"
#import "SVProgressShow.h"
#import "Const.h"
#import "ProductIsMemberTableViewController.h"

@interface TransactMemberViewController ()
{
    CGFloat _keyY;
}
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation TransactMemberViewController

@synthesize currentIndex;

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    [self.phoneNumberTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    return YES;
}

#pragma mark - 成为会员
- (IBAction)gotoBecomeMemberView:(id)sender {
    
    //跳转到指定页面
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isMember"];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isMember"];
    
    
    NSString * typesOfShops = [[NSUserDefaults standardUserDefaults] stringForKey:@"typesOfShops"];
    
    //supermarket
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UIViewController *viewController;
    if ([typesOfShops isEqualToString:@"supermarket"]) {
        //超市
        viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"newstoreView"];
        [viewController setModalPresentationStyle:UIModalPresentationFullScreen];
        [SVProgressShow showWithStatus:@"会员卡生成中..."];
        double delayInSeconds = 1.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [SVProgressShow dismiss];
            
            UINavigationController *navController = self.navigationController;
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-3] animated:NO];
            
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ProductIsMemberTableViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"ProductIsMemberTableView"];
            viewController.currentIndex = currentIndex;
            [viewController setModalPresentationStyle:UIModalPresentationFullScreen];
            
            [navController pushViewController:viewController animated:YES];
            
        });
    }
    else if ([typesOfShops isEqualToString:@"order"]) {
        //点餐
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        //小店
        viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"newstoreView"];
        [viewController setModalPresentationStyle:UIModalPresentationFullScreen];
        [SVProgressShow showWithStatus:@"会员卡生成中..."];
        double delayInSeconds = 1.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [SVProgressShow dismiss];
            
            UINavigationController *navController = self.navigationController;
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-3] animated:NO];
            
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ProductIsMemberTableViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"ProductIsMemberTableView"];
            viewController.currentIndex = currentIndex;
            [viewController setModalPresentationStyle:UIModalPresentationFullScreen];
            
            [navController pushViewController:viewController animated:YES];
            
        });
        
    }
    
}


@end
