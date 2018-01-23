//
//  WBKeyBoard.h
//  WBChat
//
//  Created by RedRain on 2018/1/20.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import <UIKit/UIKit.h>

/**************************************************************************
 *  加号按钮弹出的键盘的代理方法.
 ************************************************************************
 */

typedef NS_ENUM(NSUInteger, WBPlusBoardButtonType) {
    WBPlusBoardButtonTypePhotoAlbum,    // 相册
    WBPlusBoardButtonTypeCamera,        // 相机
    WBPlusBoardButtonTypeVideo,         // 视频聊天
    WBPlusBoardButtonTypeAudio,         // 音频聊天
    WBPlusBoardButtonTypeFile,          // 文件按钮
    WBPlusBoardButtonTypeVideoFile,     // 小视频
    WBPlusBoardButtonTypeFireAfterRead, // 阅后即焚
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

@interface WBKeyBoard : UIView

@property (nonatomic, assign) WBChatBarStatus status;

@property (nonatomic, assign) BOOL activity;

@end
