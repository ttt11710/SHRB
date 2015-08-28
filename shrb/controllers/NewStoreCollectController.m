//
//  NewStoreCollectController.m
//  shrb
//
//  Created by PayBay on 15/7/27.
//  Copyright © 2015年 PayBay. All rights reserved.
//

#import "NewStoreCollectController.h"
#import "NewStoreCollectionViewCell.h"
#import "Const.h"
#import "TradeModel.h"
#import "ProductIsMemberViewController.h"
#import "ProductViewController.h"
#import "SuperQRViewController.h"
#import <UIImageView+WebCache.h>
#import "TBUser.h"

@interface NewStoreCollectController ()
{
    BOOL showSelectTypeTableView;;
}
@property (retain, nonatomic) UICollectionView *collectionView;

@property (retain, nonatomic) UIButton *QRViewBtn;
@property (retain, nonatomic) UILabel *QRLabel;

@property (retain, nonatomic) UIView *ballBackview;
@property (retain, nonatomic) UIView *ballview;


@property (retain, nonatomic) UIView *selectTypeTableViewBackView;
@property (retain, nonatomic) UITableView *selectTypeTableView;

@property (nonatomic) NSMutableArray * selectArray;

@property (nonatomic,strong) NSMutableArray * dataArray;

@end

@implementation NewStoreCollectController

@synthesize merchId;
@synthesize merchTitle;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
    [self initView];
    [self createCollection];
    [self createSelectTypeTableView];
    [self QRButtonView];
    
   // [self initBallView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
   // self.tabBarController.tabBar.hidden = YES;
    
    [super viewWillAppear:animated];
    self.view.hidden = NO;
    
    [self btnAnimation];
    
  //  [self ballBackViewAnimation];
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.view.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)initBallView
{
    self.ballBackview = [[UIView alloc] initWithFrame:CGRectMake(0, 20+44, screenWidth, screenHeight)];
    self.ballBackview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.ballBackview];
    
    self.ballview = [[UIView alloc] initWithFrame:CGRectMake((screenWidth-60)/2, 20, 60, 60)];
    self.ballview.backgroundColor = shrbPink;
    self.ballview.layer.cornerRadius = self.ballview.frame.size.width/2;
    self.ballview.layer.masksToBounds = YES;
    [self.ballBackview addSubview:self.ballview];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    label.center = CGPointMake(self.ballview.frame.size.width/2, self.ballview.frame.size.height/2);
    label.text = @"通宝";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [self.ballview addSubview:label];
    
}


- (void)ballBackViewAnimation
{
    
    [self ballAnimation];
    
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        self.ballBackview.alpha = 0.9;
        self.ballBackview.layer.transform = CATransform3DMakeTranslation(0, screenHeight-20-44, 0);
        
    } completion:^(BOOL finished) {
        
        [self btnAnimation];
    }];
    
}

- (void)ballAnimation
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.ballview.layer.transform = CATransform3DRotate(self.ballview.layer.transform, M_PI/2, 0, 0, 1);
        
    } completion:^(BOOL finished) {
        [self ballAnimation];
    }];
}


- (void)initView
{
    self.title = self.merchTitle;
    
    UIBarButtonItem *selectType = [[UIBarButtonItem alloc] initWithTitle:@"分类" style:UIBarButtonItemStylePlain target:self action:@selector(selectType)];
    self.navigationItem.rightBarButtonItem = selectType;

}

