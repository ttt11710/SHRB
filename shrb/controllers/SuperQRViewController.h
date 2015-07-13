//
//  SuperQRViewController.h
//  shrb
//
//  Created by PayBay on 15/7/13.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^QRUrlBlock)(NSString *url);
@interface SuperQRViewController : UIViewController


@property (nonatomic, copy) QRUrlBlock qrUrlBlock;

@end

