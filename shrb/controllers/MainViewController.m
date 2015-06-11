//
//  MainViewController.m
//  shrb
//
//  Created by PayBay on 15/6/9.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "MainViewController.h"
#import "Const.h"
#import <pop/POP.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UIButton *textBtn;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = shrbPink;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    //view从黑变白
//    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
//    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    anim.fromValue = @(0.0);  //黑
//    anim.toValue = @(1.0);    //白
//    [self.view pop_addAnimation:anim forKey:@"fade"];
    
    //页面沿着X方向偏移20
//    POPDecayAnimation *anim = [POPDecayAnimation animationWithPropertyNamed:kPOPLayerPositionX];
//    anim.velocity = @(20.);
//    [self.view.layer pop_addAnimation:anim forKey:@"slide"];
    
    //页面居中 大小改变为200 400
//    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
//    anim.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 200, 400)];
//    [self.view.layer pop_addAnimation:anim forKey:@"size"];
    
    
//    POPSpringAnimation *anim = [POPSpringAnimation animation];
//    anim.property = [POPAnimatableProperty propertyWithName:kPOPLayerCornerRadius];
//    anim.toValue = @(15);
//    [self.textBtn.layer pop_addAnimation:anim forKey:@"app"];
    
    
    
    //as库图片对比
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 200, 320, 400)];
//    [self.view addSubview:view];
//    
//    UIImageView *_imageView = [[UIImageView alloc] init];
//    _imageView.image = [UIImage imageNamed:@"卡布奇诺.jpg"];
//    _imageView.frame = CGRectMake(10.0f, 10.0f, 100.0f, 100.0f);
//    [view addSubview:_imageView];
//    
//    ASImageNode *_imageNode = [[ASImageNode alloc] init];
//    _imageNode.backgroundColor = [UIColor lightGrayColor];
//    _imageNode.image = [UIImage imageNamed:@"卡布奇诺.jpg"];
//    _imageNode.frame = CGRectMake(150.0f, 10.0f, 100.0f, 100.0f);
//    [view addSubview:_imageNode.view];
    
}

- (IBAction)hotViewBtn:(id)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"hotView"];
    [viewController setModalPresentationStyle:UIModalPresentationFullScreen];
    
    //等待一定时间后执行
    double delayInSeconds = 0.3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.navigationController pushViewController:viewController animated:YES];
    });

}
- (IBAction)cardViewBtn:(UIButton *)sender {
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Card" bundle:nil];
    UIViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"cardView"];
    [viewController setModalPresentationStyle:UIModalPresentationFullScreen];
    
    //等待一定时间后执行
    double delayInSeconds = 0.3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.navigationController pushViewController:viewController animated:YES];
    });
}
- (IBAction)meViewBtn:(id)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
    UIViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"meView"];
    [viewController setModalPresentationStyle:UIModalPresentationFullScreen];
    double delayInSeconds = 0.3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.navigationController pushViewController:viewController animated:YES];
    });
    
   //ayViewController测试
//    ayViewController *ayayViewCon = [[ayViewController alloc] init];
//    [self.navigationController pushViewController:ayayViewCon animated:YES];
    
}


@end
