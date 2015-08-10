//
//  HotMembersTableViewCell.m
//  shrb
//
//  Created by PayBay on 15/5/20.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "HotFocusTableViewCell.h"
#import "UIColor+BFPaperColors.h"
#import "HotFocusModel.h"
#import "Const.h"
#import <QuartzCore/CoreAnimation.h>
#import "SVProgressShow.h"
#import "Store.h"

@interface HotFocusTableViewCell () 
{
    NSMutableArray *_arr;
    NSMutableArray *_imageArr;
}


@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;


@end
@implementation HotFocusTableViewCell

- (void)setModel:(Store *)model
{
//    // load all the frames of our animation
    _arr = [[NSMutableArray alloc] init];
    for (NSString *str in model.images) {
        [_arr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%@",str]]];
    }
    _imageArr = [[NSMutableArray alloc] init];
    for (NSString *str in model.images) {
        [_imageArr addObject:str];
    }
    
    self.descriptionLabel.text = model.simpleStoreDetail;
    
    self.hotImageView.currentInt = 0;
    [self.hotImageView initImageArr];
    self.hotImageView.imageArr = _imageArr;
    [self.hotImageView beginAnimation];
    
}


- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];   // THIS IS NECESSARY!
    [self customSetup];
}

- (void)customSetup
{
    self.shadowView.layer.cornerRadius = 5;
    self.shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.shadowView.layer.shadowOffset = CGSizeMake(2,2);
    self.shadowView.layer.shadowOpacity = 0.5;
    self.shadowView.layer.shadowRadius = 2.0;

    self.descriptionLabel.textColor = shrbText;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