- (void)QRButtonView
{
    self.QRViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.QRViewBtn.frame = CGRectMake(screenWidth-80,screenHeight-80, 60, 60);
    self.QRViewBtn.backgroundColor = shrbPink;
    self.QRViewBtn.layer.cornerRadius = self.QRViewBtn.frame.size.width/2;
    self.QRViewBtn.layer.masksToBounds = YES;
    [self.QRViewBtn addTarget:self action:@selector(goToQRView) forControlEvents:UIControlEventTouchUpInside];
    [self.QRViewBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    
    [self.view addSubview:self.QRViewBtn];
    
    self.QRLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    self.QRLabel.center = CGPointMake(self.QRViewBtn.frame.size.width/2, self.QRViewBtn.frame.size.height/2);
    self.QRLabel.numberOfLines = 2;
    self.QRLabel.text = @"扫一扫支付";
    self.QRLabel.textAlignment = NSTextAlignmentCenter;
    self.QRLabel.textColor = [UIColor whiteColor];
    self.QRLabel.font = [UIFont systemFontOfSize:15.f];
    [self.QRViewBtn addSubview:self.QRLabel];
    
    self.QRViewBtn.layer.transform = CATransform3DMakeScale(1, 0, 1);

}

#pragma mark - 网络请求数据
- (void)loadData
{
    
    self.dataArray = [[NSMutableArray alloc] init];
    
    NSString *url=[baseUrl stringByAppendingString:@"/product/v1.0/getProductList?"];
    
    [self.requestOperationManager GET:url parameters:@{@"merchId":self.merchId,@"pageNum":@"1",@"pageCount":@"20",@"orderBy":@"updateTime",@"sort":@"desc",@"whereString":@""} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"operation : %@  JSON: %@", operation, responseObject);
        
        self.dataArray = responseObject[@"productList"];
        
        self.selectArray = [[NSMutableArray alloc] initWithArray:self.dataArray];
        
        
        
        [self.collectionView reloadData];
        [self.selectTypeTableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error:++++%@",error.localizedDescription);
        
    }];
}

- (void)createCollection{

    CollectionViewWaterfallLayout *cvLayout = [[CollectionViewWaterfallLayout alloc] init];
    cvLayout.sectionInset = UIEdgeInsetsMake(0, 4, 0, 4);
    cvLayout.headerInset = UIEdgeInsetsMake(4, 0, 0, 0);
    cvLayout.minimumColumnSpacing = 4;
    cvLayout.minimumInteritemSpacing = 4;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) collectionViewLayout:cvLayout];
    [self.collectionView registerNib:[UINib nibWithNibName:@"NewStoreCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CollectionCell"];
    
    self.collectionView.backgroundColor = shrbTableViewColor;
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    
    [self.view addSubview:self.collectionView];
}

- (void)createSelectTypeTableView
{
    showSelectTypeTableView = NO;

    self.selectTypeTableViewBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    self.selectTypeTableViewBackView.hidden = YES;
    
    self.selectTypeTableView = [[UITableView alloc] initWithFrame:CGRectMake(screenWidth, 20+44, screenWidth/2, screenHeight) style:UITableViewStylePlain];
    
    self.selectTypeTableView.tableFooterView = [[UIView alloc] init];
    
    self.selectTypeTableView.delegate = self;
    self.selectTypeTableView.dataSource = self;
    self.selectTypeTableView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.selectTypeTableViewBackView];
    [self.view addSubview:self.selectTypeTableView];
}

#pragma mark - 扫一扫动画
- (void)btnAnimation
{
    
    [UIView animateWithDuration:0.5 delay:0.5 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        self.QRViewBtn.layer.transform = CATransform3DIdentity;
        
    } completion:^(BOOL finished) {
        
        [self btnAnimation1];
        [self btnAnimation2];
        
    }];
}

- (void)btnAnimation1
{
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.QRViewBtn.layer.transform = CATransform3DMakeScale(0.9, 0.9, 1);
        self.QRLabel.layer.transform = CATransform3DMakeScale(0.8, 0.8, 1);
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)btnAnimation2
{
    [UIView animateWithDuration:0.5 delay:0.2 usingSpringWithDamping:0.3 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.QRViewBtn.layer.transform = CATransform3DIdentity;
        self.QRLabel.layer.transform = CATransform3DIdentity;
        
    } completion:^(BOOL finished) {
        
    }];
}


#pragma mark - 商品image动画
- (void)cardAnimation
{
    for (NSIndexPath *indexPath in [self.collectionView indexPathsForVisibleItems] )
    {
        NewStoreCollectionViewCell *cell = (NewStoreCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        
        cell.tradeImageView.layer.transform = CATransform3DMakeScale(1, 0, 1);
        
        [UIView animateWithDuration:1.5 delay:4 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            cell.tradeImageView.layer.transform = CATransform3DIdentity;
        } completion:nil];
    }
}

