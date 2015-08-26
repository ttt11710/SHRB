//
//  ProductViewController.h
//  shrb
//
//  Created by PayBay on 15/7/22.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYBaseViewController.h"

@interface ProductViewController : PYBaseViewController <UIScrollViewDelegate>

@property(nonatomic,assign)NSString * prodId;

+ (ProductViewController *)shareProductViewController;
- (void)becomeMember;

- (void)initDescriptionAndregisterView;

@end
