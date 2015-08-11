//
//  ShoppingCardView.h
//  shrb
//
//  Created by PayBay on 15/8/11.
//  Copyright © 2015年 PayBay. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ShoppingNumLabel : UILabel
{
    NSInteger _num;
}

@property (assign, readwrite, nonatomic)NSInteger num;

@end

@interface ShoppingCardView : UIView


@property (strong, nonatomic) ShoppingNumLabel *shoppingNumLabel;
@property (nonatomic) UILabel *countDownLabel;

@property (nonatomic) NSInteger countTime;

- (void)showShoppingCard;

@end
