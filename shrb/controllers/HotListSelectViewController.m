//
//  HotListSelectViewController.m
//  shrb
//
//  Created by PayBay on 15/8/4.
//  Copyright © 2015年 PayBay. All rights reserved.
//

#import "HotListSelectViewController.h"
#import "NewStoreCollectController.h"
#import "StoreViewController.h"
#import "Const.h"

@interface ResultDataItem1 : NSObject
{
    NSString  *_name;
    NSIndexPath *_indexPath;
}

@property(copy, readwrite, nonatomic)NSString  *name;
@property(retain, readwrite, nonatomic)NSIndexPath  *indexPath;

@end

@implementation ResultDataItem1

@end

@interface HotListSelectViewController ()


@property (nonatomic, strong) NSMutableArray *resultDataMutableArray;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation HotListSelectViewController
@synthesize tableView;

#define CHECK_TAG 1110

@synthesize  storeNamesArr,storePlistNameArr;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.resultDataMutableArray = [[NSMutableArray alloc] init];
    
    //去除tableview顶部留白
    self.automaticallyAdjustsScrollViewInsets = false;
    
    //删除底部多余横线
    self.tableView.tableFooterView =[[UIView alloc]init];
    
    self.tableView.backgroundColor = shrbTableViewColor;
    
    _mysearchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    
    _mysearchDisplayController.searchResultsDataSource = self;
    _mysearchDisplayController.searchResultsDelegate = self;
    _mysearchDisplayController.delegate = self;
    
    
    NSMutableArray *arr =[[NSMutableArray alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"store" ofType:@"plist"]];
    self.storeNamesArr = [[NSMutableArray alloc] init];
    self.storePlistNameArr = [[NSMutableArray alloc] init];
    for (NSDictionary * dict in arr) {
        
        [self.storeNamesArr addObject:dict[@"storeName"]];
        [self.storePlistNameArr addObject:dict[@"storePlistName"]];
    }
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.storeNamesArr = nil;
    self.storePlistNameArr = nil;
    self.tableView = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    NSLog(@"searchString = %@", searchString);
    
    [_resultDataMutableArray removeAllObjects];
    
    //搜索商店
    NSString *keyString = searchString;
    
    for (int i=0; i<[storeNamesArr count]; i++)
    {
        if ([[storeNamesArr objectAtIndex:i] rangeOfString:keyString].length > 0)
            {
                ResultDataItem1 *resultDataItem1 = [[ResultDataItem1 alloc] init];
                resultDataItem1.name = [storeNamesArr objectAtIndex:i];
                resultDataItem1.indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                
                [_resultDataMutableArray addObject:resultDataItem1];
            }
    }
    
    NSLog(@"%@",_resultDataMutableArray);
    
    return YES;
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    if (self.tableView == tableView) {
        return [storeNamesArr count];
    }
    else
    {
        return [_resultDataMutableArray count];
    }
    
}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    if (self.tableView == tableView) {
//        return 0;
//    }
//    else
//    {
//        return 30;
//    }
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableView == tableView) {
        
        static NSString *CellIdentifier = @"cellId";
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        
        for (UIView *view in cell.subviews)
        {
            if ([view isKindOfClass:[UIButton class]])
                [view removeFromSuperview];
        }
        
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = shrbText;
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        cell.textLabel.text = [storeNamesArr objectAtIndex:indexPath.row];
        
        return cell;
    }
    else {
        
        tableView.tableFooterView =[[UIView alloc]init];
        tableView.backgroundColor = shrbTableViewColor;
        
        static  NSString   *cellId = @"cellId";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        
        ResultDataItem1 *resultDataItem1 =  [_resultDataMutableArray objectAtIndex:[indexPath row]];
        cell.textLabel.text = resultDataItem1.name;
        
        return cell;
    }
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(self.tableView != tableView) {
        CGFloat height = 30 ;
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, height)] ;
        [headerView setBackgroundColor:shrbSectionColor];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, (height-18)*0.5, tableView.bounds.size.width - 10, 18)];
        label.text = @"搜索结果";
        label.textColor = shrbText;
        label.backgroundColor = [UIColor clearColor];
        [headerView addSubview:label];
        return headerView;
        
    }
    else {
        return nil;
    }
    
    
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableView != tableView)
    {
        NSString *storePlistName ;
        int row = 0  ;
        
        ResultDataItem1 *resultDataItem1 = [_resultDataMutableArray objectAtIndex:[indexPath row]];
        
        NSString *resultName1 = resultDataItem1.name;
        NSLog(@"resultName = %@", resultName1);
        
        for (int i = 0 ; i < [storeNamesArr count]; i++) {
            if ([resultName1 isEqualToString:storeNamesArr[i]]) {
                storePlistName = storePlistNameArr[i];
                row = i;
            }
        }
        
        [_searchBar resignFirstResponder];
        [_searchBar setShowsCancelButton:NO animated:YES];
        
        //把搜索结果的表视图隐藏起来
        [_mysearchDisplayController setActive:NO animated:YES];
        
        [self selectStoreName:resultDataItem1.name andStorePlistName:storePlistName];
    }
    else {

        [self selectStoreName:storeNamesArr[indexPath.row] andStorePlistName:storePlistNameArr[indexPath.row]];
    }
}

- (void)selectStoreName:(NSString *)storeName andStorePlistName:(NSString *)storePlistName
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"storePlistName"];
    [[NSUserDefaults standardUserDefaults] setObject:storePlistName forKey:@"storePlistName"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"storeName"];
    [[NSUserDefaults standardUserDefaults] setObject:storeName forKey:@"storeName"];
    
    //是否会员
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isMember"];
    if ([storePlistName isEqualToString:@"16N"] || [storePlistName isEqualToString:@"holy"] ) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isMember"];
    }
    else {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isMember"];
    }
    
    //店铺类型
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"typesOfShops"];
    if ([storePlistName isEqualToString:@"16N"] || [storePlistName isEqualToString:@"yunifang"] ) {
        [[NSUserDefaults standardUserDefaults] setObject:@"supermarket" forKey:@"typesOfShops"];
    }
    else {
        [[NSUserDefaults standardUserDefaults] setObject:@"order" forKey:@"typesOfShops"];
    }
    
    NSLog(@"%@,%@,%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"storePlistName"],[[NSUserDefaults standardUserDefaults] stringForKey:@"storeName"],[[NSUserDefaults standardUserDefaults] stringForKey:@"typesOfShops"]);
    
    NSString * typesOfShops = [[NSUserDefaults standardUserDefaults] stringForKey:@"typesOfShops"];
    //supermarket
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    if ([typesOfShops isEqualToString:@"supermarket"]) {
        
        NewStoreCollectController *newStoreCollectController = [[NewStoreCollectController alloc] init];
        [self.navigationController pushViewController:newStoreCollectController animated:YES];
    }
    else if ([typesOfShops isEqualToString:@"order"]) {
        //点餐
        StoreViewController *storeViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"storeView"];
        [storeViewController setModalPresentationStyle:UIModalPresentationFullScreen];
        [self.navigationController pushViewController:storeViewController animated:YES];
    }
}

@end
