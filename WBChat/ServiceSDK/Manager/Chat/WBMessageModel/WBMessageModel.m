//
//  WBMessageModel.m
//  WBChat
//
//  Created by RedRain on 2018/1/26.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import "WBMessageModel.h"

@implementation WBMessageModel

+ (instancetype)createWithText:(NSString *)text{
    
    AVIMTextMessage *messageText = [AVIMTextMessage messageWithText:text attributes:nil];
    WBMessageModel *message = [WBMessageModel new];
    message.status = AVIMMessageStatusSending;
    message.content = messageText;
    return message;
}

+ (instancetype)createWIthTypedMessage:(AVIMTypedMessage *)message{
    WBMessageModel *messageModel = [WBMessageModel new];
    messageModel.status = message.status;
    messageModel.content = message;
    return messageModel;
}

@end
