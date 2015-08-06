//
//  ShoppingCartTableViewCell.h
//  shrb
//
//  Created by PayBay on 15/5/20.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TNCheckBoxGroup.h"


extern NSString *const PAY_CHANGED;

@interface OrdersTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *couponsImageView;
//@property (weak, nonatomic) IBOutlet UITextView *settlementTextView;
@property (weak, nonatomic) IBOutlet UILabel*settlementLable;

@property (weak, nonatomic) IBOutlet UIImageView *checkImageView;
@property (weak, nonatomic) IBOutlet UILabel *couponLabel;
@property (weak, nonatomic) IBOutlet UITextView *ruleTextView;
@property (weak, nonatomic) IBOutlet UILabel *tradeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *memberTotalLabel;
@property (weak, nonatomic) IBOutlet TNCheckBoxGroup *checkCouponsView;


@property (weak, nonatomic) IBOutlet TNCheckBoxGroup *payViewCheckCouponsView;

@property (weak, nonatomic) IBOutlet UIButton *memberBtn;
@property (weak, nonatomic) IBOutlet UIButton *memberLabelBtn;

@property (weak, nonatomic) IBOutlet UIButton *alipayBtn;
@property (weak, nonatomic) IBOutlet UIButton *alipayLabelBtn;

@property (weak, nonatomic) IBOutlet UIButton *internetbankLabelBtn;
@property (weak, nonatomic) IBOutlet UIButton *internetbankBtn;


@end
