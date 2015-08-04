//
//  PYBaseViewController.h
//  shrb
//
//  Created by PayBay on 15/8/3.
//  Copyright © 2015年 PayBay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking.h>

@interface PYBaseViewController : UIViewController

@property (nonatomic,strong)AFHTTPRequestOperationManager *requestOperationManager;

@end
