//
//  VoucherCenterViewController.h
//  shrb
//
//  Created by PayBay on 15/6/15.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYBaseViewController.h"

@interface VoucherCenterViewController : PYBaseViewController

@property(nonatomic,assign)NSString * cardNo;
@property(nonatomic,assign)NSNumber * amount;
@property(nonatomic,assign)NSNumber * score;
@property(nonatomic,assign)NSString * merchId;


@end
