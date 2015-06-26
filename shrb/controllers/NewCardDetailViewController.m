//
//  NewCardDetailViewController.m
//  shrb
//
//  Created by PayBay on 15/6/26.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "NewCardDetailViewController.h"
#import "CardImageAndCardNumTableViewCell.h"
#import "LeftLabelTableViewCell.h"
#import "Const.h"
#import "MyTableViewCell.h"


@interface SectionModel : NSObject
{
    BOOL            _flag;
    NSMutableArray  *_sectionDataMutableArray;
}

@property(assign, readwrite, nonatomic)BOOL flag;
@property(readonly, nonatomic)NSMutableArray *sectionDataMutableArray;

@end

@implementation SectionModel

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        _sectionDataMutableArray = [[NSMutableArray alloc] init];
    }
    return self;
}

@end

@interface SectionHeaderView : UIView
{
    UIImageView *_imageView;
    
    UILabel   *_titleLabel;
    
    BOOL            _flag;
    
    UIView    *_bottomLineView;
}
@property(assign, readwrite, nonatomic)BOOL flag;
@property(retain, readwrite, nonatomic)NSString  *title;
@property(assign, readwrite, nonatomic)int  number;

@end

@implementation SectionHeaderView

- (void)setFlag:(BOOL)flag
{
    _flag = flag;
    
    if (_flag)
    {
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            _imageView.layer.transform = CATransform3DIdentity;
            
        } completion:^(BOOL finished) {
            
        }];
    }
    else
    {
        
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            _imageView.layer.transform = CATransform3DMakeRotation(-90 * 3.1415926 / 180.0, 0, 0, 1);
            
        } completion:^(BOOL finished) {
            
        }];
        
        
    }
}

- (void)setTitle:(NSString *)title
{
    _titleLabel.text = title;
}

- (NSString *)title
{
    return _titleLabel.text;
}

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        self.backgroundColor = [UIColor whiteColor];
        
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back_normal.png"]];
        
        [self addSubview:_imageView];
        
        _titleLabel = [[UILabel alloc] init];
        
        _titleLabel.textColor = [UIColor blackColor];
        
        [self addSubview:_titleLabel];
        
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = [UIColor lightGrayColor];
        
        [self addSubview:_bottomLineView];
        
    }
    
    return self;
}



//布局子视图的函数
- (void)layoutSubviews
{
    _imageView.frame = CGRectMake(self.frame.size.width - 50, 15, 15, self.frame.size.height-25);
    
    _titleLabel.frame = CGRectMake(10, 0, self.frame.size.width - 100, self.frame.size.height);
    
    _bottomLineView.frame = CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 1);
}

@end

@interface NewCardDetailViewController ()
{
    //model
    NSMutableArray   *_dataMutableArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end


@implementation NewCardDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataMutableArray = [[NSMutableArray alloc] init];
    
    
    for (int i=0; i<2; i++)
    {
        
        SectionModel *sectionModel = [[SectionModel alloc] init];
        
        sectionModel.flag = NO;//展开的
        
        for (int j=0; j<2; j++)
        {
            [sectionModel.sectionDataMutableArray addObject:[NSString stringWithFormat:@"联系人%d", j+1]];
        }

        
        [_dataMutableArray addObject:sectionModel];
        
    }

}

#pragma mark - tableView dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  indexPath.section == 0? 150:indexPath.section == 3?44:88;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0 || section == 3? 0:44;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 1 || section == 2) {
        SectionHeaderView  *sectionHeaderView = [[SectionHeaderView alloc] init];
        
        sectionHeaderView.tag = section-1;
        
        sectionHeaderView.title = [NSString stringWithFormat:@"第%d分组",section-1];
        
        SectionModel *sectionModel = [_dataMutableArray objectAtIndex:section-1];
        sectionHeaderView.number = [sectionModel.sectionDataMutableArray count];
        sectionHeaderView.flag=sectionModel.flag;
        UITapGestureRecognizer  *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionClick:)];
        
        [sectionHeaderView addGestureRecognizer:tapGestureRecognizer];
        
        return sectionHeaderView;
    }
    return nil;
}

- (void)sectionClick:(UITapGestureRecognizer  *)tapGestureRecognizer
{
    SectionHeaderView  *sectionHeaderView = (SectionHeaderView *)tapGestureRecognizer.view;
    NSLog(@"第%d个分段单击了", sectionHeaderView.tag);
    
    SectionModel * sectionModel = [_dataMutableArray objectAtIndex:sectionHeaderView.tag];
    
    sectionModel.flag =  !(sectionModel.flag);
    
    sectionHeaderView.flag = sectionModel.flag;
    
    NSMutableArray   *indexPathsMutableArray = [[NSMutableArray alloc] init];
    
    for (int i=0; i<[sectionModel.sectionDataMutableArray count]; i++)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:sectionHeaderView.tag+1];
        
        [indexPathsMutableArray addObject:indexPath];
    }
    
    
    NSArray   *indexPathsArray = [indexPathsMutableArray copy];
    
    if (sectionModel.flag)
    {
        [_tableView insertRowsAtIndexPaths:indexPathsArray withRowAnimation:UITableViewRowAnimationFade];
    }
    else
    {
        [_tableView deleteRowsAtIndexPaths:indexPathsArray withRowAnimation:UITableViewRowAnimationFade];
    }
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    }
    else if(section == 3)
    {
        return 2;
    }
    else
    {
        SectionModel *sectionModel = [_dataMutableArray objectAtIndex:section-1];
        if (sectionModel.flag)
        {
            return [sectionModel.sectionDataMutableArray count];;
        }
        else
        {
            return 0;
        }

    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        static NSString *SimpleTableIdentifier = @"CardImageAndCardNumTableViewCellIdentifier";
        CardImageAndCardNumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (cell == nil) {
            cell = [[CardImageAndCardNumTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
        }
        //cell 选中方式
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        return cell;
    }
    else if (indexPath.section == 3)
    {
        static NSString *SimpleTableIdentifier = @"LeftLabelTableViewCellIdentifier";
        LeftLabelTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (cell == nil) {
            cell = [[LeftLabelTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
        }
        
        return cell;
    }
    else {
        static  NSString   *cellId = @"cellId";
        
        
        MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil)
        {
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        
        SectionModel *sectionModel = [_dataMutableArray objectAtIndex:[indexPath section]-1];
        
        cell.textLabel.text = [sectionModel.sectionDataMutableArray objectAtIndex:[indexPath row]];
        
        return cell;

    }
}

@end
