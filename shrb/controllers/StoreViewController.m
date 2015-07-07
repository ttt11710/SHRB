//
//  StoreViewController.m
//  shrb
//  商店首页
//  Created by PayBay on 15/5/20.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "StoreViewController.h"
#import "DeskNumTableViewCell.h"
#import "StoreTableViewCell.h"
#import "TradeModel.h"
#import "ButtonTableViewCell.h"
#import "OrdersViewController.h"
#import "ProductDescriptionView.h"
#import "UITableView+Wave.h"
#import "HJCAjustNumButton.h"
#import "Const.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "QRViewController.h"
#import "SVProgressShow.h"

static StoreViewController *g_StoreViewController = nil;
@interface StoreViewController ()
{
    NSMutableArray *_array;
    NSMutableDictionary *_currentNumDic;
    CGRect _rect;
    CGFloat lastContentOffset;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) HJCAjustNumButton *numbutton;
@property (weak, nonatomic) IBOutlet UIButton *gotopayViewBtn;
@property (nonatomic,strong) UIBezierPath *path;
@property (weak, nonatomic) IBOutlet UIButton *topBtn;
@property (nonatomic,strong) NSMutableArray * dataArray;

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

    [self initData];
    [self initTableView];
}

- (void)initData
{
    
    _currentNumDic = [[NSMutableDictionary alloc]init];
    
    //假数据
    _array = [[NSMutableArray alloc] initWithObjects:
                             @{
                               @"tradeImage" : @"提拉米苏",
                               @"tradeName" : @"提拉米苏",
                               @"memberPrice":@"34",
                               @"originalPrice":@"45",
                               },
                             @{
                               @"tradeImage" : @"蜂蜜提子可颂",
                               @"tradeName" : @"蜂蜜提子可颂",
                               @"memberPrice":@"45",
                               @"originalPrice":@"55",                               },
                             @{
                               @"tradeImage" : @"芝士可颂",
                               @"tradeName" : @"芝士可颂",
                               @"memberPrice":@"22",
                               @"originalPrice":@"33",
                               },
                             @{
                               @"tradeImage" : @"牛奶",
                               @"tradeName" : @"牛奶",
                               @"memberPrice":@"44",
                               @"originalPrice":@"55",
                               },
                             @{
                               @"tradeImage" : @"抹茶拿铁",
                               @"tradeName" : @"抹茶拿铁",
                               @"memberPrice":@"25",
                               @"originalPrice":@"34",
                               },
                             @{
                               @"tradeImage" : @"英式红茶",
                               @"tradeName" : @"英式红茶",
                               @"memberPrice":@"11",
                               @"originalPrice":@"45",
                               },
                             @{
                               @"tradeImage" : @"冰拿铁",
                               @"tradeName" : @"冰拿铁",
                               @"memberPrice":@"23",
                               @"originalPrice":@"55",
                               },
                             @{
                               @"tradeImage" : @"卡布奇诺",
                               @"tradeName" : @"卡布奇诺",
                               @"memberPrice":@"23",
                               @"originalPrice":@"56",
                               },
                             @{
                               @"tradeImage" : @"焦糖玛奇朵",
                               @"tradeName" : @"焦糖玛奇朵",
                               @"memberPrice":@"12",
                               @"originalPrice":@"67",
                               },
                             @{
                               @"tradeImage" : @"美式咖啡",
                               @"tradeName" : @"美式咖啡",
                               @"memberPrice":@"12",
                               @"originalPrice":@"67",
                               },
                             @{
                               @"tradeImage" : @"拿铁",
                               @"tradeName" : @"拿铁",
                               @"memberPrice":@"23",
                               @"originalPrice":@"56",
                               },
                             @{
                               @"tradeImage" : @"浓缩咖啡",
                               @"tradeName" : @"浓缩咖啡",
                               @"memberPrice":@"23",
                               @"originalPrice":@"67",
                               },
                             @{
                               @"tradeImage" : @"摩卡",
                               @"tradeName" : @"摩卡",
                               @"memberPrice":@"56",
                               @"originalPrice":@"77",
                               },
                             @{
                               @"tradeImage" : @"香草拿铁",
                               @"tradeName" : @"香草拿铁",
                               @"memberPrice":@"34",
                               @"originalPrice":@"67",
                               },
                             nil ];
    
    self.dataArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary * dict in _array) {
        TradeModel * model = [[TradeModel alloc] init];
        [model setValuesForKeysWithDictionary:dict];
        [self.dataArray addObject:model];
    }

}

- (void)initTableView
{
    //删除底部多余横线
    _tableView.tableFooterView =[[UIView alloc]init];
    //动画
    [self.tableView reloadDataAnimateWithWave:RightToLeftWaveAnimation];
}

#pragma mark - 更新tableView
- (void)UpdateTableView
{
    NSArray *array = [[NSArray alloc] initWithObjects:@{
                                                       @"tradeImage" : @"冰拿铁",
                                                       @"tradeName" : @"冰拿铁",
                                                       @"memberPrice":@"23",
                                                       @"originalPrice":@"55",
                                                       }, nil];
    
    for (NSDictionary * dict in array) {
        TradeModel * model = [[TradeModel alloc] init];
        [model setValuesForKeysWithDictionary:dict];
        [self.dataArray addObject:model];
    }
    [SVProgressShow showWithStatus:@"更新订单中..."];
    double delayInSeconds = 1.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [SVProgressShow dismiss];
        [self.tableView reloadData];
        [self.tableView scrollRectToVisible:CGRectMake(0, 0, screenWidth, screenHeight) animated:YES];
    });
}

