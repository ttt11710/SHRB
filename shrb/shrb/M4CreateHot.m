//
//  CreateChannel.m
//  quan-iphone
//
//  Created by Wan Wei on 14-4-20.
//  Copyright (c) 2014年 Wan Wei. All rights reserved.
//

#import "Migrations.h"

@implementation M4CreateHot


//id: 1,
//artist_id: 1,
//customer_id: 11,
//last_message: "",
//last_send_at: "0000-00-00 00:00:00",
//status: 2,
//try_at: "0000-00-00 00:00:00",
//start_at: "0000-00-00 00:00:00",
//end_at: "0000-00-00 00:00:00",
//current_order_id: 1
- (void)up {
    [self createTable:@"store" withColumns:[NSArray arrayWithObjects:
                                            [FmdbMigrationColumn columnWithColumnName:@"storeId" columnType:@"integer"],
                                            [FmdbMigrationColumn columnWithColumnName:@"storePlistName" columnType:@"string"],
                                            [FmdbMigrationColumn columnWithColumnName:@"storeLabel" columnType:@"string"],
                                            [FmdbMigrationColumn columnWithColumnName:@"storeDetail" columnType:@"string"],
                                            [FmdbMigrationColumn columnWithColumnName:@"storeLogo" columnType:@"string"],
                                            [FmdbMigrationColumn columnWithColumnName:@"images" columnType:@"id"],
                                            [FmdbMigrationColumn columnWithColumnName:@"simpleStoreDetail" columnType:@"string"],
                                            [FmdbMigrationColumn columnWithColumnName:@"storeName" columnType:@"string"],
                                            nil]];
    
}

- (void)down {
    [self dropTable:@"store"];
}
@end
