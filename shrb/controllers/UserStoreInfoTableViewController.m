//
//  UserStoreInfoTableViewController.m
//  shrb
//
//  Created by PayBay on 15/6/29.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "UserStoreInfoTableViewController.h"
#import "LeftLabelTableViewCell.h"
#import "Const.h"
#import "CityListViewController.h"

@interface UserStoreInfoTableViewController ()

@property (nonatomic, strong) NSMutableArray *dataArray;


@end

@implementation UserStoreInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *selectCityBtn = [[UIBarButtonItem alloc] initWithTitle:@"切换城市" style:UIBarButtonItemStylePlain target:self action:@selector(selectCityBtnPressed)];
    
    self.navigationItem.rightBarButtonItem = selectCityBtn;
    
    [self initData];
    
    //删除底部多余横线
    self.tableView.tableFooterView =[[UIView alloc]init];
    
    self.tableView.backgroundColor = HexRGB(0xF1EFEF);

}

- (void)initData
{
    
    self.dataArray = [[NSMutableArray alloc] initWithObjects:
                      @{
                        @"storeName" : @"上海莘庄店",
                        @"address":@"上海市 闵行区沪闵路6088号莘庄凯德龙之梦购物中心B2楼",
                        @"telephone":@"4008007320"
                        },
                      @{
                        @"storeName" : @"上海浦东店",
                        @"address":@"上海市",
                        @"telephone":@"4008007320"
                        },
                      @{
                        @"storeName" : @"上海虹桥店",
                        @"address":@"上海市",
                        @"telephone":@"4008007320"
                        },
                      @{
                        @"storeName" : @"上海徐汇店",
                        @"address":@"上海市徐汇区钦州南路100号103",
                        @"telephone":@"4008007320"
                        },
                      nil];
}

- (void)updateData:(NSString*)selectedCity
{
    [self.dataArray removeAllObjects];
    if ([selectedCity isEqualToString:@"上海"]) {
        self.dataArray = [NSMutableArray arrayWithObjects:
                          @{
                            @"storeName" : @"上海莘庄店",
                            @"address":@"上海市 闵行区沪闵路6088号莘庄凯德龙之梦购物中心B2楼",
                            @"telephone":@"4008007320"
                            },
                          @{
                            @"storeName" : @"上海浦东店",
                            @"address":@"上海市",
                            @"telephone":@"4008007320"
                            },
                          @{
                            @"storeName" : @"上海虹桥店",
                            @"address":@"上海市",
                            @"telephone":@"4008007320"
                            },
                          @{
                            @"storeName" : @"上海徐汇店",
                            @"address":@"上海市徐汇区钦州南路100号103",
                            @"telephone":@"4008007320"
                            },nil];
    }
    else {
        self.dataArray = [NSMutableArray arrayWithObjects:
                          @{
                            @"storeName" : @"北京王府井店",
                            @"address":@"北京市闵行区沪闵路6088号莘庄凯德龙之梦购物中心B2楼",
                            @"telephone":@"4008007320"
                            },
                          @{
                            @"storeName" : @"北京王府井店",
                            @"address":@"北京市徐汇区钦州南路100号103",
                            @"telephone":@"4008007320"
                            },nil];
    }
    [self.tableView reloadData];
}

#pragma mark - tableView dataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 31;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenWidth - 16, 0)];
    UIFont* theFont = [UIFont systemFontOfSize:17.0];
    label.numberOfLines = 0;
    [label setFont:theFont];
    if (indexPath.row == 0) {
        [label setText:self.dataArray[indexPath.section][@"address"]];
    }
    else {
        [label setText:self.dataArray[indexPath.section][@"telephone"]];
    }
    [label sizeToFit];// 显示文本需要的长度和宽度

    return label.frame.size.height+30 > 44? label.frame.size.height+30:44;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.dataArray[section][@"storeName"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataArray count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimpleTableIdentifier = @"LeftLabelTableViewCellIdentifier";
    LeftLabelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    if (cell == nil) {
        cell = [[LeftLabelTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
    }
    //cell 选中方式
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if (indexPath.row == 0) {
       cell.leftLabel.text = [NSString stringWithFormat:@"地址：%@",self.dataArray[indexPath.section][@"address"]];
    }
    else {
        cell.leftLabel.text = [NSString stringWithFormat:@"电话：%@",self.dataArray[indexPath.section][@"telephone"]];
    }
    
    
    return cell;
}


#pragma mark - 选择城市
- (void)selectCityBtnPressed
{
    NSLog(@"选择城市");
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Card" bundle:nil];
    CityListViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"CityListViewControllerView"];
    viewController.delegate1 = self;
    [viewController setModalPresentationStyle:UIModalPresentationFullScreen];
    [self.navigationController pushViewController:viewController animated:YES];
    
}

//CityListViewController protocol
- (void) citySelectionUpdate:(NSString*)selectedCity
{
    NSLog(@"selectedCity = %@",selectedCity);
    [self updateData:selectedCity];
}

- (NSString*) getDefaultCity
{
    return @"getDefaultCity";
}

@end
