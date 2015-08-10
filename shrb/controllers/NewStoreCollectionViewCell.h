//
//  NewStoreCollectionViewCell.h
//  shrb
//
//  Created by PayBay on 15/7/27.
//  Copyright © 2015年 PayBay. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TradeModel;

@interface NewStoreCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) TradeModel * model;

@property (weak, nonatomic) IBOutlet UIImageView *tradeImageView;
@property (weak, nonatomic) IBOutlet UILabel *tradeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *memberPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *originalPriceLabel;

@end
