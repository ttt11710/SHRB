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
#import "shrb-swift.h"
#import "NewCardDetailViewController.h"
#import <UIImageView+WebCache.h>
#import "TBUser.h"
#import "CallBackButton.h"
#import "ShoppingCardDataItem.h"

@interface ShoppingNumLabel1 : UILabel
{
    NSInteger _num;
}

@property (assign, readwrite, nonatomic)NSInteger num;
@property (assign, readwrite, nonatomic)CGFloat price;

@end

@implementation ShoppingNumLabel1

- (void)setNum:(NSInteger)num
{
    _num = num;
    self.text = [NSString stringWithFormat:@"%ld",(long)num];
}
@end

static StoreViewController *g_StoreViewController = nil;
static NSInteger constantCountTime = 1200;
static NSInteger countTime = 1200;
@interface StoreViewController ()
{
    NSMutableArray *_array;
    NSMutableDictionary *_currentNumDic;
    CGRect _rect;
    CGFloat lastContentOffset;
    
    NSTimer *_timer;
    BOOL showSelectTypeTableView;
}

@property (weak, nonatomic) IBOutlet UIView *selectTypeTableViewBackView;
@property (weak, nonatomic) IBOutlet UITableView *selectTypeTableView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) HJCAjustNumButton *numbutton;

@property (weak, nonatomic) IBOutlet UIView *shoppingCardView;
@property (weak, nonatomic) IBOutlet UIImageView *shoppingCardImageView;
@property (weak, nonatomic) IBOutlet ShoppingNumLabel1 *shoppingNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *shoppingFixLabel;
@property (weak, nonatomic) IBOutlet UILabel *countDownLabel;

@property (nonatomic,strong) UIBezierPath *path;

@property (nonatomic,strong) NSMutableArray * selectArray;
@property (nonatomic, strong) NSMutableArray *dataArray;


@property(nonatomic,assign)NSString * prodId;
@property (nonatomic, strong)NSMutableArray *shoppingArray;

@end

@implementation StoreViewController{
    CALayer     *layer;
}

@synthesize merchId;
@synthesize merchTitle;

+ (StoreViewController *)shareStoreViewController
{
    return g_StoreViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    g_StoreViewController = self;

    [SVProgressShow showWithStatus:@"加载中..."];
    
    [self loadData];
    [self initView];
    [self initData];
    [self initTableView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    
    [self countDown];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_timer invalidate];
    _timer = nil;
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"num"];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"num"];
}


- (void)viewDidLayoutSubviews
{
    
    self.shoppingNumLabel.layer.borderColor = [UIColor whiteColor].CGColor;
  //  self.shoppingNumLabel.layer.borderWidth = 1;
   // self.shoppingNumLabel.layer.cornerRadius = self.shoppingNumLabel.frame.size.width/2;
    self.shoppingNumLabel.layer.masksToBounds = YES;

    
    if (IsiPhone4s) {
        self.tableView.frame = CGRectMake(0, 64, screenWidth, screenHeight-64);
    }
    [self.view layoutSubviews];
}


#pragma mark - 网络请求数据
- (void)loadData
{
    
    self.dataArray = [[NSMutableArray alloc] init];
    
    NSString *url=[baseUrl stringByAppendingString:@"/product/v1.0/getProductList?"];
    
    [self.requestOperationManager GET:url parameters:@{@"merchId":self.merchId,@"pageNum":@"1",@"pageCount":@"20",@"orderBy":@"updateTime",@"sort":@"desc",@"whereString":@""} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"getProductList operation : %@  JSON: %@", operation, responseObject);
        
        switch ([responseObject[@"code"] integerValue]) {
            case 200:
                self.dataArray = responseObject[@"productList"];
                
                self.selectArray = [[NSMutableArray alloc] initWithArray:self.dataArray];
                
                [self.tableView reloadData];
                [self.selectTypeTableView reloadData];
                [SVProgressShow dismiss];
                break;
            case 404:
            case 503:
                [SVProgressShow showErrorWithStatus:responseObject[@"msg"]];
                break;
                
            default:
                break;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error:++++%@",error.localizedDescription);
        
    }];
}

- (void)initView
{
    
    self.title = self.merchTitle;
   UIBarButtonItem *selectType = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"screen"] style:UIBarButtonItemStylePlain target:self action:@selector(selectType)];
    self.navigationItem.rightBarButtonItem = selectType;
    
    //导航颜色
    self.navigationController.navigationBar.barTintColor = shrbPink;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
}



