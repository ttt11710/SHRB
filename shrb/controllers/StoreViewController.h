//
//  StoreViewController.h
//  shrb
//
//  Created by PayBay on 15/5/20.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoreViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,assign)NSInteger currentRow;

+ (StoreViewController *)shareStoreViewController;
- (void)UpdateTableView;

@end
