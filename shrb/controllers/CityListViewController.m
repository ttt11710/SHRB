//
//  CityListViewController.m
//
//  Created by Big Watermelon on 11-11-10.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "CityListViewController.h"
#import "Const.h"


#define btnWidth (screenWidth-4*30)/3
#define btnHeight 35

@interface CityListViewController ()
@property (nonatomic, retain) UIImageView* checkImgView;
@property NSUInteger curSection;
@property NSUInteger curRow;
@property NSUInteger defaultSelectionRow;
@property NSUInteger defaultSelectionSection;

@property (nonatomic, strong) NSMutableArray *dataArray;

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
    
    self.dataArray = [[NSMutableArray alloc] initWithObjects:@"上海",@"北京",@"广州",@"深圳",@"武汉",@"天津",@"西安",@"南京",@"杭州",@"成都",@"重庆", nil];
    
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [keys count]+2;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section <= 1) {
        return 1;
    }
    NSString *key = [keys objectAtIndex:section-2];
    NSArray *citySection = [cities objectForKey:key];
    return [citySection count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0?30:21;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 55;
    }
    else if (indexPath.section == 1) {
        CGFloat height = ([self.dataArray count]/3+([self.dataArray count]%3==0?0:1)) *(10+btnHeight)+10;
        return height;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
        UIButton *cityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cityBtn.tag = -1;
        cityBtn.frame = CGRectMake(30, 10, btnWidth, btnHeight);
        [cityBtn setTitle:@"上海" forState:UIControlStateNormal];
        cityBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [cityBtn setTintColor:[UIColor clearColor]];
        [cityBtn setBackgroundColor:[UIColor whiteColor]];
        [cityBtn setTitleColor:shrbText forState:UIControlStateNormal];
        cityBtn.layer.borderColor = shrbText.CGColor;
        cityBtn.layer.borderWidth = 1;
        cityBtn.layer.cornerRadius = 5;
        cityBtn.layer.masksToBounds = YES;
        [cityBtn addTarget:self action:@selector(selectCityBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:cityBtn];
    }
    else if (indexPath.section == 1) {
        
        for (int i = 0; i < [self.dataArray count]; i++) {
            UIButton *cityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            cityBtn.tag = i;
            cityBtn.frame = CGRectMake(30*(i%3+1)+btnWidth*(i%3), 10*(i/3+1)+btnHeight*(i/3), btnWidth, btnHeight);
            [cityBtn setTitle:[self.dataArray objectAtIndex:i] forState:UIControlStateNormal];
            cityBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
            [cityBtn setTintColor:[UIColor clearColor]];
            [cityBtn setBackgroundColor:[UIColor whiteColor]];
            [cityBtn setTitleColor:shrbText forState:UIControlStateNormal];
            cityBtn.layer.borderColor = shrbText.CGColor;
            cityBtn.layer.borderWidth = 1;
            cityBtn.layer.cornerRadius = 5;
            cityBtn.layer.masksToBounds = YES;
            [cityBtn addTarget:self action:@selector(selectCityBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:cityBtn];
        }
    }
    else {
        NSString *key = [keys objectAtIndex:indexPath.section-2];
        cell.textLabel.text = [[cities objectForKey:key] objectAtIndex:indexPath.row];
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"当前位置";
    }
    else if (section == 1) {
        return @"热门城市";
    }
    else {
        NSString *key = [keys objectAtIndex:section-2];
        return key;
    }
}  

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView  
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:keys];
    [array insertObject:@"#" atIndex:0];
    [array insertObject:@"$" atIndex:1];
    return array;
} 


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        [delegate1 citySelectionUpdate:@"上海"];
    }
    else if (indexPath.section == 1){
        
    }
    else {
        curSection = indexPath.section-2;
        curRow = indexPath.row;
        
        if (curRow != NSNotFound) {
            NSString* key = [keys objectAtIndex:curSection];
            [delegate1 citySelectionUpdate:[[cities objectForKey:key] objectAtIndex:curRow]];
        }
        
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)selectCityBtnPressed:(UIButton *)button
{
    NSLog(@"button.tag = %ld",(long)button.tag);
    
    if (button.tag == -1) {
        [delegate1 citySelectionUpdate:@"上海"];
    }
    else {
       [delegate1 citySelectionUpdate:[self.dataArray objectAtIndex:button.tag]];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
