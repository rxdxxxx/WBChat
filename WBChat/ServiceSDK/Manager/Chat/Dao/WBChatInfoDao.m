//
//  WBChatInfoDao.m
//  WBChat
//
//  Created by RedRain on 2018/1/18.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import "WBChatInfoDao.h"


@implementation WBChatInfoDao
WB_SYNTHESIZE_SINGLETON_FOR_CLASS(WBChatInfoDao)

- (BOOL)createDBTable{
    __block BOOL ret = NO;
    NSString *sql =@"CREATE TABLE IF NOT EXISTS t_ChatInfo(\
    conversationID          VARCHAR(63) PRIMARY KEY,\
    topTime                 INTEGER DEFAULT 0,\
    conversationBGFileID    Text,\
    draft                   Text\
    extend                  Text\
    );";
    
    [[WBDBClient sharedInstance].dbQueue inDatabase:^(FMDatabase *db) {
        ret = [db executeUpdate:sql];
    }];
    return ret;
}


/**
 根据conversationId,删除一个本地的会话
 */
- (BOOL)deleteConversation:(NSString *)conversationId{
    __block BOOL isExist=NO;
    
    [[WBDBClient sharedInstance].dbQueue inDatabase:^(FMDatabase *db) {
        
        NSString *selectSQl =@"DELETE FROM t_ChatInfo where conversationID = ?;";
        FMResultSet *set = [db executeQuery:selectSQl withArgumentsInArray:@[conversationId]];
        if ([set next]) {
            isExist=YES;
        }
        [set close];
        
    }];
    return isExist;
    
}
@end
