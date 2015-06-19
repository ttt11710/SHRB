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

@property (weak, nonatomic) IBOutlet UITextView *expenseTextView;

@end

@implementation ExpenseTableViewCell

- (void)setModel:(CardModel *)model
{
    self.expenseTextView.text = [NSString stringWithFormat:@"消费记录:%@\n\n订单号：%@\n价格：%@元\n",model.expenseNum,model.orderNum,model.expensePrice];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