- (void)initData
{
    self.shoppingArray = [[NSMutableArray alloc] init];
    
    self.shoppingNumLabel.num = 0 ;
    self.priceLabel.text = @"￥0.00";
    self.shoppingNumLabel.price = 0.00;
    self.countDownLabel.text = @"20:00";
    
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"countTime"];
//    [[NSUserDefaults standardUserDefaults] setInteger:11 forKey:@"countTime"];
    
    countTime = [[NSUserDefaults standardUserDefaults] integerForKey:@"countTime"];

    NSLog(@"initData countTime = %ld",(long)countTime);
    
}

- (void)initTableView
{
    
    //去除tableview顶部留白
    self.automaticallyAdjustsScrollViewInsets = false;
   
    //删除底部多余横线
    _tableView.tableFooterView =[[UIView alloc]init];
    
    self.selectTypeTableView.tableFooterView = [[UIView alloc] init];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, screenWidth, 49.f)];
    
    //动画
    //[self.tableView reloadDataAnimateWithWave:RightToLeftWaveAnimation];
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
        
        else return IsiPhone4s?110 : 100;
    }
 }

#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView != self.selectTypeTableView) {
        return [self.selectArray count]+1;
    }
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView != self.selectTypeTableView) {
        if (section == 0) {
            return @"";
        }
        return [self.selectArray objectAtIndex:section-1][@"typeName"];
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
        label.text = section == 0?@"":[self.selectArray objectAtIndex:section-1][@"typeName"];
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
        return [self.dataArray count]+1;
    }
    else {
        return section == 0?1:[[self.selectArray objectAtIndex:section-1][@"prodList"] count];
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
        
        cell.textLabel.text = indexPath.row == 0?@"全部类别" : [self.dataArray objectAtIndex:indexPath.row-1][@"typeName"];
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
        else   {
            static NSString *SimpleTableIdentifier = @"CouponsTableViewCellIdentifier";
            StoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            if (cell == nil) {
                cell = [[StoreTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
            }
            
            cell.tradeNameLabel.text = self.selectArray[indexPath.section-1][@"prodList"][indexPath.row][@"prodName"] == nil? @"商品名称" : self.selectArray[indexPath.section-1][@"prodList"][indexPath.row][@"prodName"];
            [cell.tradeImageView sd_setImageWithURL:[NSURL URLWithString:self.selectArray[indexPath.section-1][@"prodList"][indexPath.row][@"imgUrl"]] placeholderImage:[UIImage imageNamed:@"热点无图片"]];
            
            cell.tradeDescriptionLabel.text = self.selectArray[indexPath.section-1][@"prodList"][indexPath.row][@"prodDesc"];
            
            NSNumber *vipPriceNumber = self.selectArray[indexPath.section-1][@"prodList"][indexPath.row][@"vipPrice"];
            NSNumber *priceNumber = self.selectArray[indexPath.section-1][@"prodList"][indexPath.row][@"price"];
            
            NSString *vipPrice = [vipPriceNumber stringValue];
            NSString *price = [priceNumber stringValue];
            
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@ 原价￥%@",vipPrice,price]];
            
            [attrString addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange([vipPrice length] + 2, [price length]+3)];//删除线
            [attrString addAttribute:NSForegroundColorAttributeName value:shrbPink range:NSMakeRange(0, vipPrice.length + 1)];
            [attrString addAttribute:NSForegroundColorAttributeName value:shrbLightText range:NSMakeRange(vipPrice.length + 2, price.length+3)];
            
            [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, vipPrice.length + 1)];
            [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(vipPrice.length + 2, price.length+3)];
            
            cell.priceLabel.attributedText = attrString;
            
            [cell.afterSaleButton setupBlock];
            
            HJCAjustNumButton *numbutton = [[HJCAjustNumButton alloc] init];
            numbutton.frame = CGRectMake(screenWidth-40, IsiPhone4s?40:35, 30, 30);
            // 内容更改的block回调
            numbutton.callBack = ^(NSString *currentNum){
                
                NSLog(@"indexPath.section = %ld, indexPath.row = %ld",(long)indexPath.section, (long)indexPath.row);

                
                if ([self.shoppingArray count] == 0) {
                    ShoppingCardDataItem *shoppingCardDataItem = [[ShoppingCardDataItem alloc] init];
                    shoppingCardDataItem.count = [currentNum integerValue];
                    shoppingCardDataItem.prodList = self.selectArray[indexPath.section-1][@"prodList"][indexPath.row];
                    [self.shoppingArray addObject:shoppingCardDataItem];
                    
                    self.prodId = self.selectArray[indexPath.section-1][@"prodList"][indexPath.row][@"prodId"];
                    self.shoppingNumLabel.price = [self.selectArray[indexPath.section-1][@"prodList"][indexPath.row][@"price"] floatValue];
                }
                
                else {
                    
                    self.shoppingNumLabel.price += [self.selectArray[indexPath.section-1][@"prodList"][indexPath.row][@"price"] floatValue];
                    
                    ShoppingCardDataItem *result = [[ShoppingCardDataItem alloc] init];
                    
                    int num = 0 ;
                    
                    for (int i = 0; i < self.shoppingArray.count; i++) {
                        result = [self.shoppingArray objectAtIndex:i];
                        NSLog(@"1111111111111111111result.count = %ld  result.prodList = %@",(long)result.count,result.prodList);
                        
                        NSMutableArray *arr = [[NSMutableArray alloc] init];
                        
                        arr =  self.selectArray[indexPath.section-1][@"prodList"][indexPath.row];
                        
                        if ([result.prodList isEqual:arr]) {
                            result.count = [currentNum integerValue];
                            NSLog(@"一样");
                        }
                        else {
                            
                            num ++ ;
                            if (num == self.shoppingArray.count) {
                                NSLog(@"不一样");
                                ShoppingCardDataItem *shoppingCardDataItem = [[ShoppingCardDataItem alloc] init];
                                shoppingCardDataItem.count = [currentNum integerValue];
                                shoppingCardDataItem.prodList = self.selectArray[indexPath.section-1][@"prodList"][indexPath.row];
                                [self.shoppingArray addObject:shoppingCardDataItem];
                            }
                        }
                        
                        NSLog(@"22222222222222222result.count = %ld  result.prodList = %@",(long)result.count,result.prodList);
                    }
                }
                
                NSLog(@"%@",self.shoppingArray);
                
                
                _rect = [self.tableView.superview convertRect:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height) fromView:cell];
                
                
                if ([_currentNumDic count] == 0) {
                    [_currentNumDic setObject:currentNum forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row-1]];
                    //商品起始位置
                    UIBezierPath *path = [UIBezierPath bezierPath];
                    [path moveToPoint:CGPointMake(46, _rect.origin.y+40)];
                    //商品最终位置和其中一个路径位置
                    [path addQuadCurveToPoint:CGPointMake(80, screenHeight -100) controlPoint:CGPointMake(screenWidth*0.5, screenHeight * 0.5)];
                    _path = path;
//                    [self startAnimationWithImageNsstring:[NSString stringWithFormat:@"%@.jpg",  [[self.plistArr objectAtIndex:indexPath.section-1][@"info"] objectAtIndex:indexPath.row][@"tradeImage"]]];
                    [self startAnimationWithImageNsstring:@"热点无图片"];
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
//                        [self startAnimationWithImageNsstring:[NSString stringWithFormat:@"%@.jpg",  [[self.plistArr objectAtIndex:indexPath.section-1][@"info"] objectAtIndex:indexPath.row][@"tradeImage"]]];
                        [self startAnimationWithImageNsstring:@"热点无图片"];
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
//                            [self startAnimationWithImageNsstring:[NSString stringWithFormat:@"%@.jpg",  [[self.plistArr objectAtIndex:indexPath.section-1][@"info"] objectAtIndex:indexPath.row][@"tradeImage"]]];
                            [self startAnimationWithImageNsstring:@"热点无图片"];
                        }
                    }
                }
                
            };
            
            // 加到父控件上
            [cell addSubview:numbutton];
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
            
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.row] animated:YES scrollPosition:UITableViewScrollPositionTop];
        }];
    }
    else {
        
        if (indexPath.section == 0) {
            return;
        }
        else {
            [[DeskNumTableViewCell shareDeskNumTableViewCell] deskTextFieldResignFirstResponder];
        }
        
        [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(todoSomething:) object:indexPath];
        [self performSelector:@selector(todoSomething:) withObject:indexPath afterDelay:0.2f];
    }
}

