//
//  WBIMClientDelegateImp.m
//  WBChat
//
//  Created by RedRain on 2018/1/15.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import "WBIMClientDelegateImp.h"
#import "WBIMDefine.h"
#import "WBManagerHeaders.h"
#import "WBServiceSDKHeaders.h"

@interface WBIMClientDelegateImp ()

@property (nonatomic, strong, readwrite) AVIMClient *client;
@property (nonatomic, copy, readwrite) NSString *clientId;
@property (nonatomic, assign, readwrite) BOOL connect;

@end

@interface WBIMClientDelegateImp (WB_IMDelegate)<AVIMClientDelegate>

@end

@implementation WBIMClientDelegateImp

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
#pragma mark - status

// 除了 sdk 的上面三个回调调用了，还在 open client 的时候调用了，好统一处理
- (void)updateConnectStatus {

    self.connect = _client.status == AVIMClientStatusOpened;
    [[NSNotificationCenter defaultCenter] postNotificationName:WBIMNotificationConnectivityUpdated object:@(self.connect)];
}

#pragma mark - Public Methods
- (void)openWithClientId:(NSString *)clientId success:(void (^)(NSString *clientId))successBlock error:(void (^)(NSError *error))errorBlock{
    
    [self openWithClientId:clientId force:YES success:successBlock error:errorBlock];
}

- (void)openWithClientId:(NSString *)clientId force:(BOOL)force success:(void (^)(NSString *clientId))successBlock error:(void (^)(NSError *error))errorBlock{
    
    self.clientId = clientId;
    
    // 1.开启一个此clientId的本地数据库
    [WBUserManager sharedInstance].clientId = clientId;
    [[WBUserManager sharedInstance] openDB];
    

    // 2.创建AVIMClient相关对象
    self.client = [[AVIMClient alloc] initWithClientId:clientId];
    self.client.delegate = self;
    
    // 3.开始连接服务器
    AVIMClientOpenOption *option = [AVIMClientOpenOption new];
    option.force = force;
    [self.client openWithOption:option callback:^(BOOL succeeded, NSError * _Nullable error) {
        
        [self updateConnectStatus];
        
        // 根据结果,调用不同的Block
        
        if (succeeded && successBlock) {
            successBlock(clientId.copy);
            
        }else if (errorBlock){
            errorBlock(error);
        }
        
    }];
}





@end



@implementation WBIMClientDelegateImp (WB_IMDelegate) // AVIMClientDelegate

// ↓↓↓↓↓↓↓↓↓↓↓↓↓ 网络状态变更 ↓↓↓↓↓↓↓↓↓↓↓↓
- (void)imClientPaused:(AVIMClient *)imClient {
    [self updateConnectStatus];
}

- (void)imClientResuming:(AVIMClient *)imClient {
    [self updateConnectStatus];
}

- (void)imClientResumed:(AVIMClient *)imClient {
    [self updateConnectStatus];
}
// ↑↑↑↑↑↑↑↑↑↑↑↑ 网络状态变更 ↑↑↑↑↑↑↑↑↑↑↑↑



/*!
 接收到新的普通消息。
 @param conversation － 所属对话
 @param message - 具体的消息
 */
- (void)conversation:(AVIMConversation *)conversation didReceiveCommonMessage:(AVIMMessage *)message{
    if (!message.wb_isValidMessage) {
        return;
    }
    AVIMTypedMessage *typedMessage = [message wb_getValidTypedMessage];
    [self conversation:conversation didReceiveTypedMessage:typedMessage];
}

/*!
 接收到新的富媒体消息。
 @param conversation － 所属对话
 @param message - 具体的消息
 */
- (void)conversation:(AVIMConversation *)conversation didReceiveTypedMessage:(AVIMTypedMessage *)message{
    if (!message.wb_isValidMessage) {
        return;
    }
    if (!message.messageId) {
        WBIMLog(@"🔴类名与方法名：%@（在第%@行），描述：%@", @(__PRETTY_FUNCTION__), @(__LINE__), @"Receive Message , but MessageId is nil");
        return;
    }
    
    
    
}



@end
