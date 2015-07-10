//
//  ProductTableViewController.m
//  shrb
//
//  Created by PayBay on 15/6/26.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "ProductTableViewController.h"
#import "ProductTableViewCell.h"
#import "ProductModel.h"
#import "Const.h"
#import "TransactMemberViewController.h"
#import "ProductIsMemberTableViewController.h"
#import "SuperBecomeMemberView1.h"


static ProductTableViewController *g_ProductTableViewController = nil;
@interface ProductTableViewController ()

@property (nonatomic,strong) NSMutableArray * modelArray;
@property (nonatomic,strong) NSMutableArray * plistArr;

@end

@implementation ProductTableViewController

@synthesize currentSection;
@synthesize currentRow;

+ (ProductTableViewController *)shareProductTableViewController
{
    return g_ProductTableViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    g_ProductTableViewController = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    self.view.userInteractionEnabled = YES;
    [self.view addGestureRecognizer:tap];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self initData];
}

- (void)initData
{
    self.plistArr =[[NSMutableArray alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"holy" ofType:@"plist"]];
    
    self.modelArray = [[NSMutableArray alloc] init];
}

#pragma mark - 单击屏幕键盘消失
-(void)tap {
    
    [[SuperBecomeMemberView1 shareSuperBecomeMemberView] textFieldResignFirstResponder];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
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
    if (label.frame.size.height + screenWidth-16+180+20 < screenHeight-20-44) {
        self.tableView.scrollEnabled = NO;
        return screenHeight ;
    }
    
    self.tableView.scrollEnabled = YES;
    return label.frame.size.height + screenWidth-16+180+30;
}

#pragma mark - 成为会员时页面重push
- (void)becomeMember
{
    UINavigationController *navController = self.navigationController;
    [self.navigationController popViewControllerAnimated:NO];
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ProductIsMemberTableViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"ProductIsMemberTableView"];
    viewController.currentSection = currentSection;
    viewController.currentRow = currentRow;
    
    [viewController setModalPresentationStyle:UIModalPresentationFullScreen];
    
    [navController pushViewController:viewController animated:NO];
    
}

#pragma  mark - storyboard传值
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    TransactMemberViewController *transactMemberViewController = segue.destinationViewController;
    transactMemberViewController.currentSection = currentSection;
    transactMemberViewController.currentRow = currentRow;
}

@end
