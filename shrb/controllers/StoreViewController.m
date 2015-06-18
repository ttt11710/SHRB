//
//  StoreViewController.m
//  shrb
//  商店首页
//  Created by PayBay on 15/5/20.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "StoreViewController.h"
#import "StoreTableViewCell.h"
#import "ButtonTableViewCell.h"
#import "OrdersViewController.h"
#import "ProductDescriptionView.h"
#import "UITableView+Wave.h"
#import "HJCAjustNumButton.h"
#import "Const.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "QRViewController.h"

static StoreViewController *g_StoreViewController = nil;
@interface StoreViewController ()
{
    NSMutableArray *_data;
    NSMutableDictionary *_currentNumDic;
    CGRect _rect;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) HJCAjustNumButton *numbutton;
@property (weak, nonatomic) IBOutlet UIButton *gotopayViewBtn;
@property (nonatomic,strong) UIBezierPath *path;

@property (nonatomic,retain)ProductDescriptionView *productDescriptionView;
@end

@implementation StoreViewController{
    CALayer     *layer;
}

+ (StoreViewController *)shareStoreViewController
{
    return g_StoreViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    g_StoreViewController = self;
    
     [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    _data = [[NSMutableArray alloc] initWithObjects:@"冰拿铁",@"卡布奇诺",@"焦糖玛奇朵",@"美式咖啡",@"拿铁",@"浓缩咖啡",@"摩卡",@"香草拿铁", nil];
    _currentNumDic = [[NSMutableDictionary alloc]init];
    [self.tableView reloadDataAnimateWithWave:RightToLeftWaveAnimation];
}

- (void)UpdateTableView
{
    [_data addObject:@"冰拿铁"];
    [self.tableView reloadData];
}
#pragma mark - tableView dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row < [_data count]?80:46;
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_data count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [_data count]) {
        static NSString *SimpleTableIdentifier = @"CouponsTableViewCellIdentifier";
        StoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (cell == nil) {
            cell = [[StoreTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
        }
        cell.tradeNameLabel.text = [_data objectAtIndex:indexPath.row];
        cell.couponsImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",[_data objectAtIndex:indexPath.row]]];
        
        
        HJCAjustNumButton *numbutton = [[HJCAjustNumButton alloc] init];
        numbutton.frame = CGRectMake(screenWidth-90, 30, 80, 25);
        // 内容更改的block回调
        numbutton.callBack = ^(NSString *currentNum){
            NSLog(@"%@", currentNum);
            NSLog(@"%ld",(long)indexPath.row);
            
            _rect = [self.tableView.superview convertRect:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height) fromView:cell];

            if ([_currentNumDic count] == 0) {
                [_currentNumDic setObject:currentNum forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
                //商品起始位置
                UIBezierPath *path = [UIBezierPath bezierPath];
                [path moveToPoint:CGPointMake(46, _rect.origin.y+40)];
                //商品最终位置和其中一个路径位置
                [path addQuadCurveToPoint:CGPointMake(screenWidth/2, screenHeight -20) controlPoint:CGPointMake(screenWidth*0.8, screenHeight * 0.6)];
                _path = path;
                [self startAnimationWithImageNsstring:[NSString stringWithFormat:@"%@.jpg",[_data objectAtIndex:indexPath.row]]];
            }
            else {
                //没有插入数据
                if ([_currentNumDic objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]==nil) {
                    [_currentNumDic setObject:currentNum forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
                    //商品起始位置
                    UIBezierPath *path = [UIBezierPath bezierPath];
                    [path moveToPoint:CGPointMake(46, _rect.origin.y+40)];
                    //商品最终位置和其中一个路径位置
                    [path addQuadCurveToPoint:CGPointMake(screenWidth/2, screenHeight -20) controlPoint:CGPointMake(screenWidth/2, screenHeight * 0.6)];
                    _path = path;
                    [self startAnimationWithImageNsstring:[NSString stringWithFormat:@"%@.jpg",[_data objectAtIndex:indexPath.row]]];
                }
                else {
                    //减少
                    if ([[_currentNumDic objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]] intValue]>[currentNum intValue]) {
                        [_currentNumDic setObject:currentNum forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
                    }
                    //增加
                    else{
                        [_currentNumDic setObject:currentNum forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
                        //商品起始位置
                        UIBezierPath *path = [UIBezierPath bezierPath];
                        [path moveToPoint:CGPointMake(46, _rect.origin.y+40)];
                        //商品最终位置和其中一个路径位置
                        [path addQuadCurveToPoint:CGPointMake(screenWidth/2, screenHeight -20) controlPoint:CGPointMake(screenWidth*0.8, screenHeight * 0.6)];
                        _path = path;
                        [self startAnimationWithImageNsstring:[NSString stringWithFormat:@"%@.jpg",[_data objectAtIndex:indexPath.row]]];
                    }
                }
            }
        };
        
        // 加到父控件上
        [cell addSubview:numbutton];
        return cell;
    }
    else
    {
        static NSString *SimpleTableIdentifier = @"ButtonTableViewCellIdentifier";
        ButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (cell == nil) {
            cell = [[ButtonTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
        }
        
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_productDescriptionView==nil) {
        _productDescriptionView=[[ProductDescriptionView alloc]initWithFrame:[UIScreen mainScreen].bounds];
       [self.view addSubview:_productDescriptionView];
    }
    self.productDescriptionView.hidden=NO;

}

#pragma mark - 购物动画
-(void)startAnimationWithImageNsstring:(NSString *)imageNsstring
{
    if (!layer) {
        self.gotopayViewBtn.enabled = NO;
        layer = [CALayer layer];
        layer.contents = (__bridge id)[UIImage imageNamed:imageNsstring].CGImage;
        layer.contentsGravity = kCAGravityResizeAspectFill;
        layer.bounds = CGRectMake(screenWidth*0.1, screenHeight * 0.5, 50, 50);
        [layer setCornerRadius:CGRectGetHeight([layer bounds]) / 2];
        layer.masksToBounds = YES;
        layer.position =CGPointMake(screenWidth*0.1, screenHeight * 0.5);
        [self.view.layer addSublayer:layer];
    }
    [self groupAnimation];
}
-(void)groupAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = _path.CGPath;
    animation.rotationMode = kCAAnimationRotateAuto;
    CABasicAnimation *expandAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    expandAnimation.duration = 0.5f;
    expandAnimation.fromValue = [NSNumber numberWithFloat:1];
    expandAnimation.toValue = [NSNumber numberWithFloat:2.0f];
    expandAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CABasicAnimation *narrowAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    narrowAnimation.beginTime = 0.5;
    narrowAnimation.fromValue = [NSNumber numberWithFloat:2.0f];
    narrowAnimation.duration = 1.0f;
    narrowAnimation.toValue = [NSNumber numberWithFloat:0.5f];
    
    narrowAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup *groups = [CAAnimationGroup animation];
    groups.animations = @[animation,expandAnimation,narrowAnimation];
    groups.duration = 1.0f;
    groups.removedOnCompletion=NO;
    groups.fillMode=kCAFillModeForwards;
    groups.delegate = self;
    [layer addAnimation:groups forKey:@"group"];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (anim == [layer animationForKey:@"group"]) {
        self.gotopayViewBtn.enabled = YES;
        [layer removeFromSuperlayer];
        layer = nil;
    }
}

#pragma mark - 扫描二维码
- (IBAction)scanBtnPressed:(id)sender {
    if ([self validateCamera]) {
        
        [self showQRViewController];
        
    } else {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有摄像头或摄像头不可用" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

- (BOOL)validateCamera {
    
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] &&
    [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (void)showQRViewController {
    
    QRViewController *qrVC = [[QRViewController alloc] init];
    [self.navigationController pushViewController:qrVC animated:YES];
}

#pragma  mark - storyboard传值
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    OrdersViewController *shoppingCartViewController = segue.destinationViewController;
    shoppingCartViewController.isMember = [[NSUserDefaults standardUserDefaults] boolForKey:@"isMember"];
}

@end
