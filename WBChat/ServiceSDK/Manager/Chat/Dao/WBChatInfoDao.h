//
//  WBChatInfoDao.h
//  WBChat
//
//  Created by RedRain on 2018/1/18.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBCoreConfiguration.h"

#define WBChatInfoDaoTableName @"t_ChatInfo"
#define WBChatInfoDaoKeyDraft @"draft"
#define WBChatInfoDaoKeyTopTime @"topTime"
#define WBChatInfoDaoKeyId @"conversationID"

@interface WBChatInfoDao : NSObject
WB_SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(WBChatInfoDao)

- (BOOL)createDBTable;

@end
