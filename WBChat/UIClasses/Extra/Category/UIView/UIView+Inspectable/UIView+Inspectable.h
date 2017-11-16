//
//  UIView+Inspectable.h
//  WeiBo17
//
//  Created by teacher on 15/8/17.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>


//IB_DESIGNABLE
@interface UIView (Inspectable)
//    self.textField.layer.cornerRadius = 8;
//    self.textField.layer.masksToBounds = YES;
//
//    self.textField.layer.borderWidth = 3;
//    self.textField.layer.borderColor = [UIColor orangeColor].CGColor;

/**
 *  可以在xib里面直接设置的:圆角
 */
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;
/**
 *  可以在xib里面直接设置的:边线宽度
 */
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
/**
 *  可以在xib里面直接设置的:边线颜色
 */
@property (nonatomic, assign) IBInspectable UIColor *borderColor;



@end