#pragma mark - tableView dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        return 44;
    }
    else if (indexPath.row == [self.dataArray count]) {
        return 60;
    }
    else
        return 68;
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
 //   return [self.dataArray count]+2; 有扫码加单
    return [self.dataArray count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *SimpleTableIdentifier = @"DeskNumTableViewCellIdentifier";
        DeskNumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (cell == nil) {
            cell = [[DeskNumTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
        }
        
        return cell;
    }
   else  if (indexPath.row < [self.dataArray count]+1) {
        static NSString *SimpleTableIdentifier = @"CouponsTableViewCellIdentifier";
        StoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (cell == nil) {
            cell = [[StoreTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
        }
        
        cell.model = self.dataArray[indexPath.row-1];
        
        HJCAjustNumButton *numbutton = [[HJCAjustNumButton alloc] init];
        numbutton.frame = CGRectMake(screenWidth-40, 15, 30, 30);
        // 内容更改的block回调
        numbutton.callBack = ^(NSString *currentNum){
            NSLog(@"%@", currentNum);
            NSLog(@"%ld",(long)indexPath.row-1);
            
            _rect = [self.tableView.superview convertRect:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height) fromView:cell];

            if ([_currentNumDic count] == 0) {
                [_currentNumDic setObject:currentNum forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row-1]];
                //商品起始位置
                UIBezierPath *path = [UIBezierPath bezierPath];
                [path moveToPoint:CGPointMake(46, _rect.origin.y+40)];
                //商品最终位置和其中一个路径位置
                [path addQuadCurveToPoint:CGPointMake(screenWidth/2, screenHeight -20) controlPoint:CGPointMake(screenWidth*0.8, screenHeight * 0.6)];
                _path = path;
                [self startAnimationWithImageNsstring:[NSString stringWithFormat:@"%@.jpg",[_array objectAtIndex:indexPath.row-1][@"tradeImage"]]];
            }
            else {
                //没有插入数据
                if ([_currentNumDic objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row-1]]==nil) {
                    [_currentNumDic setObject:currentNum forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row-1]];
                    //商品起始位置
                    UIBezierPath *path = [UIBezierPath bezierPath];
                    [path moveToPoint:CGPointMake(46, _rect.origin.y+40)];
                    //商品最终位置和其中一个路径位置
                    [path addQuadCurveToPoint:CGPointMake(screenWidth/2, screenHeight -20) controlPoint:CGPointMake(screenWidth/2, screenHeight * 0.6)];
                    _path = path;
                    [self startAnimationWithImageNsstring:[NSString stringWithFormat:@"%@.jpg",[_array objectAtIndex:indexPath.row-1][@"tradeImage"]]];
                }
                else {
                    //减少
                    if ([[_currentNumDic objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row-1]] intValue]>[currentNum intValue]) {
                        [_currentNumDic setObject:currentNum forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row-1]];
                    }
                    //增加
                    else{
                        [_currentNumDic setObject:currentNum forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row-1]];
                        //商品起始位置
                        UIBezierPath *path = [UIBezierPath bezierPath];
                        [path moveToPoint:CGPointMake(46, _rect.origin.y+40)];
                        //商品最终位置和其中一个路径位置
                        [path addQuadCurveToPoint:CGPointMake(screenWidth/2, screenHeight -20) controlPoint:CGPointMake(screenWidth*0.8, screenHeight * 0.6)];
                        _path = path;
                        [self startAnimationWithImageNsstring:[NSString stringWithFormat:@"%@.jpg",[_array objectAtIndex:indexPath.row-1][@"tradeImage"]]];
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
    if (indexPath.row == 0) {
        return;
    }
    else {
        [[DeskNumTableViewCell shareDeskNumTableViewCell] deskTextFieldResignFirstResponder];
    }
    ProductDescriptionView *productDescriptionView=[[ProductDescriptionView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    productDescriptionView.currentIndex = indexPath.row-1;
    [self.view addSubview:productDescriptionView];
    
}

#pragma mark - tableView滚动调用
-(void)scrollViewWillBeginDragging:(UIScrollView*)scrollView {
    
    lastContentOffset = scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y < lastContentOffset )
    {
        //向上
        _topBtn.hidden = NO;
        
    } else if (scrollView. contentOffset.y >lastContentOffset){
        //向下
        CATransition *animation = [CATransition animation];
        animation.type = kCATransitionMoveIn;
        animation.duration = 1.0f;
        [_topBtn.layer addAnimation:animation forKey:nil];
        _topBtn.hidden = YES;
    }
    if (scrollView.contentOffset.y == 0) {
        _topBtn.hidden = YES;
    }
}

- (IBAction)tabViewSetContentToTop:(id)sender {

    //到顶部
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
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

#pragma mark - 进入扫码页面
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