#pragma mark - 分类选择
- (void)selectType
{
    showSelectTypeTableView = !showSelectTypeTableView;
    if (showSelectTypeTableView) {
        self.selectTypeTableViewBackView.hidden = NO;
        
        [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.selectTypeTableView.layer.transform = CATransform3DMakeTranslation(-screenWidth/2, 0, 0);
            
        } completion:^(BOOL finished) {
            
        }];
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            self.selectTypeTableViewBackView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
            
        } completion:^(BOOL finished) {
            
        }];
    }
    else {
        
        [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.selectTypeTableView.layer.transform = CATransform3DMakeTranslation(-screenWidth/2, 0, 0);
            
        } completion:^(BOOL finished) {
            
        }];
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            self.selectTypeTableViewBackView.backgroundColor = [UIColor clearColor];
            
        } completion:^(BOOL finished) {
            
        }];
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            self.selectTypeTableView.layer.transform = CATransform3DIdentity;
            
        } completion:^(BOOL finished) {
            
            self.selectTypeTableViewBackView.hidden = YES;
        }];
    }
}

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    return [[self.selectArray objectAtIndex:section][@"info"] count];
    return [[self.selectArray objectAtIndex:section][@"prodList"] count];
}


//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
//    return [self.selectArray count];
    return [self.selectArray count];
}


//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NewStoreCollectionViewCell* cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
//    if ([self.selectArray count]==0) {
//        return cell;
//    }
    
//    [self.modelArray removeAllObjects];
//    for (NSDictionary * dict in [self.selectArray objectAtIndex:indexPath.section][@"info"]) {
//        TradeModel * model = [[TradeModel alloc] init];
//        [model setValuesForKeysWithDictionary:dict];
//        [self.modelArray addObject:model];
//    }
    
   // cell.model = self.modelArray[indexPath.row];
    
    
    cell.backgroundColor = [UIColor whiteColor];
    
    cell.prodNameLabel.text = self.selectArray[indexPath.section][@"prodList"][indexPath.row][@"prodName"] == nil? @"商品名称" : self.selectArray[indexPath.section][@"prodList"][indexPath.row][@"prodName"];
    [cell.tradeImageView sd_setImageWithURL:[NSURL URLWithString:self.selectArray[indexPath.section][@"prodList"][indexPath.row][@"imgUrl"]] placeholderImage:[UIImage imageNamed:@"热点无图片"]];
    
    cell.vipPriceLabel.text = [NSString stringWithFormat:@"会员价:￥%@",self.selectArray[indexPath.section][@"prodList"][indexPath.row][@"vipPrice"]];
    cell.priceLabel.text = [NSString stringWithFormat:@"原价:￥%@",self.selectArray[indexPath.section][@"prodList"][indexPath.row][@"price"]];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:cell.priceLabel.text];
    [attrString addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, [cell.priceLabel.text length])];//删除线
    [attrString addAttribute:NSStrikethroughColorAttributeName value:shrbText range:NSMakeRange(0, [cell.priceLabel.text length])];
    cell.priceLabel.attributedText = attrString;
    
    
    if ([self.selectArray count]!=0) {
        
    cell.tradeImageView.layer.transform = CATransform3DMakeScale(1, 0, 1);
    cell.tradeImageView.layer.transform = CATransform3DMakeTranslation(0, -screenWidth/2, 0);
    
    cell.prodNameLabel.alpha = 0;
    cell.vipPriceLabel.alpha = 0 ;
    cell.priceLabel.alpha = 0 ;
    
    [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        cell.tradeImageView.layer.transform = CATransform3DIdentity;
        
    } completion:^(BOOL finished) {
    }];
    
    [UIView animateWithDuration:0.8 delay:0.6 options:UIViewAnimationOptionCurveLinear animations:^{
        cell.prodNameLabel.alpha = 1;
        
    } completion:^(BOOL finished) {
    
    }];

    
    [UIView animateWithDuration:0.8 delay:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        cell.vipPriceLabel.alpha = 1 ;
        cell.priceLabel.alpha = 1 ;
        
    } completion:^(BOOL finished) {
    }];
    }
    return cell;
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UILabel *tradeNameLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, (screenWidth-12)/2 , 0)];
    UIFont *theFont1 = [UIFont systemFontOfSize:17.0];
    tradeNameLabel.numberOfLines = 0;
    [tradeNameLabel setFont:theFont1];
    
    NSString *string1 = self.selectArray[indexPath.section][@"prodList"][indexPath.row][@"prodName"];
    [tradeNameLabel setText:string1];
    [tradeNameLabel sizeToFit];// 显示文本需要的长度和宽度
    
    return CGSizeMake((screenWidth-20)/2 , screenWidth/2-10 + tradeNameLabel.frame.size.height + 25 + 21 + 8 );
}

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    //f755a51c0c7a4b4f8d140c4a2ebe9cb5 [TBUser currentUser].token
    NSString *url=[baseUrl stringByAppendingString:@"/product/v1.0/getProduct?"];
    [self.requestOperationManager GET:url parameters:@{@"prodId":self.selectArray[indexPath.section][@"prodList"][indexPath.row][@"prodId"],@"token":[TBUser currentUser].token} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        if ([(NSString *)responseObject[@"card"] isEqual:@""]) {
            ProductViewController *viewController = [[ProductViewController alloc] init];
            viewController.productDataDic = responseObject[@"product"];
            [self.navigationController pushViewController:viewController animated:YES];
        }
        else {
            ProductIsMemberViewController *viewController = [[ProductIsMemberViewController alloc] init];
            viewController.productDataDic = responseObject[@"product"];
            viewController.cardDataDic = responseObject[@"card"];
            [self.navigationController pushViewController:viewController animated:YES];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:++++%@",error.localizedDescription);
    }];
}


