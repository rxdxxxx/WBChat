//
//  WBModuleControl.h
//  Whiteboard
//
//  Created by RedRain on 2017/11/5.
//  Copyright © 2017年 RedRain. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AVUser;
@interface WBModuleControl : NSObject


+ (UIViewController *)controllerFromDidFinishLaunching;


/**
 根据用户的信息,切换到不同的控制器

 @param userModel 用户信息模型
 */
+ (void)exchangeWindowRootControllerWithUserModel:(AVUser *)userModel;


/**
 退出登录
 */
+ (void)quit;

@end
