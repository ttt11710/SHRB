//
//  ButtonTableViewCell.m
//  shrb
//
//  Created by PayBay on 15/5/20.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "ButtonTableViewCell.h"
#import "Const.h"
#import "BecomeMemberView.h"
#import <POP/POP.h>
#import "TBUser.h"
#import "SVProgressShow.h"
#import "OrdersViewController.h"


@interface ButtonTableViewCell () {
    
    BecomeMemberView *_becomeMemberView;
    UIButton *_smallbuttonModel;
    CGRect _bounds;
}

@property (nonatomic,strong)AFHTTPRequestOperationManager *requestOperationManager;

@end
@implementation ButtonTableViewCell

@synthesize prodId;
@synthesize merchId;

- (void)awakeFromNib {
        
    self.buttonModel.backgroundColor = shrbPink;
    [self.buttonModel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.buttonModel.layer.cornerRadius = 4;
    self.buttonModel.layer.masksToBounds = YES;
    [self.buttonModel addTarget:self action:@selector(buttonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)creatReq
{
    self.requestOperationManager=[AFHTTPRequestOperationManager manager];
    
    self.requestOperationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    AFJSONResponseSerializer *serializer=[AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    self.requestOperationManager.responseSerializer=serializer;
    
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setTimeoutInterval:10*60];
    self.requestOperationManager.requestSerializer=requestSerializer;
}


- (void)buttonWasPressed:(id)sender
{
    [self creatReq];
    
    if ([TBUser currentUser].token.length == 0) {
        
        [SVProgressShow showInfoWithStatus:@"请先登录账号!"];
        return ;
    }
    
    [SVProgressShow showWithStatus:@"申请中..."];
    
    NSString *url2=[baseUrl stringByAppendingString:@"/card/v1.0/applyCard?"];
    [self.requestOperationManager POST:url2 parameters:@{@"userId":[TBUser currentUser].userId,@"token":[TBUser currentUser].token,@"merchId":self.merchId} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"applyCard operation = %@ JSON: %@", operation,responseObject);
        
        switch ([responseObject[@"code"] integerValue]) {
            case 200: {
                [SVProgressShow showSuccessWithStatus:@"会员卡申请成功"];
                
                NSString *url=[baseUrl stringByAppendingString:@"/product/v1.0/getProduct?"];
                [self.requestOperationManager GET:url parameters:@{@"prodId":self.prodId,@"token":[TBUser currentUser].token} success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSLog(@"getProduct operation = %@ JSON: %@", operation,responseObject);
                    
                    [[OrdersViewController shareOrdersViewController] UpdateTableView];
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"error:++++%@",error.localizedDescription);
                }];

            }
                break;
            case 201:
            case 500:
                [SVProgressShow showErrorWithStatus:responseObject[@"mes"]];
                break;
                
            default:
                break;
        }

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:++++%@",error.localizedDescription);
    }];

}


- (void)sureBtnPressed
{
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        _smallbuttonModel.layer.transform = CATransform3DIdentity;
        
        _becomeMemberView.layer.transform = CATransform3DIdentity;
        
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            _smallbuttonModel.hidden = YES;
            self.buttonModel.hidden = NO;
        
            self.buttonModel.bounds = _bounds;
            
        } completion:^(BOOL finished) {
            
            [[BecomeMemberView shareBecomeMemberView] textFieldResignFirstResponder];
            
            POPSpringAnimation *sizeAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
            sizeAnimation.springSpeed = 0.f;
            sizeAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, _smallbuttonModel.frame.size.width-5, _smallbuttonModel.frame.size.height-5)];
            [_smallbuttonModel pop_addAnimation:sizeAnimation forKey:nil];
            
        }];
        
    }];
 
}



@end
