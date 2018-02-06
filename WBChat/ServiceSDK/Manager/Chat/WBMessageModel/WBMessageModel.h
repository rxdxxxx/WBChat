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


+ (instancetype)createWIthTypedMessage:(AVIMTypedMessage *)message;



/**
 发送消息时,创建模型

 @param text 发送内容
 */
+ (instancetype)createWithText:(NSString *)text;



/**
 生成适配的发送model

 @param image 需要发送的image
 */
+ (instancetype)createWithImage:(UIImage *)image;

@property (nonatomic, strong) UIImage *thumbImage;
@property (nonatomic, copy) NSString *imagePath;


/**
 生成音频model

 @param audioPath 音频路径
 */
+ (instancetype)createWithAudioPath:(NSString *)audioPath duration:(NSNumber *)duration;
@property (nonatomic, copy) NSString *audioPath;
@property (nonatomic, copy) NSString *voiceDuration;

@end
