//
//  ProductTableViewCell.h
//  shrb
//
//  Created by PayBay on 15/6/26.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProductModel;

@interface ProductTableViewCell : UITableViewCell
@property (nonatomic,strong) ProductModel * model;
@property (weak, nonatomic) IBOutlet UIImageView *tradeImageView;

@end
