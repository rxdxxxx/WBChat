//
//  UIViewController+rrNavBarItemExtension.h
//  EUTv5
//
//  Created by Jason Ding on 16/6/24.
//  Copyright © 2016年 efetion. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIViewController (NavBarItemExtension)
@property (nonatomic, strong) UIButton *rrBackButton;
@property (nonatomic, strong) UILabel *rrTitleLabel;
@property (nonatomic, strong) UIButton *rrLeftBtn;
@property (nonatomic, strong) UIButton *rrRightBtn;

@property (nonatomic,strong) UILabel * rrTapTitleLabel;

#pragma mark - navBar显示
/** 设置navigation的titleView */
- (UILabel *) rr_initTitleView:(NSString *)title;

/** 左: 给控制器添加返回的按钮 */
- (void) rr_initGoBackButton;
/** 设置返回按钮的文字 */
- (UIButton *)rr_setBackItemTitle:(NSString *)string;

- (void) rr_backAction:(UIButton *)button;

/** 右: 初始化控制器右侧的按钮, 需要添加target方法和 设置按钮的文字或图片 */
- (UIButton *)rr_initNavRightBtn;
- (UIButton *)rr_initNavRightBtnWithTitle:(NSString *)title target:(id)target action:(SEL)action;
- (UIButton *)rr_initNavRightBtnWithImageName:(NSString *)imageName target:(id)target action:(SEL)action;

/** 左: 初始化控制器左侧的按钮, 需要添加target方法和 设置按钮的文字或图片 */
- (UIButton *)rr_initNavLeftBtn;
- (UIButton *)rr_initNavLeftBtnWithTitle:(NSString *)title target:(id)target action:(SEL)action;
- (UIButton *)rr_initNavLeftBtnWithImageName:(NSString *)imageName target:(id)target action:(SEL)action;


/** 中:初始化titleView 附带点击事件*/
- (UIView *)rr_initTitleViewWithTitle:(NSString *)title target:(id)target action:(SEL)action;

- (UIView *)rr_initTitleViewWithTitle:(NSString *)title imageString:(NSString *)imageString target:(id)target action:(SEL)action;

+ (UIViewController*) currentViewController;

+ (NSString *)controllerInferredString;

@end



