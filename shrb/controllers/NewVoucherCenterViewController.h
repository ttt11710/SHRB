//
//  NewVoucherCenterViewController.h
//  shrb
//
//  Created by PayBay on 15/8/28.
//  Copyright © 2015年 PayBay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYBaseViewController.h"

@interface NewVoucherCenterViewController : PYBaseViewController

@property(nonatomic,assign)NSString * cardNo;
@property(nonatomic,assign)NSNumber * amount;
@property(nonatomic,assign)NSNumber * score;
@property(nonatomic,assign)NSString * merchId;

@end
