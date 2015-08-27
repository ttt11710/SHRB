//
//  ProductIsMemberViewController.h
//  shrb
//
//  Created by PayBay on 15/7/22.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYBaseViewController.h"

@interface ProductIsMemberViewController : PYBaseViewController<UIScrollViewDelegate>

@property (nonatomic,strong) NSMutableDictionary * productDataDic;
@property (nonatomic,strong) NSMutableDictionary * cardDataDic;

+ (ProductIsMemberViewController *)shareProductIsMemberViewController;

@end
