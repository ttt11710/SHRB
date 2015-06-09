//
//  MODropAlertView.h
//  MODropAlertDemo
//
//  Created by Ahn JungMin on 2014. 7. 1..
//  Copyright (c) 2014년 minsOne. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DropAlertViewType) {
    DropAlertDefault,
    DropAlertCustom
};

typedef NS_ENUM(NSInteger, DropAlertButtonType) {
    DropAlertButtonOK,
    DropAlertButtonFail
};

typedef void (^blk)(void);

@class MODropAlertView;

@protocol MODropAlertViewDelegate;

@interface MODropAlertView : UIView

@property (nonatomic)UIView *movieView;

@property (nonatomic, weak) id<MODropAlertViewDelegate> delegate;

- (instancetype)initDropAlertWithmovieView:(UIView *)movieView;
- (void)show;
- (void)dismiss:(DropAlertButtonType)buttonType;

@end

@protocol MODropAlertViewDelegate <NSObject>

@optional
- (void)alertViewWillAppear:(MODropAlertView *)alertView;
- (void)alertViewDidAppear:(MODropAlertView *)alertView;
- (void)alertViewWilldisappear:(MODropAlertView *)alertView buttonType:(DropAlertButtonType)buttonType;
- (void)alertViewDidDisappear:(MODropAlertView *)alertView buttonType:(DropAlertButtonType)buttonType;
- (void)alertViewPressButton:(MODropAlertView *)alertView buttonType:(DropAlertButtonType)buttonType;

@end
