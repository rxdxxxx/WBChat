//
//  AVIMTypedMessage+WBExtension.h
//  WBChat

#import <AVOSCloudIM/AVOSCloudIM.h>

@interface AVIMTypedMessage (WBExtension)

- (void)wb_setAttributesObject:(id)object forKey:(NSString *)key;

@end
