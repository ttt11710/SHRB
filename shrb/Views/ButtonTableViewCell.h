//
//  ButtonTableViewCell.h
//  shrb
//
//  Created by PayBay on 15/5/20.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BFPaperButton.h"
#import "UIColor+BFPaperColors.h"

@interface ButtonTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet BFPaperButton *buttonModel;
@end
