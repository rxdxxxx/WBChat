//
//  WBModuleControl.m
//  Whiteboard
//
//  Created by RedRain on 2017/11/5.
//  Copyright © 2017年 RedRain. All rights reserved.
//

#import "WBModuleControl.h"
#import "WBLoginController.h"
#import "WBTabBarController.h"

@implementation WBModuleControl
+ (UIViewController *)controllerFromDidFinishLaunching{
    AVUser *user = [AVUser currentUser];
    if (user) {
        [self openClient];
        return [self loginedControllerWithUserModel:user];
    }else{
        return [[WBLoginController alloc] init];
    }
}


+ (void)openClient{
    
    AVUser *user = [AVUser currentUser];
    
    
    [[WBChatKit sharedInstance] openWithClientId:user.objectId success:^(NSString * _Nonnull clientId) {
        WBLog(@"链接成功");
    } error:^(NSError * _Nonnull error) {
        WBLog(@"链接失败: %@",
              error.description);
    }];
    
}

+ (UIViewController *)loginedControllerWithUserModel:(AVUser *)userModel{
    return [[WBTabBarController alloc] init];
}

+ (void)exchangeWindowRootControllerWithUserModel:(AVUser *)userModel{
    
    [self openClient];
    
    
    UIViewController *vc = [WBModuleControl loginedControllerWithUserModel:userModel];
    
    [[UIApplication sharedApplication].delegate.window setRootViewController:vc];
    [[UIApplication sharedApplication].delegate.window makeKeyAndVisible];
}

+ (void)quit{
    [[WBChatKit sharedInstance] closeWithCallback:^(BOOL succeeded, NSError * _Nonnull error) {
        
    }];
    
    UIViewController *vc = [[WBLoginController alloc] init];
    
    [[UIApplication sharedApplication].delegate.window setRootViewController:vc];
    [[UIApplication sharedApplication].delegate.window makeKeyAndVisible];
}


@end
