//
//  ShoppingCartTableViewCell.h
//  shrb
//
//  Created by PayBay on 15/5/20.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrdersTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *couponsImageView;
@property (weak, nonatomic) IBOutlet UITextView *settlementTextView;
@property (weak, nonatomic) IBOutlet UIImageView *checkImageView;
@property (weak, nonatomic) IBOutlet UILabel *couponLabel;
@property (weak, nonatomic) IBOutlet UITextView *ruleTextView;
@property (weak, nonatomic) IBOutlet UILabel *tradeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;


@end
