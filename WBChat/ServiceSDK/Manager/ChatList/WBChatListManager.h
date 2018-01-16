//
//  WBChatListManager.h
//  WBChat
//
//  Created by RedRain on 2018/1/16.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBServiceSDKHeaders.h"
NS_ASSUME_NONNULL_BEGIN
@interface WBChatListManager : NSObject

WB_SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(WBChatListManager)

#pragma mark - 拉取服务器端的所有对话  
/**
 拉取服务器端的所有对话
 */
- (void)fetchAllConversationsFromServer:(void(^_Nullable)(NSArray<AVIMConversation *> * _Nullable conersations,
                                                          NSError * _Nullable error))block;
#pragma mark - 拉取本地的所有对话

/**
 拉取服务器端的所有对话
 */
- (void)fetchAllConversationsFromLocal:(void(^_Nullable)(NSArray<AVIMConversation *> * _Nullable conersations,
                                                         NSError * _Nullable error))block;
#pragma mark - 根据 conversationId 获取对话
/**
 *  根据 conversationId 获取对话
 *  @param conversationId   对话的 id
 */
- (void)fetchConversationWithConversationId:(NSString *)conversationId
                                   callback:(void (^_Nullable)(AVIMConversation * _Nullable conversation,
                                                               NSError * _Nullable error))callback;
#pragma mark - 根据 conversationId集合 获取对话
/**
 *  根据 conversationId数组 获取多个指定的会话信息
 */
- (void)fetchConversationsWithConversationIds:(NSSet *)conversationIds
                                     callback:(void (^_Nullable)(NSArray<AVIMConversation *> * _Nullable conersations,
                                                                 NSError * _Nullable error))callback;
@end
NS_ASSUME_NONNULL_END
