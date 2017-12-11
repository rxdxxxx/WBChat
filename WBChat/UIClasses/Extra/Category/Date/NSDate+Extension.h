//
//  NSDate+Extension.h
//  CMBMobileBank
//
//  Created by Jason Ding on 15/12/8.
//  Copyright © 2015年 efetion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)

/**
 格式化后的时间字符串

 @return 字符串 @"yyyy-MM-dd HH:mm:ss";
 */
- (NSString *)wb_formatStrig;


/**
 会话列表的时间格式
 
 今天: HH:mm
 昨天: 昨天
 其余: MM月dd日
 
 @return 格式化后的字符床
 */
- (NSString *)wb_chatListTimeString;
@end
