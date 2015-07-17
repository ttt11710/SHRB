//
//  CardTableViewCell.m
//  shrb
//
//  Created by PayBay on 15/5/20.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "CardTableViewCell.h"
#import "CardModel.h"
#import "Const.h"

@interface CardTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *shadowView;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIImageView *memberCardImageView;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *integralLabel;

@end
@implementation CardTableViewCell

- (void)setModel:(CardModel *)model
{
    self.memberCardImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",model.memberCardImage]];
    self.moneyLabel.text = [NSString stringWithFormat:@"金额：%@元",model.money];
    self.cardNumberLabel.text = [NSString stringWithFormat:@"卡号：%@",model.cardNumber];
    self.integralLabel.text =[NSString stringWithFormat:@"积分：%@分",model.integral];
    self.backImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",model.backCardImage]];
    
    [self snowAniWithImageName:model.emitterCellImage andEmitterPositionX:model.emitterPositionX andXAcceleration:model.xAcceleration andYAcceleration:model.yAcceleration andSpinRange:model.spinRange];
}

- (void)awakeFromNib {
    // Initialization code
    
    
    self.shadowView.layer.cornerRadius = 10;
    self.shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.shadowView.layer.shadowOffset = CGSizeMake(2,2);
    self.shadowView.layer.shadowOpacity = 0.5;
    self.shadowView.layer.shadowRadius = 2.0;
    
    self.backImageView.layer.cornerRadius = 10;
    self.backImageView.layer.masksToBounds = YES;
    
    self.memberCardImageView.layer.cornerRadius = 10;
    self.memberCardImageView.layer.masksToBounds = YES;
    
    
}


- (void)snowAniWithImageName:(NSString *)imageString
         andEmitterPositionX:(CGFloat)x
            andXAcceleration:(CGFloat)xAcceleration
            andYAcceleration:(CGFloat)yAcceleration
                andSpinRange:(CGFloat)spinRange
{
    CAEmitterLayer *snowEmitter = [CAEmitterLayer layer];
    snowEmitter.emitterPosition = CGPointMake(x, -30.0); //发射位置
    snowEmitter.emitterSize		= CGSizeMake(screenWidth * 2.0, 0.0); //发射源尺寸
    
    // Spawn points for the flakes are within on the outline of the line
    snowEmitter.emitterMode		= kCAEmitterLayerVolume; //发射模式 kCAEmitterLayerOutline
    snowEmitter.emitterShape	= kCAEmitterLayerCuboid; //发射源形状 kCAEmitterLayerLine
    
    // Configure the snowflake emitter cell
    CAEmitterCell *snowflake = [CAEmitterCell emitterCell];
    
    snowflake.birthRate		= 1.0; //粒子参数的速度乘数因子
    snowflake.lifetime		= 120.0; //生命周期
    
    snowflake.velocity		= -10;				// falling down slowly 速度
    snowflake.velocityRange = 10;               //速度范围
    snowflake.xAcceleration = xAcceleration;
    snowflake.yAcceleration = yAcceleration;    //粒子y方向的加速度分量
    snowflake.emissionRange = 0.5 * M_PI;		// some variation in angle 周围发射角度
    snowflake.spinRange		= spinRange * M_PI;		// slow spin 子旋转角度范围
    
    snowflake.contents		= (id) [[UIImage imageNamed:imageString] CGImage];
    snowflake.color			= [[UIColor whiteColor] CGColor];
    //[[UIColor colorWithRed:0.600 green:0.658 blue:0.743 alpha:1.000] CGColor];
    
    // Make the flakes seem inset in the background
    snowEmitter.shadowOpacity = 1.0;
    snowEmitter.shadowRadius  = 0.0;
    snowEmitter.shadowOffset  = CGSizeMake(0.0, 1.0);
    snowEmitter.shadowColor   = [[UIColor whiteColor] CGColor];
    
    // Add everything to our backing layer below the UIContol defined in the storyboard
    snowEmitter.emitterCells = [NSArray arrayWithObject:snowflake];
    
    for (id layer in self.backImageView.layer.sublayers) {
        [layer removeFromSuperlayer];
    }
    [self.backImageView.layer addSublayer:snowEmitter];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
