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
#import "TBUser.h"

@interface VoucherCenterViewController ()


@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *integralLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardNoLabel;


@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;
@property (weak, nonatomic) IBOutlet UIButton *alipayBtn;
@property (weak, nonatomic) IBOutlet UIButton *internetbankBtn;



@property (weak, nonatomic) IBOutlet UIView *internetbankView;
@property (weak, nonatomic) IBOutlet UIView *alipayView;


@property (weak, nonatomic) IBOutlet UIButton *payBtn;

@end

@implementation VoucherCenterViewController

@synthesize cardNo;
@synthesize amount;
@synthesize score;
@synthesize merchId;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

- (void)viewDidLayoutSubviews
{
    
    [super viewDidLayoutSubviews];
    
    self.payBtn.layer.cornerRadius = 4;
    self.payBtn.layer.masksToBounds = YES;
    
}

- (void)initView
{
    NSString *amountString = [self.amount stringValue];
    NSString *scoreString = [self.score stringValue];
    
    NSMutableAttributedString *moneyAttrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"金额:￥%@",amountString]];
    [moneyAttrString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, 3)];
    [moneyAttrString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255.0/255.0 green:212.0/212.0 blue:0 alpha:1] range:NSMakeRange(3, amountString.length+1)];
    [moneyAttrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, 3)];
    [moneyAttrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:24] range:NSMakeRange(3, amountString.length+1)];
    
    self.moneyLabel.attributedText = moneyAttrString;
    
    NSMutableAttributedString *integralAttrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"积分:%@",scoreString]];
    [integralAttrString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, 3)];
    [integralAttrString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255.0/255.0 green:212.0/212.0 blue:0 alpha:1] range:NSMakeRange(3, scoreString.length)];
    [integralAttrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, 3)];
    [integralAttrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:24] range:NSMakeRange(3, scoreString.length)];
    
    self.integralLabel.attributedText = integralAttrString;
    
    
    self.cardNoLabel.text = [NSString stringWithFormat:@"卡号:%@",self.cardNo];
    
    [self.internetbankBtn setImage:[UIImage imageNamed:@"payUncheck"] forState:UIControlStateNormal];
    [self.internetbankBtn setImage:[UIImage imageNamed:@"paycheck"] forState:UIControlStateSelected];
    [self.alipayBtn setImage:[UIImage imageNamed:@"payUncheck"] forState:UIControlStateNormal];
    [self.alipayBtn setImage:[UIImage imageNamed:@"paycheck"] forState:UIControlStateSelected];
    
    self.internetbankBtn.userInteractionEnabled = NO;
    self.alipayBtn.userInteractionEnabled = NO;
    
    self.internetbankBtn.selected = YES;

    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkPayTypePressed:)];
    [self.internetbankView addGestureRecognizer:tap1];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkPayTypePressed:)];
    [self.alipayView addGestureRecognizer:tap2];
    
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

#pragma mark - 单击屏幕键盘消失
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if ([[touches anyObject]view]!= self.moneyTextField) {
        [self.moneyTextField resignFirstResponder];
    }
}

#pragma mark - 选择充值方式
- (void)checkPayTypePressed:(UITapGestureRecognizer *)tap
{
    switch (tap.view.tag) {
        case 0:  //银联充值方式
            if (self.internetbankBtn.selected) {
                return;
            }
            self.internetbankBtn.selected = !self.internetbankBtn.selected;
            self.alipayBtn.selected = !self.internetbankBtn.selected;
            break;
        case 1:  //支付宝充值方式
            if (self.alipayBtn.selected) {
                return;
            }
            self.alipayBtn.selected = !self.alipayBtn.selected;
            self.internetbankBtn.selected = !self.alipayBtn.selected;
            break;
        default:
            break;
    }
}

#pragma mark - 确认支付
- (IBAction)payBtnPressed:(id)sender {
    
    NSLog(@"%@",self.internetbankBtn.selected?@"银联充值方式":@"支付宝充值方式");
    
    
    NSString *url2=[baseUrl stringByAppendingString:@"/card/v1.0/cardMemberRecharge?"];
    [self.requestOperationManager POST:url2 parameters:@{@"userId":[TBUser currentUser].userId,@"token":[TBUser currentUser].token,@"amount":@1000,@"cardNo":self.cardNo,@"chanrgeTypeId":@"1"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"cardMemberRecharge operation = %@ JSON: %@", operation,responseObject);
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Card" bundle:nil];
        CompleteVoucherViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"CompleteVoucherView"];
        [viewController setModalPresentationStyle:UIModalPresentationFullScreen];
        viewController.merchId = self.merchId;
        viewController.cardNo = self.cardNo;
        [SVProgressShow showWithStatus:@"充值处理中..."];
        
        double delayInSeconds = 1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [SVProgressShow dismiss];
            [self.navigationController pushViewController:viewController animated:YES];
        });
        

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:++++%@",error.localizedDescription);
    }];
    
}


#pragma mark - 支付宝充值
- (IBAction)alipayBtnPressde:(id)sender {
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Card" bundle:nil];
    CompleteVoucherViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"CompleteVoucherView"];
    [viewController setModalPresentationStyle:UIModalPresentationFullScreen];
    
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
