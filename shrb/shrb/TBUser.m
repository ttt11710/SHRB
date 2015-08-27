//
//  TBUser.m
//  shrb
//
//  Created by PayBay on 15/8/26.
//  Copyright © 2015年 PayBay. All rights reserved.
//

#import "TBUser.h"

static TBUser *_currentUser;

@implementation TBUser {
    
}

+(instancetype)currentUser {
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
    if (userId.length == 0) {
        TBUser *user = [[TBUser alloc] init];
        user.userId = @"";
        user.userName = @"";
        user.imgUrl = @"";
        user.token = @"";
        
        _currentUser = user;
        
        return  _currentUser;
    }
    else {
        
        TBUser *user = [[TBUser alloc] init];
        user.userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
        user.userName = [[NSUserDefaults standardUserDefaults] stringForKey:@"userName"];
        user.imgUrl = [[NSUserDefaults standardUserDefaults] stringForKey:@"imgUrl"];
        user.token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
      
        _currentUser = user;
        
        return _currentUser;
    }
}

+(void)setCurrentUser:(TBUser *)user {
    
    if (user == nil) {
        user.userId = @"";
        user.userName = @"";
        user.imgUrl = @"";
        user.token = @"";
    }
    _currentUser = user;
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userId"];
    [[NSUserDefaults standardUserDefaults] setObject:user.userId forKey:@"userId"];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userName"];
    [[NSUserDefaults standardUserDefaults] setObject:user.userName forKey:@"userName"];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"imgUrl"];
    [[NSUserDefaults standardUserDefaults] setObject:user.imgUrl forKey:@"imgUrl"];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
    [[NSUserDefaults standardUserDefaults] setObject:user.token forKey:@"token"];
}

+(TBUser *)user {
    TBUser *newUser = [[TBUser alloc] init];
    return newUser;
}

@end
