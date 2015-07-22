//
//  ProductViewController.h
//  shrb
//
//  Created by PayBay on 15/7/22.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductViewController : UIViewController <UIScrollViewDelegate>

@property(nonatomic,assign)NSInteger currentSection;
@property(nonatomic,assign)NSInteger currentRow;

+ (ProductViewController *)shareProductViewController;
- (void)becomeMember;

@end
