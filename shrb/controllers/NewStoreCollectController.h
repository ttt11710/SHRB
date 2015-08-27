//
//  NewStoreCollectController.h
//  shrb
//
//  Created by PayBay on 15/7/27.
//  Copyright © 2015年 PayBay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYBaseViewController.h"
#import "shrb-swift.h"

@interface NewStoreCollectController : PYBaseViewController <UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDataSource,UITableViewDelegate,CollectionViewWaterfallLayoutDelegate>

@property(nonatomic,assign)NSString * merchId;
@property(nonatomic,assign)NSString * merchTitle;


@end
