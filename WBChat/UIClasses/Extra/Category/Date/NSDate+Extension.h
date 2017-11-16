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
 *  判断某个时间是否为今年
 */
- (BOOL)isThisYear;

/**
 *  判断某个时间是否为昨天
 */
- (BOOL)isYesterday;

/**
 *  判断某个时间是否为今天
 */
- (BOOL)isToday;

/**
 *  判断两个时间戳是否为同一天
 */
+ (BOOL)isDate:(long long)dateNumber1 inSameDayAsDate:(long long)dateNumber2;


/**
 格式化后的时间字符串

 @return 字符串
 */
- (NSString *)rr_formatStrig;
@end
