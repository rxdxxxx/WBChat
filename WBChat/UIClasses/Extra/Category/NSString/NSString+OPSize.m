//
//  NSString+OPSize.m
//  LCGOptimusPrime
//
//  Created by RedRain on 2017/8/9.
//  Copyright © 2017年 erics. All rights reserved.
//

#import "NSString+OPSize.h"
#define usualCode @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_"
@implementation NSString (OPSize)
- (CGSize)lcg_sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    
    
}

- (CGSize)lcg_sizeWithFont:(UIFont *)font
{
    return [self lcg_sizeWithFont:font maxW:MAXFLOAT];
}

- (NSString *)lcg_removeWhitespaceAndNewlineCharacterSet{
    NSString* headerData = [self copy];
    headerData = [headerData stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    headerData = [headerData stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    headerData = [headerData stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    headerData = [headerData stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
    return headerData;
}



- (NSString *)lcg_filterSpecialStr
{
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"-`~!@#$%^&*()+=|{}':',\[].<>/?~！@#￥%……& amp;*（）——+|{}【】‘；：”“’。，、？|_"];
        // `~!@#$%^&*()+=|{}':',\[\].<>/?~！@#￥%……& amp;*（）——+|{}【】‘；：”“’。，、？|-
    NSString * trimmedString = [self stringByTrimmingCharactersInSet:set];
    NSArray * stringArray = [trimmedString componentsSeparatedByString:@"-"];
    NSString * finalTrimmedString = [stringArray componentsJoinedByString:@""];
  
    
    return finalTrimmedString;
    

}

- (BOOL)isLegalExpressCode:(NSString *)expressCode
{
    BOOL _isExpressCode;
    NSCharacterSet * set = [NSCharacterSet  characterSetWithCharactersInString:usualCode];
    
    NSString * filterString = [[expressCode componentsSeparatedByCharactersInSet:set] componentsJoinedByString:@""];
    
    // LYLog(@"filterString == %@",filterString);
    
    
    if (filterString.length >0 ) {
        
        _isExpressCode = NO;
    }else{
        
        _isExpressCode = YES;
    }
    
    
    if ([expressCode containsString:@"http"] ||[expressCode containsString:@"www"]||[expressCode containsString:@"LP"]||[expressCode containsString:@"Lp"]||[expressCode containsString:@"lp"]||[expressCode containsString:@"lP"]||[expressCode containsString:@"https"]) {
        
        _isExpressCode = NO;
    }
    
    return _isExpressCode;
}



@end
