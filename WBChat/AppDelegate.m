//
//  AppDelegate.m
//  WBChat
//
//  Created by RedRain on 2017/11/16.
//  Copyright © 2017年 RedRain. All rights reserved.
//

#import "AppDelegate.h"
#import "WBModuleControl.h"
#import <AVOSCloud/AVOSCloud.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self setupLeanCloud];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [self.window setRootViewController:[WBModuleControl controllerFromDidFinishLaunching]];
    
    [self.window makeKeyAndVisible];
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)setupLeanCloud{
#ifdef DEBUG
#else
    [AVOSCloud setAllLogsEnabled:false];
#endif
    [WBChatKit setAppId:@"O9I67dBpCiW8WcgoD89dCpla-gzGzoHsz"
              clientKey:@"HwqdEYsaL3D3Xqr45Ryr0PW1"];
    
    //    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    AVUser *user = [AVUser currentUser];
    
    
    [[WBChatKit sharedInstance] openWithClientId:user.objectId success:^(NSString * _Nonnull clientId) {
        WBLog(@"链接成功");
    } error:^(NSError * _Nonnull error) {
        WBLog(@"链接失败: %@",
              error.description);
    }];
    
}

@end

