//
//  WBDefine.h
//  WBChat
//
//  Created by RedRain on 2018/1/15.
//  Copyright © 2018年 RedRain. All rights reserved.
//


#ifndef WBConfig_pch
#define WBConfig_pch

#import <AVOSCloud/AVOSCloud.h>
#import <AVOSCloudIM/AVOSCloudIM.h>


#define WBIMConversationFindErrorDomain @"WBIMConversationFindErrorDomain" ///< 查询会话信息


#define WBIM_CONVERSATION_TYPE @"type"
#define WBIMCustomMessageDegradeKey @"degrade"
#define WBIMCustomMessageIsCustomKey @"isCustom"

/**
 *  消息聊天类型
 */
typedef NS_ENUM(NSUInteger, WBIMConversationType){
    WBIMConversationTypeSingle = 0,
    WBIMConversationTypeGroup
};

/**
 用户使用国际化文件,展示UI界面

 @param key 统一key值
 @return 根据环境返回的字符串
 */
#ifndef WBIMLocalizedStrings
#define WBIMLocalizedStrings(key) \
NSLocalizedStringFromTableInBundle(key, @"LCChatKitString", [NSBundle lcck_bundleForName:@"Other" class:[self class]], nil)
#endif


#ifdef DEBUG
#define WBLog(fmt, ...) NSLog((@"\n%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ## __VA_ARGS__);
#else
#define WBLog(...)
#endif



#endif /* WBConfig_pch */
