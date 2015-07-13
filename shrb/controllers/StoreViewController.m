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
    
   // UIView *selectTypeTableViewBackView;
   // UITableView *selectTypeTableView;
    BOOL showSelectTypeTableView;
}

@property (weak, nonatomic) IBOutlet UIView *selectTypeTableViewBackView;
@property (weak, nonatomic) IBOutlet UITableView *selectTypeTableView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) HJCAjustNumButton *numbutton;
@property (weak, nonatomic) IBOutlet UIButton *gotopayViewBtn;
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
}

- (void)initView
{
    UIBarButtonItem *selectType = [[UIBarButtonItem alloc] initWithTitle:@"分类" style:UIBarButtonItemStylePlain target:self action:@selector(selectType)];
    self.navigationItem.rightBarButtonItem = selectType;
}

- (void)initData
{
    
    NSString *storeFile = [[NSUserDefaults standardUserDefaults] stringForKey:@"store"];
    
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
                
                _rect = [self.tableView.superview convertRect:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height) fromView:cell];
                
                
                NSLog(@"%@",[[self.plistArr objectAtIndex:indexPath.section-1][@"info"] objectAtIndex:indexPath.row][@"tradeImage"]);
                
                
                if ([_currentNumDic count] == 0) {
                    [_currentNumDic setObject:currentNum forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row-1]];
                    //商品起始位置
                    UIBezierPath *path = [UIBezierPath bezierPath];
                    [path moveToPoint:CGPointMake(46, _rect.origin.y+40)];
                    //商品最终位置和其中一个路径位置
                    [path addQuadCurveToPoint:CGPointMake(screenWidth/2, screenHeight -20) controlPoint:CGPointMake(screenWidth*0.8, screenHeight * 0.6)];
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
    self.selectTypeTableViewBackView.hidden = YES;
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
