//
//  CompletePayOrdersTableViewCell.h
//  shrb
//
//  Created by PayBay on 15/7/6.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompletePayOrdersTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *tradeNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@end
