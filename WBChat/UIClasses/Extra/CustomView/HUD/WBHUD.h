//
//  WBHUD.h
//  Whiteboard
//
//  Created by RedRain on 2017/11/5.
//  Copyright © 2017年 RedRain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MBProgressHUD.h>

@interface WBHUD : NSObject

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;
+ (BOOL)hideForView:(UIView *)view;
+ (MBProgressHUD *)showSuccessMessage:(NSString *)message toView:(UIView *)view;
+ (MBProgressHUD *)showErrorMessage:(NSString *)message toView:(UIView *)view;
+ (MBProgressHUD *)progressFromView:(UIView *)view;
@end
