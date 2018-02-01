//
//  WBChatBarConst.h
//  WBChat
//
//  Created by RedRain on 2018/2/1.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#ifndef WBChatBarConst_h
#define WBChatBarConst_h

typedef NS_ENUM(NSUInteger, WBPlusBoardButtonType) {
    WBPlusBoardButtonTypePhotoAlbum = 0,    // 相册
    WBPlusBoardButtonTypeCamera,        // 相机
    WBPlusBoardButtonTypeVideo,         // 视频聊天
    WBPlusBoardButtonTypeAudio,         // 音频聊天
    WBPlusBoardButtonTypeFile,          // 文件按钮
    WBPlusBoardButtonTypeVideoFile,     // 小视频
    WBPlusBoardButtonTypeLocation,      // 位置
    WBPlusBoardButtonTypeNameCard       // 名片
};

typedef NS_ENUM(NSInteger, WBChatBarStatus) {
    WBChatBarStatusInit,
    WBChatBarStatusVoice,
    WBChatBarStatusEmoji,
    WBChatBarStatusMore,
    WBChatBarStatusKeyboard,
};

#define kPlusBoardIcon @"icon"
#define kPlusBoardTitle @"title"
#define kPlusBoardType @"type"

#define PlusBoardItemDicInfo(A,B,C) @{kPlusBoardIcon:A,kPlusBoardTitle:B,kPlusBoardType:C}

@class WBChatBarView;
/**************************************************************************
 *  加号按钮弹出的键盘的代理方法.
 ************************************************************************
 */
@protocol WBChatBarViewDelegate <NSObject>

- (void)chatBar:(WBChatBarView *)keyBoardView sendText:(NSString *)sendText;


/**
 点击plusBoard后, 返回对应的数据
 
 @param iteminfo 点击对应的item, 返回此Item对应的数据.
 每一个Dictionary的内容:
 @{
    @"icon": UIImage,
    @"title":@"相册",
    @"type":@(WBPlusBoardButtonTypePhotoAlbum)
 }
 */
- (void)chatBar:(WBChatBarView *)chatBar didSelectItemInfo:(NSDictionary *)itemInfo;

@end

@protocol WBChatBarViewDataSource <NSObject>

/**
 给plusBoard添加按钮

 @return plusBoard 需要展示的数据,
 每一个Dictionary的内容:
 @{
    @"icon": UIImage,
    @"title":@"相册",
    @"type":@(WBPlusBoardButtonTypePhotoAlbum)
 }
 */
- (NSArray<NSDictionary *> *)plusBoardItemInfos:(WBChatBarView *)keyBoardView;

@end

#endif /* WBChatBarConst_h */
