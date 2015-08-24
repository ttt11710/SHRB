//
//  AppleRefundTableViewCell.h
//  shrb
//
//  Created by PayBay on 15/8/24.
//  Copyright © 2015年 PayBay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppleRefundTableViewCell : UITableViewCell


@property (nonatomic, copy) void (^callBack)(NSString *money);

@end
