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
#import "ShoppingCardView.h"

@interface ShoppingNumLabel1 : UILabel
{
    NSInteger _num;
}

@property (assign, readwrite, nonatomic)NSInteger num;

@end

@implementation ShoppingNumLabel1

- (void)setNum:(NSInteger)num
{
    _num = num;
    self.text = [NSString stringWithFormat:@"%ld",(long)num];
}
@end

static StoreViewController *g_StoreViewController = nil;
static NSInteger constantCountTime = 20*60;
static NSInteger countTime = 20*60;
@interface StoreViewController ()
{
    NSMutableArray *_array;
    NSMutableDictionary *_currentNumDic;
    CGRect _rect;
    CGFloat lastContentOffset;
    
    NSTimer *_timer;
   // UIView *selectTypeTableViewBackView;
   // UITableView *selectTypeTableView;
    BOOL showSelectTypeTableView;
    
    
    ShoppingCardView *_myShoppingCardView;
}

@property (weak, nonatomic) IBOutlet UIView *selectTypeTableViewBackView;
@property (weak, nonatomic) IBOutlet UITableView *selectTypeTableView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) HJCAjustNumButton *numbutton;
@property (weak, nonatomic) IBOutlet UIButton *gotopayViewBtn;
@property (weak, nonatomic) IBOutlet UIView *shoppingCardView;
@property (weak, nonatomic) IBOutlet UIImageView *shoppingCardImageView;
@property (weak, nonatomic) IBOutlet ShoppingNumLabel1 *shoppingNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *shoppingFixLabel;
@property (weak, nonatomic) IBOutlet UILabel *countDownLabel;

@property (nonatomic,strong) UIBezierPath *path;
@property (weak, nonatomic) IBOutlet UIButton *topBtn;

@property (nonatomic,strong) NSMutableArray * modelArray;
@property (nonatomic, strong) NSMutableArray *plistArr;

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

    [self initView];
    [self initData];
    [self initTableView];
    
    self.shoppingCardView.layer.cornerRadius = 4;
   // self.shoppingCardView.layer.borderColor = shrbTableViewColor.CGColor;
   // self.shoppingCardView.layer.borderWidth = 2;
    self.shoppingCardView.layer.masksToBounds = YES;
    self.shoppingCardView.hidden = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoPayView)];
    [self.shoppingCardView addGestureRecognizer:tap];
    
    self.shoppingNumLabel.num = 0 ;
    self.shoppingNumLabel.layer.cornerRadius = 11;
    self.shoppingNumLabel.layer.masksToBounds = YES;
    self.shoppingNumLabel.hidden = YES;
    
    self.shoppingFixLabel.hidden = YES;
    self.countDownLabel.hidden = YES;
    self.countDownLabel.text = @"20:00";
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"countTime"];
    [[NSUserDefaults standardUserDefaults] setInteger:1200 forKey:@"countTime"];
}


- (void)viewDidLayoutSubviews
{
    countTime = [[NSUserDefaults standardUserDefaults] integerForKey:@"countTime"];
    
    if (self.shoppingCardView.hidden && countTime < 1200 && countTime > 0 && _myShoppingCardView == nil) {
        _myShoppingCardView = [[ShoppingCardView alloc] initWithFrame:CGRectMake(16, screenHeight-44-20-60, 100, 40)];
        _myShoppingCardView.shoppingNumLabel.num = 10;
        [self.view insertSubview:_myShoppingCardView aboveSubview:self.view];
    }
    
    else {
        [_myShoppingCardView showShoppingCard];
    }
}


- (void)initView
{
    
    self.title = [[NSUserDefaults standardUserDefaults] stringForKey:@"storeName"];
    
    UIBarButtonItem *selectType = [[UIBarButtonItem alloc] initWithTitle:@"分类" style:UIBarButtonItemStylePlain target:self action:@selector(selectType)];
    self.navigationItem.rightBarButtonItem = selectType;
    
    [self.gotopayViewBtn setBackgroundColor:shrbPink];
}

- (void)initData
{
    
    NSString *storeFile = [[NSUserDefaults standardUserDefaults] stringForKey:@"storePlistName"];
    
    self.plistArr =[[NSMutableArray alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:storeFile ofType:@"plist"]];
    
    self.modelArray = [[NSMutableArray alloc] init];

}

- (void)initTableView
{
    //去除tableview顶部留白
    self.automaticallyAdjustsScrollViewInsets = false;
   
    //删除底部多余横线
    _tableView.tableFooterView =[[UIView alloc]init];
    
    self.selectTypeTableView.tableFooterView = [[UIView alloc] init];
    //动画
    [self.tableView reloadDataAnimateWithWave:RightToLeftWaveAnimation];
}


