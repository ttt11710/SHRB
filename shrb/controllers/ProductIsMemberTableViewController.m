//
//  ProductIsMemberTableViewController.m
//  shrb
//
//  Created by PayBay on 15/6/26.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "ProductIsMemberTableViewController.h"
#import "ProductTableViewCell.h"
#import "ProductModel.h"
#import "Const.h"
#import "NewCardDetailViewController.h"


static ProductIsMemberTableViewController *g_ProductIsMemberTableViewController = nil;
@interface ProductIsMemberTableViewController ()

@property (nonatomic,strong) NSMutableArray * modelArray;
@property (nonatomic,strong) NSMutableArray * plistArr;

@end

@implementation ProductIsMemberTableViewController

@synthesize currentSection;
@synthesize currentRow;

+ (ProductIsMemberTableViewController *)shareProductIsMemberTableViewController
{
    return g_ProductIsMemberTableViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    g_ProductIsMemberTableViewController = self;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self initData];
}

- (void)initData
{
    NSString *storeFile = [[NSUserDefaults standardUserDefaults] stringForKey:@"store"];
    
    self.plistArr =[[NSMutableArray alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:storeFile ofType:@"plist"]];
    
    self.modelArray = [[NSMutableArray alloc] init];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimpleTableIdentifier = @"ProductTableViewCellIdentifier";
    ProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (cell == nil) {
        cell = [[ProductTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
    }
    
    [self.modelArray removeAllObjects];
    ProductModel * model = [[ProductModel alloc] init];
    [model setValuesForKeysWithDictionary:[[self.plistArr objectAtIndex:currentSection][@"info"] objectAtIndex:currentRow]];
    [self.modelArray addObject:model];
    
    cell.model = self.modelArray[indexPath.row];
    
    cell.tag = indexPath.row;
    return cell;
}

#pragma mark - tableView dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,screenWidth - 16 , 40)];
    label.numberOfLines = 1000;
    label.font = [UIFont systemFontOfSize:15.0];
    label.text = [[self.plistArr objectAtIndex:currentSection][@"info"] objectAtIndex:currentRow][@"tradeDescription"];
    [label sizeToFit];
    if (label.frame.size.height + screenWidth-16+125+20 < screenHeight-20-44) {
        self.tableView.scrollEnabled = NO;
        return screenHeight ;
    }
    
    self.tableView.scrollEnabled = YES;
    return label.frame.size.height + screenWidth-16+125+20;
}


#pragma mark - push会员卡详情页面
- (void)gotoCardDetailView
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Card" bundle:nil];
    NewCardDetailViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"CardDetailView"];
    [viewController setModalPresentationStyle:UIModalPresentationFullScreen];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"QRPay"];
    [[NSUserDefaults standardUserDefaults] setObject:@"SupermarketOrOrder" forKey:@"QRPay"];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
