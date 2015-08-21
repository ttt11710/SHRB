//
//  OrderTableViewCell.h
//  shrb
//
//  Created by PayBay on 15/8/21.
//  Copyright © 2015年 PayBay. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderListModel;

@interface OrderTableViewCell : UITableViewCell

@property (nonatomic,strong) OrderListModel * model;

@end