#pragma mark - 分类选择
- (void)selectType
{
    showSelectTypeTableView = !showSelectTypeTableView;
    if (showSelectTypeTableView) {
        self.selectTypeTableViewBackView.hidden = NO;
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            self.selectTypeTableView.layer.transform = CATransform3DMakeTranslation(-screenWidth/2, 0, 0);
            self.selectTypeTableViewBackView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
            
        } completion:^(BOOL finished) {
            
        }];
    }
    else {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            self.selectTypeTableView.layer.transform = CATransform3DIdentity;
            self.selectTypeTableViewBackView.backgroundColor = [UIColor clearColor];
            
        } completion:^(BOOL finished) {
            
            self.selectTypeTableViewBackView.hidden = YES;
        }];
    }
}

#pragma mark - tableView dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.selectTypeTableView) {
        return 44;
    }
    else {
        if (indexPath.section == 0) {
            return 44;
        }
        
        else
            return 60;
    }
 }

#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView != self.selectTypeTableView) {
        return [self.plistArr count]+1;
    }
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView != self.selectTypeTableView) {
        if (section == 0) {
            return @"";
        }
        return [self.plistArr objectAtIndex:section-1][@"type"];
    }
    else
        return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView != self.selectTypeTableView) {
        return section == 0? 0:30;
    }
    else
        return 0;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat height ;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, height)] ;
    [headerView setBackgroundColor:shrbSectionColor];
    
    if (tableView != self.selectTypeTableView) {
        height = section == 0?0:30;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, (height-18)*0.5, tableView.bounds.size.width - 10, 18)];
        label.textColor = shrbText;
        
        label.backgroundColor = [UIColor clearColor];
        [headerView addSubview:label];
        label.text = section == 0?@"":[self.plistArr objectAtIndex:section-1][@"type"];
        return  headerView;
    }
    else {
        height = 0 ;
        return headerView;
    }
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.selectTypeTableView) {
        return [self.plistArr count];
    }
    else {
        return section == 0?1:[[self.plistArr objectAtIndex:section-1][@"info"] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.selectTypeTableView) {
        static NSString *SimpleTableIdentifier = @"cellId";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        cell.textLabel.text = [self.plistArr objectAtIndex:indexPath.row][@"type"];
        cell.textLabel.textColor = shrbText;
        
        return cell;
    }
    else {
        if (indexPath.section == 0) {
            static NSString *SimpleTableIdentifier = @"DeskNumTableViewCellIdentifier";
            DeskNumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            if (cell == nil) {
                cell = [[DeskNumTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
            }
            
            return cell;
        }
        else  if (indexPath.section < [self.plistArr count]+1) {
            static NSString *SimpleTableIdentifier = @"CouponsTableViewCellIdentifier";
            StoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            if (cell == nil) {
                cell = [[StoreTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
            }
            
            [self.modelArray removeAllObjects];
            for (NSDictionary * dict in [self.plistArr objectAtIndex:indexPath.section-1][@"info"]) {
                TradeModel * model = [[TradeModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [self.modelArray addObject:model];
            }
            
            cell.model = self.modelArray[indexPath.row];
            
            HJCAjustNumButton *numbutton = [[HJCAjustNumButton alloc] init];
            numbutton.frame = CGRectMake(screenWidth-40, 15, 30, 30);
            // 内容更改的block回调
            numbutton.callBack = ^(NSString *currentNum){
                
                NSLog(@"%ld",(long)indexPath.row);
                
                if (_myShoppingCardView == nil) {
                    _myShoppingCardView = [[ShoppingCardView alloc] initWithFrame:CGRectMake(16, screenHeight-44-20-60, 100, 40)];
                    _myShoppingCardView.shoppingNumLabel.num = 10;
                    [self.view insertSubview:_myShoppingCardView aboveSubview:self.view];
                }

                
                if (_myShoppingCardView.hidden) {
                    self.shoppingCardView.hidden = NO;
                }
                
                _rect = [self.tableView.superview convertRect:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height) fromView:cell];
                
                
                NSLog(@"%@",[[self.plistArr objectAtIndex:indexPath.section-1][@"info"] objectAtIndex:indexPath.row][@"tradeImage"]);
                
                
                if ([_currentNumDic count] == 0) {
                    [_currentNumDic setObject:currentNum forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row-1]];
                    //商品起始位置
                    UIBezierPath *path = [UIBezierPath bezierPath];
                    [path moveToPoint:CGPointMake(46, _rect.origin.y+40)];
                    //商品最终位置和其中一个路径位置
                    [path addQuadCurveToPoint:CGPointMake(80, screenHeight -100) controlPoint:CGPointMake(screenWidth*0.5, screenHeight * 0.5)];
                    _path = path;
                    [self startAnimationWithImageNsstring:[NSString stringWithFormat:@"%@.jpg",  [[self.plistArr objectAtIndex:indexPath.section-1][@"info"] objectAtIndex:indexPath.row][@"tradeImage"]]];
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
                        [self startAnimationWithImageNsstring:[NSString stringWithFormat:@"%@.jpg",  [[self.plistArr objectAtIndex:indexPath.section-1][@"info"] objectAtIndex:indexPath.row][@"tradeImage"]]];
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
                            [self startAnimationWithImageNsstring:[NSString stringWithFormat:@"%@.jpg",  [[self.plistArr objectAtIndex:indexPath.section-1][@"info"] objectAtIndex:indexPath.row][@"tradeImage"]]];
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
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.selectTypeTableView) {
        showSelectTypeTableView = !showSelectTypeTableView;
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            self.selectTypeTableView.layer.transform = CATransform3DIdentity;
            self.selectTypeTableViewBackView.backgroundColor = [UIColor clearColor];
            
        } completion:^(BOOL finished) {
            
            self.selectTypeTableViewBackView.hidden = YES;
            
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.row+1] animated:YES scrollPosition:UITableViewScrollPositionTop];
        }];
    }
    else {
        
        if (indexPath.section == 0) {
            return;
        }
        else {
            [[DeskNumTableViewCell shareDeskNumTableViewCell] deskTextFieldResignFirstResponder];
        }
        
        ProductDescriptionView *productDescriptionView=[[ProductDescriptionView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        productDescriptionView.currentSection = indexPath.section-1;
        productDescriptionView.currentRow = indexPath.row;
        [self.view addSubview:productDescriptionView];
    }
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
    self.selectTypeTableViewBackView.hidden = NO;
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
    self.shoppingNumLabel.num ++ ;
    [self showShoppingCard];

    self.selectTypeTableViewBackView.hidden = YES;
    if (anim == [layer animationForKey:@"group"]) {
        self.gotopayViewBtn.enabled = YES;
        [layer removeFromSuperlayer];
        layer = nil;
    }
}

#pragma mark - 显示购物车
- (void)showShoppingCard
{
    if (!_myShoppingCardView.hidden) {
        _myShoppingCardView.shoppingNumLabel.num ++ ;
        return ;
    }
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.shoppingCardImageView.layer.transform = CATransform3DMakeTranslation(-(self.shoppingCardView.frame.size.width/2-20), 0, 0);
        
    } completion:^(BOOL finished) {
        
        self.shoppingNumLabel.hidden = NO;
        self.shoppingFixLabel.hidden = NO;
        self.countDownLabel.hidden = NO;
        if (self.shoppingNumLabel.num == 1) {
            [self countDown];
            self.shoppingFixLabel.alpha = 0 ;
            self.countDownLabel.alpha = 0 ;
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                
                self.shoppingFixLabel.alpha = 1;
                self.countDownLabel.alpha = 1 ;
            } completion:^(BOOL finished) {
                
            }];
        }
    }];

}

#pragma mark - 倒计时功能

- (void)countDown
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];

}

