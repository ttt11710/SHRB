//
//  VoucherAmoutTableViewCell.h
//  shrb
//
//  Created by PayBay on 15/8/28.
//  Copyright © 2015年 PayBay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VoucherAmoutTableViewCell : UITableViewCell <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *amountTextField;

@end
