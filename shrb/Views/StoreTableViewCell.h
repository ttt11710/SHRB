//
//  CouponsTableViewCell.h
//  shrb
//
//  Created by PayBay on 15/5/20.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoreTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *couponsImageView;
@property (weak, nonatomic) IBOutlet UILabel *tradeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;


@end
