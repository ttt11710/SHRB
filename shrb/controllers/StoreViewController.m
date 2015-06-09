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

@interface StoreViewController ()
{
    NSMutableArray *_data;
    UIImageView *_imageView;
    NSMutableDictionary *_currentNumDic;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
     [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    _data = [[NSMutableArray alloc] initWithObjects:@"单人套餐",@"双人套餐",@"三人套餐",@"四人套餐", nil];
    _currentNumDic = [[NSMutableDictionary alloc]init];
    [self.tableView reloadDataAnimateWithWave:RightToLeftWaveAnimation];
    
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    _imageView.image = [UIImage imageNamed:@"官方头像"];
    _imageView.center = CGPointMake(200, screenHeight * 0.7);
    
    [self.view addSubview:_imageView];
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
        cell.couponsImageView.image = [UIImage imageNamed:@"官方头像"];
        
        
        HJCAjustNumButton *numbutton = [[HJCAjustNumButton alloc] init];
        numbutton.frame = CGRectMake(screenWidth-90, 30, 80, 25);
        // 内容更改的block回调
        numbutton.callBack = ^(NSString *currentNum){
            NSLog(@"%@", currentNum);
            NSLog(@"%ld",(long)indexPath.row);
            
            if ([_currentNumDic count] == 0) {
                [_currentNumDic setObject:currentNum forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
                //商品起始位置
                self.path = [UIBezierPath bezierPath];
                [self.path moveToPoint:CGPointMake(46, indexPath.row*80+104)];
                //商品最终位置和其中一个路径位置
                [self.path addQuadCurveToPoint:CGPointMake(screenWidth/2, screenHeight -20) controlPoint:CGPointMake(screenWidth*0.8, screenHeight * 0.6)];
                _path = self.path;
                [self startAnimation];
            }
            if ([_currentNumDic objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]==nil) {
                [_currentNumDic setObject:currentNum forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
                //商品起始位置
                self.path = [UIBezierPath bezierPath];
                [self.path moveToPoint:CGPointMake(46, indexPath.row*80+104)];
                //商品最终位置和其中一个路径位置
                [self.path addQuadCurveToPoint:CGPointMake(screenWidth/2, screenHeight -20) controlPoint:CGPointMake(screenWidth*0.8, screenHeight * 0.6)];
                _path = self.path;
                [self startAnimation];
            }
            else {
                if ([_currentNumDic objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]>currentNum) {
                    [_currentNumDic setObject:currentNum forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
                }
                else{
                    [_currentNumDic setObject:currentNum forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
                    //商品起始位置
                    self.path = [UIBezierPath bezierPath];
                    [self.path moveToPoint:CGPointMake(46, indexPath.row*80+104)];
                    //商品最终位置和其中一个路径位置
                    [self.path addQuadCurveToPoint:CGPointMake(screenWidth/2, screenHeight -20) controlPoint:CGPointMake(screenWidth*0.8, screenHeight * 0.6)];
                    _path = self.path;
                    [self startAnimation];
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


-(void)startAnimation
{
    if (!layer) {
        self.gotopayViewBtn.enabled = NO;
        layer = [CALayer layer];
        layer.contents = (__bridge id)[UIImage imageNamed:@"官方头像"].CGImage;
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
    //    [anim def];
    if (anim == [layer animationForKey:@"group"]) {
        self.gotopayViewBtn.enabled = YES;
        [layer removeFromSuperlayer];
        layer = nil;
//        _cnt++;
//        if (_cnt) {
//            _cntLabel.hidden = NO;
//        }
        CATransition *animation = [CATransition animation];
        animation.duration = 0.25f;
//        _cntLabel.text = [NSString stringWithFormat:@"%d",_cnt];
//        [_cntLabel.layer addAnimation:animation forKey:nil];
        
        CABasicAnimation *shakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
        shakeAnimation.duration = 0.25f;
        shakeAnimation.fromValue = [NSNumber numberWithFloat:-5];
        shakeAnimation.toValue = [NSNumber numberWithFloat:5];
        shakeAnimation.autoreverses = YES;
        [_imageView.layer addAnimation:shakeAnimation forKey:nil];
    }
}

#pragma  mark - storyboard传值
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    OrdersViewController *shoppingCartViewController = segue.destinationViewController;
    shoppingCartViewController.isMember = [[NSUserDefaults standardUserDefaults] boolForKey:@"isMember"];
}

@end
