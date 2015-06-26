//
//  ProductModel.h
//  shrb
//
//  Created by PayBay on 15/6/26.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import <Foundation/Foundation.h>
/*商品详情*/
@interface ProductModel : NSObject
@property(nonatomic,copy) NSString *tradeImage;
@property(nonatomic,copy) NSString *saveMoney;
@property(nonatomic,copy) NSString *tradeDescription;
@property(nonatomic,copy) NSString *money;
@property(nonatomic,copy) NSString *integral;
@property(nonatomic,copy) NSString *cardNumber;

@end
