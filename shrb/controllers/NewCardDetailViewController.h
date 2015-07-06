//
//  NewCardDetailViewController.h
//  shrb
//
//  Created by PayBay on 15/6/26.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewCardDetailViewController : UIViewController

@property (nonatomic,assign) NSString *viewControllerName;

+ (NewCardDetailViewController *)shareNewCardDetailViewController;
- (void)completePay;

@end
