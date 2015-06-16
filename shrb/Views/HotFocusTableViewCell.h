//
//  HotMembersTableViewCell.h
//  shrb
//
//  Created by PayBay on 15/5/20.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BFPaperTableViewCell.h>

@interface HotFocusTableViewCell : BFPaperTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *hotImageView;
@property (weak, nonatomic) IBOutlet UIButton *memberBtn;

@end