- (void)todoSomething:(NSIndexPath *)indexPath
{
    NSString *url=[baseUrl stringByAppendingString:@"/product/v1.0/getProduct?"];
    [self.requestOperationManager GET:url parameters:@{@"prodId":self.selectArray[indexPath.section-1][@"prodList"][indexPath.row][@"prodId"],@"token":[TBUser currentUser].token} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"getProduct JSON: %@", responseObject);
        
        switch ([responseObject[@"code"] integerValue]) {
            case 200: {
                ProductDescriptionView *productDescriptionView=[[ProductDescriptionView alloc]initWithFrame:CGRectMake(0, 20+44, screenWidth, screenHeight-20-44)];
                productDescriptionView.plistArr = self.dataArray;
                productDescriptionView.currentSection = indexPath.section-1;
                productDescriptionView.currentRow = indexPath.row;
                
                NSLog(@"indexPath.section = %ld,indexPath.row = %ld",(long)indexPath.section,indexPath.row);
                // productDescriptionView.productDataDic = responseObject[@"product"];
                [self.view addSubview:productDescriptionView];

            }
                break;
            case 404:
            case 503:
                [SVProgressShow showErrorWithStatus:responseObject[@"msg"]];
                break;
                
            default:
                break;
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:++++%@",error.localizedDescription);
    }];

}
#pragma mark - tableView滚动调用
-(void)scrollViewWillBeginDragging:(UIScrollView*)scrollView {
    
    lastContentOffset = scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (scrollView.contentOffset.y < lastContentOffset )
//    {
//        //向上
//        _topBtn.hidden = NO;
//        
//    } else if (scrollView. contentOffset.y >lastContentOffset){
//        //向下
//        CATransition *animation = [CATransition animation];
//        animation.type = kCATransitionMoveIn;
//        animation.duration = 1.0f;
//        [_topBtn.layer addAnimation:animation forKey:nil];
//        _topBtn.hidden = YES;
//    }
//    if (scrollView.contentOffset.y == 0) {
//        _topBtn.hidden = YES;
//    }
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
       // self.gotopayViewBtn.enabled = NO;
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
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",self.shoppingNumLabel.price];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"num"];
    [[NSUserDefaults standardUserDefaults] setInteger:self.shoppingNumLabel.num forKey:@"num"];
    
    [self countDown];
    
    self.selectTypeTableViewBackView.hidden = YES;
    if (anim == [layer animationForKey:@"group"]) {
       // self.gotopayViewBtn.enabled = YES;
        [layer removeFromSuperlayer];
        layer = nil;
    }
}

