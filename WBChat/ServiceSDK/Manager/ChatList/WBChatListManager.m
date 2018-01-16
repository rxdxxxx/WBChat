//
//  WBChatListManager.m
//  WBChat
//
//  Created by RedRain on 2018/1/16.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import "WBChatListManager.h"


@implementation WBChatListManager
WB_SYNTHESIZE_SINGLETON_FOR_CLASS(WBChatListManager)


#pragma mark - 拉取服务器端的所有对话
- (void)fetchAllConversationsFromServer:(void(^_Nullable)(NSArray<AVIMConversation *> * _Nullable conersations,
                                                          NSError * _Nullable error))block {
    
    [self fetchConversationsWithCachePolicy:kAVIMCachePolicyNetworkOnly block:block];

}
- (void)fetchAllConversationsFromLocal:(void(^_Nullable)(NSArray<AVIMConversation *> * _Nullable conersations,
                                                          NSError * _Nullable error))block {
    
    [self fetchConversationsWithCachePolicy:kAVIMCachePolicyCacheOnly block:block];
}

- (void)fetchConversationsWithCachePolicy:(AVIMCachePolicy)chachePolicy block:(id)block{
    AVIMConversationQuery *orConversationQuery = [self.client conversationQuery];
    
    orConversationQuery.cachePolicy = chachePolicy;
    orConversationQuery.option = AVIMConversationQueryOptionWithMessage;
    [orConversationQuery findConversationsWithCallback:^(NSArray<AVIMConversation *> * _Nullable conversations, NSError * _Nullable error) {
        !block ?: ((AVIMArrayResultBlock)block)(conversations, error);
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

#pragma mark - Private Methods
- (AVIMClient *)client{
    return [WBChatKit sharedInstance].usingClient;
}
@end
