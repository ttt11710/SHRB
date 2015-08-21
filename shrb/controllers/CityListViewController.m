//
//  CityListViewController.m
//
//  Created by Big Watermelon on 11-11-10.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "CityListViewController.h"
#import "Const.h"
#import <CoreLocation/CoreLocation.h>
#import "SVProgressShow.h"


#define btnWidth (screenWidth-4*21)/3
#define btnHeight 35

@interface ResultDataItem : NSObject
{
    NSString  *_name;
    NSIndexPath *_indexPath;
}

@property(copy, readwrite, nonatomic)NSString  *name;
@property(retain, readwrite, nonatomic)NSIndexPath  *indexPath;

@end

@implementation ResultDataItem

@end




@interface CityListViewController () <CLLocationManagerDelegate>
{
    NSString *_currentCity;
    NSString *_locationCity;
}

@property (nonatomic, retain) UIImageView* checkImgView;
@property NSUInteger curSection;
@property NSUInteger curRow;
@property NSUInteger defaultSelectionRow;
@property NSUInteger defaultSelectionSection;

@property (nonatomic, strong) NSMutableArray *hotCityArray;
@property (nonatomic, strong) NSMutableArray *countryArray;
@property (nonatomic, strong) NSMutableArray *resultDataMutableArray;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;


@property (strong, nonatomic) CLLocationManager* locationManager;

@end

@implementation CityListViewController
@synthesize tableView;

#define CHECK_TAG 1110

@synthesize cities, keys, checkImgView, curSection, curRow, delegate1;
@synthesize defaultSelectionRow, defaultSelectionSection;

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
    curRow = NSNotFound;
    
    _currentCity = @"北京市";
    
    [self startLocation];
    
    self.hotCityArray = [[NSMutableArray alloc] initWithObjects:@"上海",@"北京",@"广州",@"深圳",@"武汉",@"天津",@"西安",@"南京",@"杭州",@"成都",@"重庆", nil];
    self.countryArray = [[NSMutableArray alloc] initWithObjects:@"韩国",@"日本", nil];
    self.resultDataMutableArray = [[NSMutableArray alloc] init];
    
    //去除tableview顶部留白
    self.automaticallyAdjustsScrollViewInsets = false;
    //改变索引的颜色
    self.tableView.sectionIndexColor = shrbPink;
    
    _mysearchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    
    _mysearchDisplayController.searchResultsDataSource = self;
    _mysearchDisplayController.searchResultsDelegate = self;
    _mysearchDisplayController.delegate = self;
    
    
    
//    UISearchBar * searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, screenWidth+80, 30)];
//    searchBar.translucent = YES;
//    searchBar.barStyle = UIBarStyleDefault;
//    searchBar.showsCancelButton = YES;
//    [searchBar sizeToFit];
//    [self.tableView setTableHeaderView:searchBar];
    
    
    self.checkImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check"]];
    checkImgView.tag = CHECK_TAG;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    NSString *path=[[NSBundle mainBundle] pathForResource:@"citydict"   
                                                   ofType:@"plist"]; 
    self.cities = [[NSDictionary alloc]   
                   initWithContentsOfFile:path];
    
    self.keys = [[cities allKeys] sortedArrayUsingSelector:  
                 @selector(compare:)]; 
    
    
    //get default selection from delegate
    NSString* defaultCity = [delegate1 getDefaultCity];
    if (defaultCity) {
        NSArray *citySection;
        self.defaultSelectionRow = NSNotFound;
        //set table index to this city if it existed
        for (NSString* key in keys) {
            citySection = [cities objectForKey:key];
            self.defaultSelectionRow = [citySection indexOfObject:defaultCity];
            if (NSNotFound == defaultSelectionRow)
                continue;
            //found match recoard position
            self.defaultSelectionSection = [keys indexOfObject:key];
            break;
        }
        
        if (NSNotFound != defaultSelectionRow) {
            
            self.curSection = defaultSelectionSection;
            self.curRow = defaultSelectionRow;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:defaultSelectionRow inSection:defaultSelectionSection];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            
        }
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.keys = nil;
    self.cities = nil;
    self.checkImgView = nil;
    self.tableView = nil;
}

- (void)viewDidLayoutSubviews
{
    if (IsiPhone4s && self.searchBar.showsCancelButton) {
        self.searchBar.frame = CGRectMake(0, 20, screenWidth, 44);
        self.tableView.frame = CGRectMake(0, 20+44, screenWidth, screenHeight - 64 - 44);
    }
    if (IsiPhone4s && self.searchBar.frame.origin.y == 64 && !self.searchBar.showsCancelButton) {
        self.searchBar.frame = CGRectMake(0, 64, screenWidth, 44);
        self.tableView.frame = CGRectMake(0, 64+44, screenWidth, screenHeight - 64 - 44);
    }
    [self.view layoutSubviews];
}