//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - tableView dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     return [self.dataArray count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    showSelectTypeTableView = !showSelectTypeTableView;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        self.selectTypeTableView.layer.transform = CATransform3DIdentity;
            self.selectTypeTableViewBackView.backgroundColor = [UIColor clearColor];
            
        } completion:^(BOOL finished) {
            
            self.selectTypeTableViewBackView.hidden = YES;
            
            if(indexPath.row == 0)
            {
                [self.selectArray removeAllObjects];
                for (int i = 0 ; i < [self.dataArray count] ; i++) {
                    [self.selectArray addObject:[self.dataArray objectAtIndex:i]];
                }
            }
            else {
                [self.selectArray removeAllObjects];
                [self.selectArray addObject:[self.dataArray objectAtIndex:indexPath.row-1]];
            }
        
            [self.collectionView reloadData];
            [self.collectionView setContentOffset:CGPointMake(0, -20-44) animated:YES];
        }];
}

#pragma mark - 扫码支付
- (void)goToQRView {
    
//    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"IsLogin"];
//    if (!isLogin) {
//        [SVProgressShow showInfoWithStatus:@"请先登录账号！"];
//        return ;
//    }
    
    //点击弹动动画
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        self.QRViewBtn.layer.transform = CATransform3DMakeScale(1.2, 1.2, 1);
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            self.QRViewBtn.layer.transform = CATransform3DIdentity;
            
        } completion:^(BOOL finished) {
            
            if ([self validateCamera]) {
                
                [self showQRViewController];
                
            } else {
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有摄像头或摄像头不可用" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            }
        }];
    }];
    
}

- (BOOL)validateCamera {
    
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] &&
    [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

#pragma mark - 进入扫码页面
- (void)showQRViewController {
    
    
    self.QRLabel.hidden = YES;
    
    [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.QRViewBtn.layer.transform = CATransform3DMakeTranslation(-(self.QRViewBtn.frame.origin.x-screenWidth/2+self.QRViewBtn.frame.size.width/2), -(self.QRViewBtn.frame.origin.y-screenHeight/2+self.QRViewBtn.frame.size.height/2), 0);
        
    } completion:^(BOOL finished) {
        
    }];
    
//    [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
//        self.QRViewBtn.layer.transform = CATransform3DMakeTranslation(-(self.QRViewBtn.frame.origin.x-screenWidth/2+self.QRViewBtn.frame.size.width/2), -(self.QRViewBtn.frame.origin.y-screenHeight/2+self.QRViewBtn.frame.size.height/2), 0);
//        
//    } completion:^(BOOL finished) {
//    
////        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
////            
////            CGRect bounds = self.QRViewBtn.bounds;
////            bounds.size.width = bounds.size.width*20;
////            bounds.size.height = bounds.size.height*20;
////            
////            self.QRViewBtn.layer.cornerRadius = self.QRViewBtn.bounds.size.width/2;
////            self.QRViewBtn.bounds = bounds;
////            
////        } completion:^(BOOL finished) {
////        
////        }];
//    }];
    
    [UIView animateWithDuration:0.0 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
    } completion:^(BOOL finished) {
        
        SuperQRViewController *qrVC = [[SuperQRViewController alloc] init];
        [self.navigationController pushViewController:qrVC animated:NO];
        self.QRViewBtn.layer.transform = CATransform3DIdentity;
        self.QRLabel.hidden = NO;
    }];
}

@end
