//
//  HotMembersTableViewCell.m
//  shrb
//
//  Created by PayBay on 15/5/20.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "HotFocusTableViewCell.h"
#import "UIColor+BFPaperColors.h"
#import "Const.h"
#import <QuartzCore/CoreAnimation.h>
#import "SVProgressShow.h"

@interface HotFocusTableViewCell () 
{
    NSMutableArray *_arr;
    NSMutableArray *_imageArr;
}





@end
@implementation HotFocusTableViewCell

//- (void)setModel:(Store *)model
//{
////    _imageArr = [[NSMutableArray alloc] init];
////    for (NSString *str in model.images) {
////        [_imageArr addObject:str];
////    }
//    
////    self.descriptionLabel.text = model.simpleStoreDetail;
////    
////    self.hotImageView.currentInt = 0;
////    [self.hotImageView initImageArr];
////    self.hotImageView.imageArr = _imageArr;
////    [self.hotImageView beginAnimation];
//    
//    _imageArr = [[NSMutableArray alloc] init];
//    for (NSString *str in model.imgUrls) {
//        [_imageArr addObject:str];
//    }
//    
//    self.descriptionLabel.text = model.merchDesc;
//    
//    self.hotImageView.currentInt = 0;
//    [self.hotImageView initImageArr];
//    self.hotImageView.imageArr = _imageArr;
//    [self.hotImageView beginAnimation];
//    
//}


- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];   // THIS IS NECESSARY!
    [self customSetup];
}

- (void)customSetup
{
    self.descriptionLabel.textColor = shrbText;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