-(void)startLocation{
    
    if([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = 10.0f;
    }else {
        
        [SVProgressShow showInfoWithStatus:@"您关闭了的定位功能，将无法收到位置信息，建议您到系统设置打开定位功能!"];
    }
    
        [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *cloc = [locations lastObject];
    
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:cloc completionHandler:^(NSArray *placemarks, NSError *error) {
        if (!error)
        {
            NSDictionary *test = [[placemarks objectAtIndex:0] addressDictionary];
            //  Country(国家)  State(城市)  SubLocality(区)
            
            _locationCity = [test objectForKey:@"State"];
            if ([_currentCity isEqualToString:_locationCity]) {
                return ;
            }
            
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"系统定位到您在%@，需要切换至%@吗？",_locationCity,_locationCity] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alter.tag=1;
            [alter show];
            [self.locationManager stopUpdatingLocation];
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    
    if (error.code == kCLErrorDenied) {
        
        NSLog(@"error.code = %ld",(long)error.code);
        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case 1:   //询问是否使用定位位置
            if (buttonIndex == 0)
                return;
            else {
                _currentCity = _locationCity;
                [self.tableView reloadData];
            }
            break;
            
        default:
            break;
    }
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
    
    
    //搜索联系人
    NSString *keyString = searchString;
    
    for (int i=0; i<[keys count]; i++)
    {
        NSMutableArray *cityArray = [cities objectForKey:[keys objectAtIndex:i]];
        
        for (int j=0; j<[cityArray count]; j++)
        {
            NSString  *city = [cityArray objectAtIndex:j];
        
            if ([city rangeOfString:keyString].length > 0)
            {
                ResultDataItem *resultDataItem = [[ResultDataItem alloc] init];
                resultDataItem.name = city;
                resultDataItem.indexPath = [NSIndexPath indexPathForRow:j inSection:i];
                
                [_resultDataMutableArray addObject:resultDataItem];
            }
        }
    }
    
    NSLog(@"%@",_resultDataMutableArray);
    
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.tableView == tableView) {
        return [keys count]+3;
    }
    else
    {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.

    if (self.tableView == tableView) {
        if (section <= 2) {
            return 1;
        }
        NSString *key = [keys objectAtIndex:section-3];
        NSArray *citySection = [cities objectForKey:key];
        return [citySection count];
    }
    else
    {
        return [_resultDataMutableArray count];
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    else
    return section <=2 ?30:21;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 55;
    }
    else if (indexPath.section == 1) {
        CGFloat height = ([self.hotCityArray count]/3+([self.hotCityArray count]%3==0?0:1)) *(10+btnHeight)+10;
        return height;
    }
    else if (indexPath.section == 2) {
        CGFloat height = ([self.countryArray count]/3+([self.countryArray count]%3==0?0:1)) *(10+btnHeight)+10;
        return height;
    }
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
    
    if (indexPath.section == 0) {
        cell.textLabel.font = [UIFont systemFontOfSize:17.0];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@  GDP定位",_currentCity]];
        
        [attrString addAttribute:NSForegroundColorAttributeName value:shrbText range:NSMakeRange(0, _currentCity.length)];
        [attrString addAttribute:NSForegroundColorAttributeName value:shrbLightText range:NSMakeRange(_currentCity.length+2, 5)];
        [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, _currentCity.length)];
        [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(_currentCity.length+2, 5)];
        cell.textLabel.attributedText = attrString;

        
//        UIButton *cityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        cityBtn.tag = -1;
//        cityBtn.frame = CGRectMake(30, 10, btnWidth, btnHeight);
//        [cityBtn setTitle:@"上海" forState:UIControlStateNormal];
//        cityBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
//        [cityBtn setTintColor:[UIColor clearColor]];
//        [cityBtn setBackgroundColor:[UIColor whiteColor]];
//        [cityBtn setTitleColor:shrbText forState:UIControlStateNormal];
//        cityBtn.layer.borderColor = shrbText.CGColor;
//        cityBtn.layer.borderWidth = 1;
//        cityBtn.layer.cornerRadius = 5;
//        cityBtn.layer.masksToBounds = YES;
//        [cityBtn addTarget:self action:@selector(selectCityBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
//        [cell addSubview:cityBtn];
    }
    else if (indexPath.section == 1) {
        
        cell.backgroundColor = shrbLightCell;
        
        for (int i = 0; i < [self.hotCityArray count]; i++) {
            UIButton *cityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            cityBtn.tag = i;
            cityBtn.frame = CGRectMake(21*(i%3+1)+btnWidth*(i%3), 10*(i/3+1)+btnHeight*(i/3), btnWidth, btnHeight);
            [cityBtn setTitle:[self.hotCityArray objectAtIndex:i] forState:UIControlStateNormal];
            cityBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
            [cityBtn setTintColor:[UIColor clearColor]];
            [cityBtn setBackgroundColor:[UIColor whiteColor]];
            [cityBtn setTitleColor:shrbText forState:UIControlStateNormal];
            cityBtn.layer.borderColor = [UIColor colorWithRed:212.0/255.0 green:212.0/255.0 blue:212.0/255.0 alpha:1].CGColor;
            cityBtn.layer.borderWidth = 1;
            cityBtn.layer.cornerRadius = 5;
            cityBtn.layer.masksToBounds = YES;
            [cityBtn addTarget:self action:@selector(selectCityBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:cityBtn];
        }
    }
    else if (indexPath.section == 2) {
        
        cell.backgroundColor = shrbLightCell;
        
        for (int i = 0; i < [self.countryArray count]; i++) {
            UIButton *cityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            cityBtn.tag = i;
            cityBtn.frame = CGRectMake(21*(i%3+1)+btnWidth*(i%3), 10*(i/3+1)+btnHeight*(i/3), btnWidth, btnHeight);
            [cityBtn setTitle:[self.countryArray objectAtIndex:i] forState:UIControlStateNormal];
            cityBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
            [cityBtn setTintColor:[UIColor clearColor]];
            [cityBtn setBackgroundColor:[UIColor whiteColor]];
            [cityBtn setTitleColor:shrbText forState:UIControlStateNormal];
            cityBtn.layer.borderColor = [UIColor colorWithRed:212.0/255.0 green:212.0/255.0 blue:212.0/255.0 alpha:1].CGColor;
            cityBtn.layer.borderWidth = 1;
            cityBtn.layer.cornerRadius = 5;
            cityBtn.layer.masksToBounds = YES;
            [cityBtn addTarget:self action:@selector(selectcountryBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:cityBtn];
        }
    }
    else {
        NSString *key = [keys objectAtIndex:indexPath.section-3];
        cell.textLabel.text = [[cities objectForKey:key] objectAtIndex:indexPath.row];
    }
    
    return cell;
    }
    else {
        static  NSString   *cellId = @"cellId";
    
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        
        ResultDataItem *resultDataItem =  [_resultDataMutableArray objectAtIndex:[indexPath row]];
        cell.textLabel.text = resultDataItem.name;
        
        return cell;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(self.tableView != tableView) {
        return @"搜索结果";
    }
    else {
//        if (section == 0) {
//            return @"当前位置";
//        }
       if (section == 1) {
            return @"热门城市";
        }
        else if (section == 2) {
            return @"其他国家";
        }
        else {
            NSString *key = [keys objectAtIndex:section-3];
            return key;
        }
 
    }
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat height ;
    height = section <=2 ?30:21;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, height)] ;
    [headerView setBackgroundColor:shrbLightCell];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, (height-18)*0.5, tableView.bounds.size.width - 10, 18)];
    if(self.tableView != tableView) {
        label.text = @"搜索结果";
    }
    else {
        if (section == 0) {
            label.text = @"当前位置";
        }
        else if (section == 1) {
            label.text = @"热门城市";
        }
        else if (section == 2) {
            label.text = @"其他国家";
        }
        else {
            NSString *key = [keys objectAtIndex:section-3];
            label.text = key;
        }
        
    }
    label.textColor = shrbLightText;
    label.backgroundColor = [UIColor clearColor];
    [headerView addSubview:label];
    
    return headerView;
}

