//
//  WBChatViewController.h
//  WBChat
//
//  Created by RedRain on 2018/1/16.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import "WBBaseController.h"
#import "WBServiceSDKHeaders.h"

@interface WBChatViewController : WBBaseController

+ (instancetype)createWithConversation:(AVIMConversation *)conversation;

@end
