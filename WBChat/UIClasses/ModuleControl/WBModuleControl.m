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
    //AVUser *user = [AVUser currentUser];
//    if (user) {
//        return [self loginedControllerWithUserModel:user];
//    }else{
        return [[WBLoginController alloc] init];
//    }
}

+ (UIViewController *)loginedController{//WithUserModel:(AVUser *)userModel{
    return [[WBTabBarController alloc] init];
}

+ (void)exchangeWindowRootController{//WithUserModel:(AVUser *)userModel{
    
    UIViewController *vc = [WBModuleControl loginedController];//WithUserModel:userModel];
    
    [[UIApplication sharedApplication].delegate.window setRootViewController:vc];
    [[UIApplication sharedApplication].delegate.window makeKeyAndVisible];
}

+ (void)quit{
    
    UIViewController *vc = [[WBLoginController alloc] init];
    
    [[UIApplication sharedApplication].delegate.window setRootViewController:vc];
    [[UIApplication sharedApplication].delegate.window makeKeyAndVisible];
}


@end
