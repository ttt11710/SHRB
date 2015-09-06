//
//  PayViewController.h
//  shrb
//
//  Created by PayBay on 15/5/20.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYBaseViewController.h"

@interface PayViewController : PYBaseViewController

@property (nonatomic,assign) BOOL isMemberPay;
@property (nonatomic,assign) CGFloat totalPrice;
@property (copy, readwrite, nonatomic) NSMutableArray *shoppingArray;

@end
