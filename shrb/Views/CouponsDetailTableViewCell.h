//
//  CouponsDetailTableViewCell.h
//  shrb
//
//  Created by PayBay on 15/6/8.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CouponsModel;

@interface CouponsDetailTableViewCell : UITableViewCell
@property (nonatomic,strong) CouponsModel * model;
@property (weak, nonatomic) IBOutlet UIButton *userCouponBtn;
@end
