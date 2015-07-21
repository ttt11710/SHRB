//
//  HotDetailTableViewCell.m
//  shrb
//
//  Created by PayBay on 15/5/19.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "HotDetailTableViewCell.h"
#import "HotFocusModel.h"
#import "ParagraphAttributes+Constructor.h"
#import "ExclusionView.h"
#import "BookTextView.h"
#import "Const.h"

@interface HotDetailTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *hotImageView;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet BookTextView *detailTextView;

@end

@implementation HotDetailTableViewCell

- (void)setModel:(HotFocusModel *)model
{
    self.hotImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",model.storeLogo]];
    
    self.detailLabel.text = model.storeDetail;
    
    
    // 读取文本
    NSString *text = model.storeDetail;
    
    self.detailTextView.textString          = text;
    
    // 设置段落样式
    self.detailTextView.paragraphAttributes = [ParagraphAttributes qingKeBengYue];
    
    // 设置富文本
    self.detailTextView.attributes          = @[[ConfigAttributedString foregroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.75f]
                                                                            range:NSMakeRange(0, 9)],
                                          [ConfigAttributedString font:[UIFont systemFontOfSize:15.f]
                                                                 range:NSMakeRange(0, 9)]];
    
    // 加载图片
    ExclusionView *exclusionView1 = [[ExclusionView alloc] initWithFrame:CGRectMake((screenWidth-300)/2, 100, 280, 150)];
    ExclusionView *exclusionView2 = [[ExclusionView alloc] initWithFrame:CGRectMake(0, 400, 280, 150)];
    self.detailTextView.exclusionViews = @[exclusionView1,exclusionView2];
    UIImageView *imageView1       = [[UIImageView alloc] initWithFrame:exclusionView1.bounds];
    imageView1.image              = [UIImage imageNamed:@"16N"];
    UIImageView *imageView2       = [[UIImageView alloc] initWithFrame:exclusionView1.bounds];
    imageView2.image              = [UIImage imageNamed:@"16N1"];
    [exclusionView1 addSubview:imageView1];
    [exclusionView2 addSubview:imageView2];
    
    
    // 构建view
    [self.detailTextView buildWidgetView];

    
}

- (void)awakeFromNib {
    
    self.hotImageView.layer.cornerRadius = 4;
    self.hotImageView.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
