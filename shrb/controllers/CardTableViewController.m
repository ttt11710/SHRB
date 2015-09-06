//
//  CardTableViewController.m
//  shrb
//  会员卡
//  Created by PayBay on 15/5/20.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "CardTableViewController.h"
#import "CardTableViewCell.h"
#import "UITableView+Wave.h"
#import "SVPullToRefresh.h"
#import "Const.h"
#import "SVProgressShow.h"
#import "CardModel.h"
#import "TBUser.h"
#import "NewCardDetailViewController.h"
#import "CardDetailTableViewCell.h"

static int i = 0 ;

@interface CardTableViewController ()

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *modelArray;

@property (nonatomic,strong)AFHTTPRequestOperationManager *requestOperationManager;

@end

@implementation CardTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   // [self initData];
    [self creatReq];
    [self initTableView];
    
    [self cardAnimation];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadData];

}

- (void)creatReq
{
    self.requestOperationManager=[AFHTTPRequestOperationManager manager];
    
    self.requestOperationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    AFJSONResponseSerializer *serializer=[AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    self.requestOperationManager.responseSerializer=serializer;
    
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setTimeoutInterval:10*60];
    self.requestOperationManager.requestSerializer=requestSerializer;
}

- (void)loadData
{
    
    //cd5935ea60d93f02bedd9e637cc72e92  1440482769193894820
    if ([TBUser currentUser].token.length == 0) {
       
        [SVProgressShow showInfoWithStatus:@"请先登录!"];
        return;
    }
    self.dataArray = [[NSMutableArray alloc] init];
    self.modelArray = [[NSMutableArray alloc] init];
    
    NSString *url2=[baseUrl stringByAppendingString:@"/card/v1.0/findCardList?"];
    [self.requestOperationManager GET:url2 parameters:@{@"userId":[TBUser currentUser].userId,@"token":[TBUser currentUser].token} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"card findCardList operation = %@ JSON: %@", operation , responseObject);
        
        self.dataArray = responseObject[@"data"];
        for (NSDictionary * dic in responseObject[@"data"]) {
            CardModel * model = [[CardModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.modelArray addObject:model];
        }
        
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:++++%@",error.localizedDescription);
    }];
}

- (void)initData
{
    
    //假数据
    NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:
                             @{
                               @"memberCardImage" : @"holyLogo",
                               @"money" : @"1000",
                               @"cardNumber":@"455133487465566",
                               @"integral":@"45",
                               @"backCardImage":@"back_card0",
                               @"emitterCellImage":@"落叶",
                               @"emitterPositionX":@(screenWidth),
                               @"xAcceleration":@(-5),
                               @"yAcceleration":@(2),
                               @"spinRange":@(0.1),
                               },
                             @{
                               @"memberCardImage" : @"McDonaldsLogo",
                               @"money" : @"200",
                               @"cardNumber":@"7845123165468",
                               @"integral":@"55",
                               @"backCardImage":@"back_card1",
                               @"emitterCellImage":@"汉堡",
                               @"emitterPositionX":@(screenWidth/2),
                               @"xAcceleration":@(0),
                               @"yAcceleration":@(2),
                               @"spinRange":@(0.25),
                               },
                             @{
                               @"memberCardImage" : @"16NLogo",
                               @"money" : @"100",
                               @"cardNumber":@"998562144555456",
                               @"integral":@"33",
                               @"backCardImage":@"back_card2",
                               @"emitterCellImage":@"枫叶",
                               @"emitterPositionX":@(0),
                               @"xAcceleration":@(5),
                               @"yAcceleration":@(2),
                               @"spinRange":@(0.1),
                               },
                             @{
                               @"memberCardImage" : @"御泥坊Logo",
                               @"money" : @"150",
                               @"cardNumber":@"781123264645465654",
                               @"integral":@"55",
                               @"backCardImage":@"back_card3",
                               @"emitterCellImage":@"DazFlake",
                               @"emitterPositionX":@(screenWidth/2),
                               @"xAcceleration":@(0),
                               @"yAcceleration":@(2),
                               @"spinRange":@(0.25),
                               },
                             nil];
    
    self.dataArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary * dict in array) {
        CardModel * model = [[CardModel alloc] init];
        [model setValuesForKeysWithDictionary:dict];
        [self.dataArray addObject:model];
    }

}

