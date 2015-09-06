//
//  SuperQRViewController.h
//  shrb
//
//  Created by PayBay on 15/7/13.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYBaseViewController.h"

typedef void(^QRUrlBlock)(NSMutableArray *url);
@interface SuperQRViewController : PYBaseViewController


@property (nonatomic, copy) QRUrlBlock qrUrlBlock;

@property(nonatomic,assign)NSString * merchId;

@end

