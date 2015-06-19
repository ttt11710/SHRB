//
//  HotDetailTableViewCell.m
//  shrb
//
//  Created by PayBay on 15/5/19.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "HotDetailTableViewCell.h"
#import "HotFocusModel.h"

@interface HotDetailTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *hotImageView;
@property (weak, nonatomic) IBOutlet LazyFadeInView *detailView;

@end

@implementation HotDetailTableViewCell

- (void)setModel:(HotFocusModel *)model
{
    self.hotImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",model.storeName]];
    self.detailView.text = model.storeDetail;
}

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