- (void)initTableView
{
    //tableView 去分界线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //动画
   // [self.tableView reloadDataAnimateWithWave:RightToLeftWaveAnimation];
    
//    __weak CardTableViewController *weakSelf = self;
//    //下拉刷新
//    [self.tableView addPullToRefreshWithActionHandler:^{
//        [weakSelf insertRowAtTop];
//    }];
//    
//    //上拉加载
//    [self.tableView addInfiniteScrollingWithActionHandler:^{
//        [weakSelf insertRowAtBottom];
//    }];
 
}


- (void)cardAnimation
{
    
    for (NSIndexPath* indexPath in [self.tableView indexPathsForVisibleRows])
    {
        i++;
        CardTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        cell.shadowView.hidden = YES;
        
        cell.backImageView.layer.transform = CATransform3DMakeTranslation(0, -220, 0);
        cell.backView.layer.transform = CATransform3DMakeTranslation(0, -220, 0);

        
        [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(todoSomething:) object:nil];
        [self performSelector:@selector(todoSomething:) withObject:cell afterDelay:0.2f*i];
    }
    i = 0 ;
}


- (void)todoSomething:(CardTableViewCell *)cell
{
    
    [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        cell.backImageView.layer.transform = CATransform3DTranslate(cell.backImageView.layer.transform, 0, 220, 0);
        cell.backView.layer.transform = CATransform3DTranslate(cell.backView.layer.transform, 0, 220, 0);
        
    } completion:^(BOOL finished) {
        
    }];
    
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        cell.backImageView.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1);
        cell.backView.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1);
    } completion:^(BOOL finished) {
        
    }];
    
    [UIView animateWithDuration:0.5 delay:0.4 usingSpringWithDamping:0.3 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        cell.backImageView.layer.transform = CATransform3DScale(cell.backImageView.layer.transform, 2, 2, 1);
        cell.backView.layer.transform = CATransform3DScale(cell.backView.layer.transform, 2, 2, 1);
        
    } completion:^(BOOL finished) {
        
        cell.shadowView.hidden = NO;
    }];

}

