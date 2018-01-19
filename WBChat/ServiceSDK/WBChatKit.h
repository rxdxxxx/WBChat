//
//  WBChatKit.h
//  WBChat
//
//  Created by RedRain on 2018/1/15.
//  Copyright © 2018年 RedRain. All rights reserved.
//


#import <AVOSCloud/AVOSCloud.h>
#import <AVOSCloudIM/AVOSCloudIM.h>
#import "WBIMDefine.h"
@class WBChatListModel;

#define WBIMNotificationConnectivityUpdated @"WBIMNotificationConnectivityUpdated" ///< 连接状态变更的通知


void do_dispatch_async_mainQueue(dispatch_block_t _Nullable task);


NS_ASSUME_NONNULL_BEGIN

@interface WBChatKit : NSObject

/*!
 *  appId
 */
@property (nonatomic, copy, readonly) NSString *appId;

/*!
 *  appkey
 */
@property (nonatomic, copy, readonly) NSString *appKey;


/*!
 获取单例对象
 */
+ (instancetype)sharedInstance;

- (AVIMClient *)usingClient;

- (BOOL)connect;

- (AVIMClientStatus)connectStatus;

#pragma mark - 设置应用Id和Key

/*!
 设置appId 和 appKey 
 */
+ (void)setAppId:(NSString *)appId clientKey:(NSString *)appKey;

#pragma mark - 连接服务器
/**
 使用ClientId连接服务器
 
 @param clientId 用户IM身份的标识
 */
- (void)openWithClientId:(NSString *)clientId
                 success:(void (^)(NSString *clientId))successBlock
                   error:(void (^)(NSError *error))errorBlock;



/*!
 结束某个账户的聊天
 @param callback － 聊天关闭之后的回调
 */
- (void)closeWithCallback:(void (^)(BOOL succeeded, NSError *error))callback;

#pragma mark - 获取最近联系人列表
#pragma mark - 拉取本地的所有对话
/**
 拉取本地的所有对话
 */
- (void)fetchAllConversationsFromLocal:(void(^_Nullable)(NSArray<WBChatListModel *> * _Nullable conersations,
                                                         NSError * _Nullable error))block;



#pragma mark - 加载聊天记录
/**
 加载聊天记录
 
 @param conversation 对应的会话
 @param queryMessage 锚点message, 如果是nil:(该方法能确保在有网络时总是从服务端拉取最新的消息，首次拉取必须使用是nil或者sendTimestamp为0)
 @param limit 拉取的条数
 */
- (void)queryTypedMessagesWithConversation:(AVIMConversation *)conversation
                              queryMessage:(AVIMMessage * _Nullable)queryMessage
                                     limit:(NSInteger)limit
                                   success:(void (^)(NSArray<AVIMTypedMessage *> *messageArray))successBlock
                                     error:(void (^)(NSError *error))errorBlock;

#pragma mark - 创建一个Conversation

/**
 根据传入姓名和成员,获取到相应的Conversation对象
 
 @param name 会话的名称
 @param members 成员clientId的数组
 */
- (void)createConversationWithName:(NSString *)name
                           members:(NSArray *)members
                           success:(void (^)(AVIMConversation *convObj))successBlock
                             error:(void (^)(NSError *error))errorBlock;


#pragma mark - 往对话中发送消息。
/*!
 往对话中发送消息。
 @param message － 消息对象
 */
- (void)sendTargetConversation:(AVIMConversation *)targetConversation
                       message:(AVIMMessage *)message
                       success:(void (^)(void))successBlock
                         error:(void (^)(NSError *error))errorBlock;


@end

NS_ASSUME_NONNULL_END