//返回索引数组
//-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:keys];
//    [array insertObject:@"#" atIndex:0];
//    [array insertObject:@"$" atIndex:1];
//    [array insertObject:@"&" atIndex:2];
//
//    return array;
//}

//响应点击索引时的委托方法
//-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
//{
//    NSInteger count = 0;
//    
//    NSLog(@"%@-%ld",title,(long)index);
//    
//    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:keys];
//    [array insertObject:@"#" atIndex:0];
//    [array insertObject:@"$" atIndex:1];
//    [array insertObject:@"&" atIndex:2];
//    
//    for(NSString *character in array)
//    {
//        if([character isEqualToString:title])
//        {
//            return count;
//        }
//        count ++;
//    }
//    return 0;
//}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableView != tableView)
    {
        ResultDataItem *resultDataItem = [_resultDataMutableArray objectAtIndex:[indexPath row]];
        
        NSString *resultName = resultDataItem.name;
        NSLog(@"resultName = %@", resultName);
        
        [_searchBar resignFirstResponder];
        [_searchBar setShowsCancelButton:NO animated:YES];
        
        //把搜索结果的表视图隐藏起来
        [_mysearchDisplayController setActive:NO animated:YES];
    
        [delegate1 citySelectionUpdate:resultDataItem.name];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    else {
        if (indexPath.section == 0) {
            [delegate1 citySelectionUpdate:_currentCity];
        }
        else if (indexPath.section <= 2) {
            return;
        }
        else {
            curSection = indexPath.section-3;
            curRow = indexPath.row;
            
            if (curRow != NSNotFound) {
                NSString* key = [keys objectAtIndex:curSection];
                [delegate1 citySelectionUpdate:[[cities objectForKey:key] objectAtIndex:curRow]];
            }
            
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 选择热门城市
- (void)selectCityBtnPressed:(UIButton *)button
{
    NSLog(@"button.tag = %ld",(long)button.tag);
    
    if (button.tag == -1) {
        [delegate1 citySelectionUpdate:@"上海"];
    }
    else {
       [delegate1 citySelectionUpdate:[self.hotCityArray objectAtIndex:button.tag]];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 选择国家
- (void)selectcountryBtnPressed:(UIButton *)button
{
    [delegate1 citySelectionUpdate:[self.countryArray objectAtIndex:button.tag]];
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
