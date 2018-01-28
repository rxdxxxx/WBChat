//
//  WBMessageModel.h
//  WBChat
//
//  Created by RedRain on 2018/1/26.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>
#import <AVOSCloudIM/AVOSCloudIM.h>

@interface WBMessageModel : NSObject
/*!
 * 表示消息状态
 */
@property (nonatomic, assign) AVIMMessageStatus status;


@property (nonatomic, strong) AVIMTypedMessage *content;


+ (instancetype)createWithText:(NSString *)text;

+ (instancetype)createWIthTypedMessage:(AVIMTypedMessage *)message;

@end
