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

@interface HotFocusTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet MyImageView *hotImageView;  //图片


@end
