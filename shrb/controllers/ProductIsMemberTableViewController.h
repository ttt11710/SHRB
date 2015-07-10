//
//  ProductIsMemberTableViewController.h
//  shrb
//
//  Created by PayBay on 15/6/26.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductIsMemberTableViewController : UITableViewController

@property(nonatomic,assign)NSInteger currentSection;
@property(nonatomic,assign)NSInteger currentRow;

+ (ProductIsMemberTableViewController *)shareProductIsMemberTableViewController;
- (void)gotoCardDetailView;

@end
