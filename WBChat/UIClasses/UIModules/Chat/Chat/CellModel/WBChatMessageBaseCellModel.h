//
//  WBChatBaseCellModel.h
//  WBChat
//
//  Created by RedRain on 2018/1/18.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBChatCellConfig.h"
#import "WBServiceSDKHeaders.h"


typedef NS_ENUM(NSUInteger, WBChatCellType) {
    WBChatCellTypeUnknow,
    WBChatCellTypeTime,                      // 时间
    WBChatCellTypeNoMoreMessage,             // 没有更多消息了
    WBChatCellTypeUnderLineNewMessage,       // 以下是最新消息
    WBChatCellTypeText,
    WBChatCellTypeImage,
    WBChatCellTypeFile,
    WBChatCellTypeVoice,
    WBChatCellTypeLocation,
    WBChatCellTypeNotification,
    WBChatCellTypeVideo,
    WBChatCellTypeCallHint,
    WBChatCellTypeCardInfo, // 个人名片
    WBChatCellTypePSRichContent, // 公众号单图文
    WBChatCellTypePSMultiRichContent, // 公众号多图文
    WBChatCellTypeRichContent, // 单链接
    WBChatCellTypeRecallNotification // 回撤消息
};


@interface WBChatMessageBaseCellModel : NSObject

+ (instancetype)modelWithMessageModel:(AVIMTypedMessage *)messageModel;

@property (nonatomic, strong) AVIMTypedMessage *messageModel;

///< 消息类型
@property (nonatomic, assign) WBChatCellType cellType;

///< 对方头像的位置
@property (nonatomic, assign) CGRect headerRectFrame;

///< 自己头像的位置
@property (nonatomic, assign) CGRect myHeaderRectFrame;

///<  cell的高度
@property (nonatomic, assign) CGFloat cellHeight;

///< 发送的消息的状态位置
@property (nonatomic, assign) CGRect messageStatusRectFrame;

///< 会话界面消息阅读状态
@property (nonatomic, assign) CGRect messageReadStateRectFrame;

///< 对方昵称的位置
@property (nonatomic, assign) CGRect usernameRectFrame;


@property (nonatomic, assign) BOOL isDisplayMessageTime;

@property (nonatomic, assign) BOOL isDisplayNickname;

@end
