//
//  QRCodeMaker.m
//  Life
//
//  Created by RedRain on 17/3/6.
//  Copyright © 2017年 efetion. All rights reserved.
//

#import "QRCodeMaker.h"
@interface QRCodeMaker ()

@property (nonatomic, strong, readwrite) UIImage *filterImage;
@property (nonatomic, strong, readwrite) UIImage *QRCodeImage;

@end


@implementation QRCodeMaker
/**
 *  生成一张普通的二维码
 *
 *  @param data    传入你要生成二维码的数据
 *  @param imageViewWidth    图片的宽度
 */
+ (UIImage *)generateWithDefaultQRCodeData:(NSString *)data imageViewWidth:(CGFloat)imageViewWidth {

    UIImage *qrImage = nil;
    @try {
        NSData *infoData = [data dataUsingEncoding:NSUTF8StringEncoding];
        if (infoData == nil || infoData.length == 0) {
            return nil;
        }
        
        // 1、创建滤镜对象
        CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
        if (filter == nil) {
            return nil;
        }
        
        // 恢复滤镜的默认属性
        [filter setDefaults];
        [filter setValue:@"M" forKey:@"inputCorrectionLevel"];
        
        // 2、设置数据
        [filter setValue:infoData forKey:@"inputMessage"];
        
        // 3、获得滤镜输出的图像
        CIImage *outputImage = [filter outputImage];
        
        // 4.输出成高清图
        CGAffineTransform transform = CGAffineTransformMakeScale(20, 20);
        outputImage = [outputImage imageByApplyingTransform:transform];
        
        qrImage = [UIImage imageWithCIImage:outputImage];
        return qrImage;

    } @catch (NSException *exception) {
        return nil;
    } @finally {
        return qrImage;
    }
    
    
}







@end
