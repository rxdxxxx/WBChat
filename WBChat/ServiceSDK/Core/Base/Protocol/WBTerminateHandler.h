//
//  OPTerminateHandler.h
//  AccountingLife
//
//  Created by RedRain on 16/11/19.
//  Copyright © 2016年 haixue. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WBTerminateHandler <NSObject>

@required
- (void)onApplicationWillTerminateTask;

@end
