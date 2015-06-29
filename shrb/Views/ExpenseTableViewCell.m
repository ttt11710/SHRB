//
//  ExpenseTableViewCell.m
//  shrb
//
//  Created by PayBay on 15/5/21.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "ExpenseTableViewCell.h"
#import "CardModel.h"

@interface ExpenseTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITextView *expenseTextView;

@end

@implementation ExpenseTableViewCell

- (void)setModel:(CardModel *)model
{
    self.dateLabel.text = model.date;
    self.expenseTextView.text = [NSString stringWithFormat:@"金额:%@元\n订单：%@\n地址：%@",model.money,model.orderNum,model.address];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
