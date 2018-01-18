//
//  WBChatListDao.h
//  WBChat
//
//  Created by RedRain on 2018/1/17.
//  Copyright © 2018年 RedRain. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "WBCoreConfiguration.h"
#import "WBChatListModel.h"

NS_ASSUME_NONNULL_BEGIN

//  此张表记录的数据, 均是AVOS提供的数据,
//  客户端产生的行为数据如: 草稿,置顶等信息存放在 WBChatInfoDao 中
@interface WBChatListDao : NSObject
WB_SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(WBChatListDao)

- (BOOL)createDBTable;

- (BOOL)insertChatListModel:(WBChatListModel *)chatListModel;
- (BOOL)insertChatListModelArray:(NSArray<WBChatListModel *> * )chatListModelArray;
- (void)loadChatListWithClient:(AVIMClient *)client result:(void (^)(NSArray<WBChatListModel *> *modelArray))resultBlock;

@end
NS_ASSUME_NONNULL_END
