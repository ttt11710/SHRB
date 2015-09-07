//
//  ShoppingCartViewController.h
//  shrb
//
//  Created by PayBay on 15/5/20.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYBaseViewController.h"

@interface OrdersViewController : PYBaseViewController

@property (nonatomic,assign) BOOL isMember;

@property(nonatomic,assign)NSString * merchId;
@property(nonatomic,assign)NSString * prodId;
@property (copy, readwrite, nonatomic) NSMutableArray *shoppingArray;

+ (OrdersViewController *)shareOrdersViewController;
- (void)addTap;
- (void)UpdateTableView;

@end
