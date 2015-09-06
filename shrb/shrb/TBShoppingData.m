//
//  TBShoppingData.m
//  shrb
//
//  Created by PayBay on 15/9/1.
//  Copyright © 2015年 PayBay. All rights reserved.
//

#import "TBShoppingData.h"
#import "ShoppingCardDataItem.h"

static TBShoppingData *_currentShoppingData;

@interface TBShoppingData ()
{
     NSTimer *_timer;
}

@end

@implementation TBShoppingData

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.shoppingArray = [[NSMutableArray alloc] init];
        _currentShoppingData.shoppingArray = [[NSMutableArray alloc] init];
    }
    
    return self;
}

+ (instancetype)currentShoppingData
{
    
    NSInteger num = [[NSUserDefaults standardUserDefaults] integerForKey:@"shoppingNum"];
    
    TBShoppingData *currentShoppingData = [[TBShoppingData alloc] init];
    if (num == 0) {
    
        currentShoppingData.num = 0;
        currentShoppingData.shoppingArray = nil;
        currentShoppingData.countTime = 1200;
        
    }
    else {
        
        currentShoppingData.num = [[NSUserDefaults standardUserDefaults] integerForKey:@"shoppingNum"];
        currentShoppingData.shoppingArray = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"shoppingArray"] mutableCopy];
        currentShoppingData.countTime = [[NSUserDefaults standardUserDefaults] integerForKey:@"shoppingCountTime"];
    }
    
    _currentShoppingData = currentShoppingData;
    return _currentShoppingData;
}

+ (void)setCurrentShoppingData:(TBShoppingData *)shoppingData
{
    
    if (shoppingData == nil) {
        shoppingData.num = 0;
        shoppingData.shoppingArray = nil;
        shoppingData.countTime = 1200;
    }
    _currentShoppingData = shoppingData;
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"shoppingNum"];
    [[NSUserDefaults standardUserDefaults] setInteger:shoppingData.num forKey:@"shoppingNum"];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"shoppingArray"];
    [[NSUserDefaults standardUserDefaults] setObject:shoppingData.shoppingArray forKey:@"shoppingArray"];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"shoppingCountTime"];
    [[NSUserDefaults standardUserDefaults] setInteger:shoppingData.countTime forKey:@"shoppingCountTime"];

}


- (void)countDown
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
}

- (void)timerFireMethod:(NSTimer *)timer
{
    _currentShoppingData.countTime -- ;
    
    if (_currentShoppingData.countTime == 0 || _currentShoppingData.num == 0) {
        _currentShoppingData.countTime = 1200;
        [_timer invalidate];
    }
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"shoppingCountTime"];
    [[NSUserDefaults standardUserDefaults] setInteger:_currentShoppingData.countTime forKey:@"shoppingCountTime"];
    
}

@end
