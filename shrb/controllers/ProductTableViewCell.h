//
//  ProductTableViewCell.h
//  shrb
//
//  Created by PayBay on 15/6/26.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoldingView.h"
@class ProductModel;


@interface ProductTableViewCell : UITableViewCell <UIScrollViewDelegate,UIPageViewControllerDelegate>

@property (nonatomic,strong) ProductModel * model;
@property (weak, nonatomic) IBOutlet UIImageView *tradeImageView;
@property (weak, nonatomic) IBOutlet UIView *blurView;

@property (weak, nonatomic) IBOutlet FoldingView *ImageBackView;

+(void)setscrollView;

@end
