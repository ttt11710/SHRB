//
//  CardTableViewCell.h
//  shrb
//
//  Created by PayBay on 15/5/20.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CardModel;

@interface CardTableViewCell : UITableViewCell
@property (nonatomic,strong) CardModel * model;

@end
