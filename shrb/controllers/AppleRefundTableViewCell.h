//
//  AppleRefundTableViewCell.h
//  shrb
//
//  Created by PayBay on 15/8/24.
//  Copyright © 2015年 PayBay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppleRefundTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *returnGoodsReasonLabel;

@property (nonatomic, copy) void (^returnCallBack)(NSString *string);  //退货理由
@property (nonatomic, copy) void (^callBack)(NSString *money);        //退货申请提交

@end
