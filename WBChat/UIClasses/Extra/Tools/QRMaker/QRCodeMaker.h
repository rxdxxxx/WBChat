//
//  QRCodeMaker.h
//  Life
//
//  Created by RedRain on 17/3/6.
//  Copyright © 2017年 efetion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreImage/CoreImage.h>
#import <AVFoundation/AVFoundation.h>

@interface QRCodeMaker : NSObject

+ (UIImage *)generateWithDefaultQRCodeData:(NSString *)data imageViewWidth:(CGFloat)imageViewWidth ;
@end
