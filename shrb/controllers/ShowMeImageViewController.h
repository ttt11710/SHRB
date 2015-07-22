//
//  ShowMeImageViewController.h
//  Mercury
//
//  Created by IOS dev on 15/2/4.
//  Copyright (c) 2015年 GangXu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowMeImageViewController : UIViewController

@property (nonatomic) NSString *showImageNsstring;
@property(nonatomic,retain)NSArray *imagesArray;
@property(nonatomic,assign)NSInteger currentImageIndex;
@property (retain, nonatomic)UIImageView *showImageView;
@end