- (void)timerFireMethod:(NSTimer *)timer
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *today = [NSDate date];//当前时间
    NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:--countTime];
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *d = [calendar components:unitFlags fromDate:today toDate:fireDate options:0];//计算时间差
    self.countDownLabel.text = [NSString stringWithFormat:@"%ld:%ld",(long)[d minute],(long)[d second]];
    if (d.second <10) {
        self.countDownLabel.text = [NSString stringWithFormat:@"%ld:0%ld",(long)[d minute],(long)[d second]];
    }
    if (d.minute <10) {
        self.countDownLabel.text = [NSString stringWithFormat:@"0%ld:%ld",(long)[d minute],(long)[d second]];
    }
    if (d.minute <10 && d.second < 10) {
        self.countDownLabel.text = [NSString stringWithFormat:@"0%ld:0%ld",(long)[d minute],(long)[d second]];
    }
    
    if (d.minute == 0 && d.second == 0) {
        [_timer invalidate];
        self.shoppingCardView.hidden = YES;
        self.shoppingCardImageView.layer.transform = CATransform3DIdentity;
        self.shoppingNumLabel.hidden = YES;
        self.shoppingFixLabel.hidden = YES;
        self.countDownLabel.hidden = YES;
        self.countDownLabel.text = @"20:00";
        countTime = constantCountTime;
        self.shoppingNumLabel.num = 0 ;
        [SVProgressShow showInfoWithStatus:@"订单过期！"];
    }
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"countTime"];
    [[NSUserDefaults standardUserDefaults] setInteger:countTime forKey:@"countTime"];
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

#pragma mark - 进入支付页面
- (void)gotoPayView
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"OrdersView"];
    [viewController setModalPresentationStyle:UIModalPresentationFullScreen];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma  mark - storyboard传值
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    OrdersViewController *shoppingCartViewController = segue.destinationViewController;
    shoppingCartViewController.isMember = [[NSUserDefaults standardUserDefaults] boolForKey:@"isMember"];
}

@end