#pragma mark - 倒计时功能

- (void)countDown
{
    if (self.shoppingNumLabel.num == 0) {
        return;
    }
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
    }
    else {
        [_timer setFireDate:[NSDate distantPast]];
    }
}

- (void)timerFireMethod:(NSTimer *)timer
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *today = [NSDate date];//当前时间
    NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:--countTime];
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
   // NSLog(@"timerFireMethod countTime = %ld",(long)countTime);
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
        [_timer setFireDate:[NSDate distantFuture]];
        self.countDownLabel.text = @"20:00";
        countTime = constantCountTime;
        self.shoppingNumLabel.num = 0 ;
        self.shoppingNumLabel.price = 0 ;
        self.priceLabel.text = @"￥0.00";
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

#pragma mark - 进入订单页面
- (IBAction)gotoPayView:(id)sender {
    
    if (self.shoppingArray.count == 0) {
        [SVProgressShow showInfoWithStatus:@"您未选购任何商品!"];
        return;
    }
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    OrdersViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"OrdersView"];
    [viewController setModalPresentationStyle:UIModalPresentationFullScreen];
    viewController.merchId = self.merchId;
    viewController.prodId = self.prodId;
    viewController.shoppingArray = self.shoppingArray;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)pushCardDetailView
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Card" bundle:nil];
    NewCardDetailViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"CardDetailView"];
    [viewController setModalPresentationStyle:UIModalPresentationFullScreen];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma  mark - storyboard传值
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    OrdersViewController *shoppingCartViewController = segue.destinationViewController;
    shoppingCartViewController.isMember = [[NSUserDefaults standardUserDefaults] boolForKey:@"isMember"];
}

@end
