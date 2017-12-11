//
//  ChatManager.m
//  Chat-LC
//
//  Created by RedRain on 2017/12/7.
//  Copyright © 2017年 RedRain. All rights reserved.
//

#import "ChatManager.h"
#import "WBConfig.h"

@implementation ChatManager
+ (instancetype)sharedInstance {
    static ChatManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [ChatManager new];
    });
    
    return _sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        AVUser *user = [AVUser currentUser];
        
        // Tom 创建了一个 client，用自己的名字作为 clientId
        self.client = [[AVIMClient alloc] initWithClientId:user.objectId];
        
        // Tom 打开 client
        [self.client openWithCallback:^(BOOL succeeded, NSError *error) {
            // Tom 建立了与 Jerry 的会话
            WBLog(@"链接成功");
        }];
    }
    return self;
}

- (void)list:(AVIMArrayResultBlock)block{
    AVIMConversationQuery *query = [self.client conversationQuery];
    // 执行查询
    [query findConversationsWithCallback:block];
}

@end
