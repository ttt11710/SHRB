//
//  ChanrgeTypeTableViewCell.m
//  shrb
//
//  Created by PayBay on 15/8/28.
//  Copyright © 2015年 PayBay. All rights reserved.
//

#import "ChanrgeTypeTableViewCell.h"

@implementation ChanrgeTypeTableViewCell

- (void)awakeFromNib {
    
    [self.chanrgeTypBtn setImage:[UIImage imageNamed:@"payUncheck"] forState:UIControlStateNormal];
    [self.chanrgeTypBtn setImage:[UIImage imageNamed:@"paycheck"] forState:UIControlStateSelected];
}
- (IBAction)chanrgeTypBtnPressed:(id)sender {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
