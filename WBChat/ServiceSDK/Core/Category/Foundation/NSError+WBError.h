//
//  NSError+WBError.h


#import <Foundation/Foundation.h>

@interface NSError (WBError)
+ (instancetype)wb_description:(NSString *)desc;
@end
