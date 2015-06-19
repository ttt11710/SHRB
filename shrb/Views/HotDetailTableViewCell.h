//
//  HotDetailTableViewCell.h
//  shrb
//
//  Created by PayBay on 15/5/19.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LazyFadeInView.h"
@class HotFocusModel;

@interface HotDetailTableViewCell : UITableViewCell
@property (nonatomic,strong) HotFocusModel * model;

@end
