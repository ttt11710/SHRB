//
//  HotMembersTableViewCell.h
//  shrb
//
//  Created by PayBay on 15/5/20.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <BFPaperTableViewCell.h>
#import "MyImageView.h"
@class HotFocusModel;

@interface HotFocusTableViewCell : UITableViewCell
@property (nonatomic,strong) HotFocusModel * model;

@property (weak, nonatomic) IBOutlet UIView *shadowView;  //阴影
@property (weak, nonatomic) IBOutlet MyImageView *hotImageView;  //图片
@property (weak, nonatomic) IBOutlet UIImageView *storeLabelImage; //标签

@end
