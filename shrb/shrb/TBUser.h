//
//  TBUser.h
//  shrb
//
//  Created by PayBay on 15/8/26.
//  Copyright © 2015年 PayBay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBUser : NSObject

+(instancetype) currentUser;

+ (void) setCurrentUser:(TBUser *)user;

+ (TBUser *)user;

@property (nonatomic, retain) NSString *userId;

@property (nonatomic, retain) NSString *userName;

@property (nonatomic, retain) NSString *imgUrl;

@property (nonatomic, retain) NSString *token;

@end