#pragma mark - top插入数据
- (void)insertRowAtTop {
    __weak CardTableViewController *weakSelf = self;
    
    
    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        
        NSDictionary *dic = @{
                              @"memberCardImage" : @"御泥坊Logo",
                              @"money" : @"150",
                              @"cardNumber":@"781123264645465654",
                              @"integral":@"55",
                              @"backCardImage":@"back_card3",
                              @"emitterCellImage":@"DazFlake",
                              @"emitterPositionX":@(screenWidth/2),
                              @"xAcceleration":@(0),
                              @"yAcceleration":@(2),
                              @"spinRange":@(0.25),
                              };

        
                CardModel * model = [[CardModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        
        
        if (self.dataArray.count <= 5 )
        {
            [weakSelf.tableView beginUpdates];
            [weakSelf.dataArray insertObject:model atIndex:0];
            [weakSelf.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
            [weakSelf.tableView endUpdates];
            [weakSelf.tableView.pullToRefreshView stopAnimating];
            [weakSelf.tableView reloadData];
            [SVProgressShow showSuccessWithStatus:@"刷新成功！"];
            return ;
        }

        [weakSelf.tableView.pullToRefreshView stopAnimating];
        [SVProgressShow showInfoWithStatus:@"没有更多会员卡！"];
    });
}

#pragma mark - bottom插入数据
- (void)insertRowAtBottom {
    
    __weak CardTableViewController *weakSelf = self;
    
    [weakSelf.tableView.infiniteScrollingView setScrollViewContentInsetForInfiniteScrolling];
    
    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        NSDictionary *dic = @{
                              @"memberCardImage" : @"holyLogo",
                              @"money" : @"1000",
                              @"cardNumber":@"455133487465566",
                              @"integral":@"45",
                              @"backCardImage":@"back_card0",
                              @"emitterCellImage":@"落叶",
                              @"emitterPositionX":@(screenWidth),
                              @"xAcceleration":@(-5),
                              @"yAcceleration":@(2),
                              @"spinRange":@(0.1),
                              };
        CardModel * model = [[CardModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        
        if (self.dataArray.count <= 5 )
        {
            [weakSelf.tableView beginUpdates];
            [weakSelf.dataArray addObject:model];
            [weakSelf.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:weakSelf.dataArray.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
            [weakSelf.tableView endUpdates];
            [weakSelf.tableView.infiniteScrollingView stopAnimating];
            [SVProgressShow showSuccessWithStatus:@"加载成功！"];
            return ;
        }
        
        [weakSelf.tableView.infiniteScrollingView stopAnimating];
        [weakSelf.tableView.infiniteScrollingView resetScrollViewContentInset];
        [SVProgressShow showInfoWithStatus:@"没有更多会员卡！"];
        
    });
}

#pragma mark - tableView dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 162;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *SimpleTableIdentifier = @"CardTableViewCellIdentifier";
//    CardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
//    if (cell == nil) {
//        cell = [[CardTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
//    }
//    //cell 选中方式
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//  //  cell.accessoryType = UITableViewCellAccessoryNone;
//    cell.model = self.modelArray[indexPath.row];
    
    static NSString *SimpleTableIdentifier = @"CardDetailTableViewCellIdentifier";
    CardDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    if (cell == nil) {
        cell = [[CardDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
    }
    //cell 选中方式
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    cell.merchNameLabel.text = self.dataArray[indexPath.row][@"merchName"];
    
    NSString *amountString = [self.dataArray[indexPath.row][@"amount"] stringValue];
    NSString *scoreString = [self.dataArray[indexPath.row][@"score"] stringValue];
    
    NSMutableAttributedString *moneyAttrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"金额:￥%@",amountString]];
    [moneyAttrString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, 3)];
    [moneyAttrString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255.0/255.0 green:212.0/212.0 blue:0 alpha:1] range:NSMakeRange(3, amountString.length+1)];
    [moneyAttrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, 3)];
    [moneyAttrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:24] range:NSMakeRange(3, amountString.length+1)];
    
    cell.amountLabel.attributedText = moneyAttrString;
    
    NSMutableAttributedString *integralAttrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"积分:%@",scoreString]];
    [integralAttrString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, 3)];
    [integralAttrString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255.0/255.0 green:212.0/212.0 blue:0 alpha:1] range:NSMakeRange(3, scoreString.length)];
    [integralAttrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, 3)];
    [integralAttrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:24] range:NSMakeRange(3, scoreString.length)];
    
    cell.scoreLabel.attributedText = integralAttrString;
    
    cell.cardNoLabel.text = [NSString stringWithFormat:@"卡号:%@",self.dataArray[indexPath.row][@"cardNo"]];
    return cell;
}
//CardDetailView

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"QRPay"];
    [[NSUserDefaults standardUserDefaults] setObject:@"Card" forKey:@"QRPay"];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Card" bundle:nil];
    NewCardDetailViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"CardDetailView"];
    [viewController setModalPresentationStyle:UIModalPresentationFullScreen];
    viewController.cardNo = self.dataArray[indexPath.row][@"cardNo"];
    viewController.merchId = self.dataArray[indexPath.row][@"merchId"];
    [self.navigationController pushViewController:viewController animated:YES];
}


#pragma mark - 故事版传值
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"QRPay"];
    [[NSUserDefaults standardUserDefaults] setObject:@"Card" forKey:@"QRPay"];
}

@end
