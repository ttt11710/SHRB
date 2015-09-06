//
//  StoreViewController.h
//  shrb
//
//  Created by PayBay on 15/5/20.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYBaseViewController.h"

@interface StoreViewController : PYBaseViewController <UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,assign)NSString * merchId;
@property(nonatomic,assign)NSString * merchTitle;

+ (StoreViewController *)shareStoreViewController;

- (void)gotoPayView;
- (void)UpdateTableView;

- (void)pushCardDetailView;

@end
