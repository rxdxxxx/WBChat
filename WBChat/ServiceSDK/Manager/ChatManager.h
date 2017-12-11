//
//  ChatManager.h
//  Chat-LC
//
//  Created by RedRain on 2017/12/7.
//  Copyright © 2017年 RedRain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud/AVOSCloud.h>
#import <AVOSCloudIM/AVOSCloudIM.h>


@interface ChatManager : NSObject
+ (instancetype)sharedInstance;

@property (nonatomic, strong) AVIMClient *client;

- (void)list:(AVIMArrayResultBlock)block;

@end
