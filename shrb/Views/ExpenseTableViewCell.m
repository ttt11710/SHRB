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
    
    NSString *timeStamp2 = model.acceptTime;
    NSInteger date1 = [timeStamp2 integerValue];
    NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:date1/1000];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm  yyyy/MM/dd"];
    NSString *dateString = [dateFormatter stringFromDate:date2];
    
    self.dateLabel.text = dateString;
    self.expenseTextView.text = [NSString stringWithFormat:@"金额:%.2f元\n订单:%@  暂时无法获取\n商铺名称:%@\n地址:%@",model.payAmount ,model.orderID,model.merchName, model.address];
}

- (void)awakeFromNib {
    // Initialization code
    
    self.expenseTextView.font = [UIFont systemFontOfSize:16.0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
