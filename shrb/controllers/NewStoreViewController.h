//
//  NewStoreViewController.h
//  shrb
//
//  Created by PayBay on 15/6/25.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewStoreViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>


+ (NewStoreViewController *)shareStoreViewController;
- (void)UpdateTableView;

@end
