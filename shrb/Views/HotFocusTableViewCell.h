//
//  HotMembersTableViewCell.h
//  shrb
//
//  Created by PayBay on 15/5/20.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BFPaperTableViewCell.h>
@class HotFocusModel;

@interface HotFocusTableViewCell : BFPaperTableViewCell
@property (nonatomic,strong) HotFocusModel * model;
@property (weak, nonatomic) IBOutlet UIImageView *hotImageView;

@end
