//
//  MessageProcessor.m
//  quan-iphone
//
//  Created by Wan Wei on 14-4-25.
//  Copyright (c) 2014年 Wan Wei. All rights reserved.
//

#import "MessageProcessor.h"
#import "DB.h"

@implementation MessageProcessor {
    NSInteger _newMessagesCount;
}

- (id) init {
    self = [super init];
    if (self) {
        _newMessagesCount = 0;
    }
    
    return self;
}



- (BOOL)process:(Store *)store {
    DB *db = [DB openDb];
    
    [self updateStore:store inDB:db];
    
    [db close];
    
    return YES;
}


//- (void) saveMessage:(Message *)m inDB:(FMDatabase *)db {
//    // insert new message
//    NSString *sql = @"INSERT INTO messages (id, chat_id, sender_id, type, sub_type, mime_type, content, ass_object_id, ack, status, sent_at, created_at, updated_at) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)";
//    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
//    NSNumber *now = [NSNumber numberWithDouble: timeStamp];
//    BOOL rc = [db executeUpdate:sql, m.objectId, m.chatId,m.senderId,
//               @(m.type),
//               @(m.subType),m.mimeType,m.content,
//               m.assObjectId,@(m.ack),@(m.status),m.sentAt,now,now];
//    
//    if (!rc) {
//        NSLog(@"persistMessage error: %@", [db lastErrorMessage]);
//    }
//}


- (void)updateStore:(Store *)m inDB:(DB *)db {
    FMResultSet *s = [db executeQuery:@"SELECT COUNT(*) FROM store where storeId=?", m.storeId];
    if ([s next]) {
        int totalCount = [s intForColumnIndex:0];
        if (totalCount <= 0) {// insert chat
            BOOL rc = [db executeUpdate:@"INSERT INTO store (storeId,storePlistName , storeLabel , storeDetail , storeLogo ,images ,simpleStoreDetail ,storeName ) VALUES (?,?,?,?,?,?,?,?)",m.storeId,m.storePlistName, m.storeLabel, m.storeDetail, m.storeLogo,m.images,m.simpleStoreDetail,m.storeName];
            if (!rc) {
                NSLog(@"insert users error: %@", [db lastErrorMessage]);
            }
        }
    }
    BOOL rc = NO;
    
    rc = [db executeUpdate:@"UPDATE store set storePlistName = ?, storeLabel = ?, storeDetail = ?, storeLogo = ?,images = ?,simpleStoreDetail = ?,storeName = ?  where storeId=?",m.storePlistName, m.storeLabel, m.storeDetail, m.storeLogo,m.images,m.simpleStoreDetail,m.storeName,m.storeId];
}

//- (BOOL)insertChat:(NSString *)chatId Title:(NSString *)title Avatar:(NSString *)avatar InDB:(FMDatabase *)db {
//    if (title == nil || [title length]<=0) {
//        NSLog(@"chat title is null");
//        return NO;
//    }
//    
//    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
//    NSNumber *now = [NSNumber numberWithDouble: timeStamp];
//    
//    return [db executeUpdate:@"INSERT INTO chats (id, type, title, avatar, new_messages_count, \
//               last_message, last_sender_name, last_sent_at, \
//               created_at, updated_at) VALUES (?,?,?,?,?,'','',0, ?,?)",
//               chatId, @(1), title, avatar, @(1), now, now];
//}

//- (void)updateUserProfile:(Message *)m inDB:(FMDatabase *)db {
//    FMResultSet *s = [db executeQuery:@"SELECT COUNT(*) FROM users where id=?", m.senderId];
//    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
//    NSNumber *now = [NSNumber numberWithDouble: timeStamp];
//    
//    if ([s next]) {
//        int totalCount = [s intForColumnIndex:0];
//        if (totalCount <= 0) {// insert users
//            NSString *friendId = @"0";
//            NSString *chatId = @"0";
//            
//            BOOL rc = [db executeUpdate:@"INSERT INTO users (id, nickname, avatar, friend_id, chat_id, created_at, updated_at) VALUES (?,?,?,?,?,?,?)",m.senderId, m.senderName,m.senderAvatar,friendId,chatId, now, now];
//            if (!rc) {
//                NSLog(@"insert users error: %@", [db lastErrorMessage]);
//            }
//        }
//    }
//    
//    if (m.subType == MESSAGE_ST_UM_FIREND_CONFIRM) {
//        id content = [m parseJsonConent];
//        BOOL rc = [db executeUpdate:@"UPDATE users set friend_id=?, chat_id=? WHERE id=?", content[@"friend_id"], m.chatId, m.senderId];
//        if (!rc) {
//            NSLog(@"update users error: %@", [db lastErrorMessage]);
//        }
//    } else {
//        if (m.senderName==nil) {
//            m.senderName=@"";
//        }
//        if (m.senderAvatar==nil) {
//            m.senderAvatar=@"";
//        }
//        id dict = @{ @"id": m.senderId, @"nickname": m.senderName, @"avatar": m.senderAvatar};
//        BOOL rc = [db executeUpdate:@"UPDATE users set nickname = :nickname, avatar = :avatar where id = :id" withParameterDictionary:dict];
//        if (!rc) {
//            NSLog(@"update users error: %@", [db lastErrorMessage]);
//        }
//    }
//}
//
@end
