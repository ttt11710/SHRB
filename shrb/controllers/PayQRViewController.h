//
//  PayQRViewController.h
//  shrb
//
//  Created by PayBay on 15/6/30.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^QRUrlBlock)(NSString *url);
@interface PayQRViewController : UIViewController


@property(nonatomic,assign)NSString * merchId;

@property (nonatomic, copy) QRUrlBlock qrUrlBlock;

@end

