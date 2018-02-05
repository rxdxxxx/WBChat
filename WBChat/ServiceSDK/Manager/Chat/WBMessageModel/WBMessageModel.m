//
//  WBMessageModel.m
//  WBChat
//
//  Created by RedRain on 2018/1/26.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import "WBMessageModel.h"
#import "WBNamedTool.h"
#import "WBPathManager.h"
#import "WBFileManager.h"
#import "UIImage+WBScaleExtension.h"


#define kMessageThumbImageKey @"thumbImg"


@implementation WBMessageModel


+ (instancetype)createWIthTypedMessage:(AVIMTypedMessage *)message{
    WBMessageModel *messageModel = [WBMessageModel new];
    messageModel.status = message.status;
    messageModel.content = message;
    
//    kAVIMMessageMediaTypeNone = 0,
//    kAVIMMessageMediaTypeText = -1,
//    kAVIMMessageMediaTypeImage = -2,
//    kAVIMMessageMediaTypeAudio = -3,
//    kAVIMMessageMediaTypeVideo = -4,
//    kAVIMMessageMediaTypeLocation = -5,
//    kAVIMMessageMediaTypeFile = -6,
//    kAVIMMessageMediaTypeRecalled = -127
    
    switch (message.mediaType) {
        case kAVIMMessageMediaTypeImage:{
            NSDictionary *info = message.attributes;
            NSString *encodedImgString = info[kMessageThumbImageKey];
            messageModel.thumbImage = [UIImage imageWithData:[[NSData alloc] initWithBase64EncodedString:encodedImgString options:0]];
        }
            break;
            
        default:
            break;
    }
    return messageModel;
}


+ (instancetype)createWithText:(NSString *)text{
    
    AVIMTextMessage *messageText = [AVIMTextMessage messageWithText:text attributes:nil];
    WBMessageModel *message = [WBMessageModel new];
    message.status = AVIMMessageStatusSending;
    message.content = messageText;
    return message;
}

+ (instancetype)createWithImage:(UIImage *)image{
    // 1.得到路径
    
    
    // 2.处理图片,让体积小一些, 节省流量
    NSString *imageName = [WBNamedTool namedWithType:(WBResNamedTypeImage)];
    NSString *imageFilePath = [[WBPathManager imagePath] stringByAppendingPathComponent:imageName];
    UIImage *normalImage = [image wb_imageByScalingAspectFill];
    NSData *normalData = UIImageJPEGRepresentation(normalImage, 1);
    [WBFileManager saveImageData:normalData toImagePath:imageFilePath];
    
    // 3.压缩图
    NSString *imageThumbName = [WBNamedTool namedWithType:(WBResNamedTypeImageThumb)];
    NSString *imageThumbFilePath = [[WBPathManager imagePath] stringByAppendingPathComponent:imageThumbName];
    NSData *thumbData = [normalImage wb_compressWithMaxKBytes:3];
    [WBFileManager saveImageData:thumbData toImagePath:imageThumbFilePath];
    
    
    WBMessageModel *messageModel = [WBMessageModel new];
    messageModel.status = AVIMMessageStatusSending;
    messageModel.thumbImage = [UIImage imageWithData:thumbData];
    
    AVIMImageMessage *imgMsg = [AVIMImageMessage messageWithText:nil
                                                attachedFilePath:imageFilePath
                                                      attributes:@{kMessageThumbImageKey:[thumbData base64EncodedStringWithOptions:0]}];
    messageModel.content = imgMsg;
    
    return messageModel;

}

@end
