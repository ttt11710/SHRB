//
//  ShoppingCartViewController.h
//  shrb
//
//  Created by PayBay on 15/5/20.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrdersViewController : UIViewController

@property (nonatomic,assign) BOOL isMember;

+ (OrdersViewController *)shareOrdersViewController;
- (void)addTap;
- (void)UpdateTableView;

@end
