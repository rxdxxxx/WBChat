//
//  WBChatListManager.m
//  WBChat
//
//  Created by RedRain on 2018/1/16.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import "WBChatListManager.h"
#import "WBChatListDao.h"
#import "WBChatInfoDao.h"

@implementation WBChatListManager
WB_SYNTHESIZE_SINGLETON_FOR_CLASS(WBChatListManager)

- (BOOL)createDBTable{
    return [[WBChatListDao sharedInstance] createDBTable];
}

#pragma mark - 拉取服务器端的所有对话
- (void)fetchAllConversationsFromServer:(void(^_Nullable)(NSArray<WBChatListModel *> * _Nullable conersations,
                                                          NSError * _Nullable error))block {
    
    [self fetchConversationsWithCachePolicy:kAVIMCachePolicyIgnoreCache block:block];

}
- (void)fetchAllConversationsFromLocal:(void(^_Nullable)(NSArray<WBChatListModel *> * _Nullable conersations,
                                                          NSError * _Nullable error))block {
    
    
    [[WBChatListDao sharedInstance] loadChatListWithClient:self.client
                                                    result:^(NSArray<WBChatListModel *> * _Nonnull modelArray)
    {
        block(modelArray,nil);
    }];
}

- (void)fetchConversationsWithCachePolicy:(AVIMCachePolicy)chachePolicy block:(id)block{
    AVIMConversationQuery *orConversationQuery = [self.client conversationQuery];
    
    orConversationQuery.cachePolicy = chachePolicy;
    orConversationQuery.option = AVIMConversationQueryOptionWithMessage;
    [orConversationQuery findConversationsWithCallback:^(NSArray<AVIMConversation *> * _Nullable conversations, NSError * _Nullable error) {
        NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:conversations.count];
        
        [self fetchAllConversationsFromLocal:^(NSArray<WBChatListModel *> * _Nullable conersations, NSError * _Nullable error) {
            
            // 1.读取数据库中已经有的信息
            NSMutableDictionary *mDic = [NSMutableDictionary new];
            // 2.保存成字典,方便查询
            for (WBChatListModel *listModel in conersations) {
                mDic[listModel.conversationID] = listModel;
            }
            
            
            for (AVIMConversation *conver in conversations) {
                WBChatListModel *listModel = [WBChatListModel createWithConversation:conver];
                
                WBChatListModel *dbModel = mDic[conver.conversationId];
                if (dbModel) {
                    // 3.从服务器获取的信息, 使用本地的未读消息数量
                    listModel.unreadCount = [dbModel unreadCount];
                }
                
                [tempArray addObject:listModel];
            }
            
            // 存储到本地
            [[WBChatListDao sharedInstance] insertChatListModelArray:tempArray];
            
            !block ?: ((AVIMArrayResultBlock)block)(tempArray, error);
        }];
        
        
    }];
}

#pragma mark - 根据 conversationId 获取对话
/**
 *  根据 conversationId 获取对话
 *  @param conversationId   对话的 id
 */
- (void)fetchConversationWithConversationId:(NSString *)conversationId callback:(void (^)(AVIMConversation *conversation, NSError *error))callback {
    NSAssert(conversationId.length > 0, @"Conversation id is nil");
    AVIMConversation *conversation = [self.client conversationForId:conversationId];
    if (conversation) {
        !callback ?: callback(conversation, nil);
        return;
    }
    
    NSSet *conversationSet = [NSSet setWithObject:conversationId];
    [self fetchConversationsWithConversationIds:conversationSet callback:^(NSArray *objects, NSError *error) {
        if (error) {
            !callback ?: callback(nil, error);
        } else {
            if (objects.count == 0) {
                NSString *errorReasonText = [NSString stringWithFormat:@"conversation of %@ are not exists", conversationId];
                NSInteger code = 0;
                NSDictionary *errorInfo = @{
                                            @"code" : @(code),
                                            NSLocalizedDescriptionKey : errorReasonText,
                                            };
                NSError *error = [NSError errorWithDomain:WBIMConversationFindErrorDomain
                                                     code:code
                                                 userInfo:errorInfo];
                !callback ?: callback(nil, error);
            } else {
                !callback ?: callback(objects[0], error);
            }
        }
    }];
}

#pragma mark - 根据 conversationId集合 获取对话
/**
 *  根据 conversationId数组 获取多个指定的会话信息
 */
- (void)fetchConversationsWithConversationIds:(NSSet *)conversationIds
                                     callback:(void (^_Nullable)(NSArray<AVIMConversation *> * _Nullable conersations,
                                                                 NSError * _Nullable error))callback {
    AVIMConversationQuery *query = [self.client conversationQuery];
    [query whereKey:@"objectId" containedIn:[conversationIds allObjects]];
    query.limit = conversationIds.count;
    query.option = AVIMConversationQueryOptionWithMessage;
    query.cacheMaxAge = kAVIMCachePolicyIgnoreCache;
    [query findConversationsWithCallback: ^(NSArray *objects, NSError *error) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
            [objects makeObjectsPerformSelector:@selector(lastMessage)];
            dispatch_async(dispatch_get_main_queue(),^{
                !callback ?: callback(objects, error);
            });
        });
    }];
}
#pragma mark - 更新最近一条消息记录到List
- (void)insertConversationToList:(AVIMConversation *)conversation{
    if (conversation == nil) {
        return;
    }
    
    // 把最新的信息保存到库中
    WBChatListModel *listModel = [WBChatListModel createWithConversation:conversation];
    
    [[WBChatListDao sharedInstance] insertChatListModel:listModel];
}

/**
 根据conversationId, 判断本地有没有对应的会话信息
 
 @param conversationId conversationId
 @return 是否已经存在
 */
- (BOOL)isExistWithConversationId:(NSString *)conversationId{
    return [[WBChatListDao sharedInstance] isExistWithConversationId:conversationId];
}


#pragma mark - 删除一个会话
- (void)deleteConversation:(NSString *)conversationId{
    
    WBChatListModel *listModel = [[WBChatListDao sharedInstance] chatListModelWithConversationId:conversationId client:self.client];
    if (listModel) {
        // 清除之前的未读数, 以及聊天记录
        [listModel.conversation readInBackground];
    }
    
    // 列表
    [[WBChatListDao sharedInstance] deleteConversation:conversationId];
}

#pragma mark - 改变某个会话的会话状态
/**
 阅读了某个会话
 
 @param conversation 被阅读的会话
 */
- (void)readConversation:(AVIMConversation *)conversation{
    // 设置某个会话为已读
    [conversation readInBackground];
    
    // 更新本地数据库
    [self insertConversationToList:conversation];
}

#pragma mark - Private Methods
- (AVIMClient *)client{
    return [WBChatKit sharedInstance].usingClient;
}
@end
