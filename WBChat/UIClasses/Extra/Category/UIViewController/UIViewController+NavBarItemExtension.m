//
//  UIViewController+rrNavBarItemExtension.m
//  EUTv5
//
//  Created by Jason Ding on 16/6/24.
//  Copyright © 2016年 efetion. All rights reserved.
//

#import "UIViewController+NavBarItemExtension.h"
#import <objc/runtime.h>
#import "WBConfig.h"

@interface OPNavigationTitleView : UIView

@end

@implementation OPNavigationTitleView

- (CGSize)intrinsicContentSize {
    return UILayoutFittingExpandedSize;
}

@end

@implementation UIViewController (NavBarItemExtension)
/** 设置navigation的titleView */
- (UILabel *)rr_initTitleView:(NSString *)title{
    UIView *rrTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.navigationItem.titleView.frame), 30)];
    rrTitleView.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = rrTitleView;
    
    
    UILabel *rrTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    rrTitleLabel.center = rrTitleView.center;
    rrTitleLabel.textColor = [UIColor colorWithRed:0.22 green:0.53 blue:0.94 alpha:1.00];
    rrTitleLabel.textAlignment = NSTextAlignmentCenter;
    rrTitleLabel.backgroundColor = [UIColor clearColor];
    rrTitleLabel.font = [UIFont boldSystemFontOfSize:22];
    rrTitleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    [rrTitleView addSubview:rrTitleLabel];
    self.rrTitleLabel = rrTitleLabel;
    
    
    rrTitleLabel.text = title;
    
    return rrTitleLabel;
    
};

- (UIButton *)rr_initBtn{
    
    UIButton *btn = [[UIButton alloc ]init];
    btn.frame = CGRectMake(0, 0, 50, 40);
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_nav"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_nav_pressed"] forState:UIControlStateHighlighted];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    return btn;
}

/** 左: 给控制器添加返回的按钮 */
- (void) rr_initGoBackButton{
    
    // 返回按钮
    self.rrBackButton = [self rr_initBtn];
    [self.rrBackButton setImage:[UIImage imageNamed:@"ico_nav_back"] forState:UIControlStateNormal];
    [self.rrBackButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.rrBackButton addTarget:self action:@selector(rr_backAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rrBackButton];
    
    // 向左移动的空格
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                           target:nil action:nil];
    space.width = -15.0f;
    
    self.navigationItem.leftBarButtonItems = @[ space,backButtonItem];
};
/** 设置返回按钮的文字 */
- (UIButton *)rr_setBackItemTitle:(NSString *)string{
    if(string == nil || !string.length){
        return nil;
    }
    
    if (self.rrBackButton == nil) {
        [self rr_initGoBackButton];
    }
    
    [self.rrBackButton setTitle:string forState:UIControlStateNormal];
    return self.rrBackButton;
    
};

- (void)rr_backAction:(UIButton *)button{
    // 再点击返回后,这个按钮就设置为不能点击,防止卡顿的时候,一个按钮连按的情况
    button.userInteractionEnabled = NO;
    
    [self.navigationController popViewControllerAnimated:YES];
}

/** 右: 初始化控制器右侧的按钮, 需要添加target方法和 设置按钮的文字或图片 */
- (UIButton *)rr_initNavRightBtn{
    if (self.navigationItem.rightBarButtonItems.count == 0) {
        // 返回按钮
        UIBarButtonItem* ButtonItem = [self rr_creatNavBtn];
        self.rrRightBtn = (UIButton *) ButtonItem.customView;

        // 向右侧移动的空格
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                               target:nil action:nil];
        space.width = -15.0f;
        
        self.navigationItem.rightBarButtonItems = @[space,ButtonItem];
        
        return (UIButton *)ButtonItem.customView;
    }
    
    
    return self.rrRightBtn;
};



/** 左: 初始化控制器左侧的按钮, 需要添加target方法和 设置按钮的文字或图片 */
- (UIButton *)rr_initNavLeftBtn{
    if (self.rrLeftBtn) {
        return self.rrLeftBtn;
    }
    // 返回按钮
    UIBarButtonItem* ButtonItem = [self rr_creatNavBtn];
    self.rrLeftBtn = (UIButton *) ButtonItem.customView;

    // 向右侧移动的空格
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                           target:nil action:nil];
    space.width = - 15.0f;
    
    self.navigationItem.leftBarButtonItems = @[space,ButtonItem];
    
    return (UIButton *)ButtonItem.customView;
    
};


/** 右: 初始化控制器右侧的按钮, 需要添加target方法和 设置按钮的文字或图片 */
- (UIButton *)rr_initNavRightBtnWithTitle:(NSString *)title target:(id)target action:(SEL)action{
    
    // 返回按钮
    UIBarButtonItem* ButtonItem = [self rr_creatNavBtn];
    self.rrRightBtn = (UIButton *) ButtonItem.customView;
    
    //设置title
    [self.rrRightBtn setTitle:title forState:UIControlStateNormal];
    
    //添加点击事件
    [self.rrRightBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    // 向右侧移动的空格
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                           target:nil action:nil];
    space.width = -15.0f;
    
    self.navigationItem.rightBarButtonItems = @[space,ButtonItem];
    
    return self.rrRightBtn;
};

- (UIButton *)rr_initNavRightBtnWithImageName:(NSString *)imageName target:(id)target action:(SEL)action{

    // 返回按钮
    UIBarButtonItem* ButtonItem = [self rr_creatNavBtn];
    self.rrRightBtn = (UIButton *) ButtonItem.customView;
    
    //设置图片
    [self.rrRightBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    //添加点击事件
    [self.rrRightBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    // 向右侧移动的空格
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                           target:nil action:nil];
    space.width = -15.0f;
    
    self.navigationItem.rightBarButtonItems = @[space,ButtonItem];
    
    return self.rrRightBtn;
};




/** 左: 初始化控制器左侧的按钮, 需要添加target方法和 设置按钮的文字或图片 */
- (UIButton *)rr_initNavLeftBtnWithTitle:(NSString *)title target:(id)target action:(SEL)action{
    
    // 返回按钮
    UIBarButtonItem* ButtonItem = [self rr_creatNavBtn];
    self.rrLeftBtn = (UIButton *) ButtonItem.customView;
    
    //设置title
    [self.rrLeftBtn setTitle:title forState:UIControlStateNormal];
    
    //添加点击事件
    [self.rrLeftBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    // 向右侧移动的空格
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                           target:nil action:nil];
    space.width = - 15.0f;
    
    self.navigationItem.leftBarButtonItems = @[space,ButtonItem];
    
    return (UIButton *)ButtonItem.customView;
    
};


- (UIButton *)rr_initNavLeftBtnWithImageName:(NSString *)imageName target:(id)target action:(SEL)action{
    // 返回按钮
    UIBarButtonItem* ButtonItem = [self rr_creatNavBtn];
    self.rrLeftBtn = (UIButton *) ButtonItem.customView;
    
    //设置图片
    [self.rrLeftBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];

    
    //添加点击事件
    [self.rrLeftBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    // 向右侧移动的空格
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                           target:nil action:nil];
    space.width = - 15.0f;
    
    self.navigationItem.leftBarButtonItems = @[space,ButtonItem];
    
    return (UIButton *)ButtonItem.customView;
}

- (UIView *)rr_initTitleViewWithTitle:(NSString *)title target:(id)target action:(SEL)action{
    
    return [self rr_initTitleViewWithTitle:title imageString:@"Nav_down_w" target:self action:action];
}

- (UIView *)rr_initTitleViewWithTitle:(NSString *)title imageString:(NSString *)imageString target:(id)target action:(SEL)action{
    //
    OPNavigationTitleView *rrTitleView = [[OPNavigationTitleView alloc] initWithFrame:(CGRect){{0,0},{170,30}}];
    rrTitleView.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = rrTitleView;
    
    CGRect titleRect = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil];
    
    titleRect.size.width = titleRect.size.width > 155 ? 155 : titleRect.size.width;  //限制一下最大值
    
    UILabel *rrTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, titleRect.size.width + 5, 30)];
    rrTitleLabel.center = rrTitleView.center;
    rrTitleLabel.textColor = [UIColor whiteColor];
    rrTitleLabel.textAlignment = NSTextAlignmentCenter;
    rrTitleLabel.backgroundColor = [UIColor clearColor];
    rrTitleLabel.font = [UIFont systemFontOfSize:18.0f];
    rrTitleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    [rrTitleView addSubview:rrTitleLabel];
    self.rrTapTitleLabel = rrTitleLabel;
    
    rrTitleLabel.text = title;
    
    
    UIImageView  * remindImageView = [[UIImageView alloc]initWithFrame:CGRectMake(rrTitleLabel.right, 0, 15, 15)];
    remindImageView.centerY = rrTitleLabel.centerY;
    
    [remindImageView setImage:[UIImage imageNamed:imageString]];
    remindImageView.contentMode = UIViewContentModeScaleAspectFit;
    [rrTitleView addSubview:remindImageView];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:target action:action];
    [rrTitleView addGestureRecognizer:tap];
    
    return rrTitleView;
}

// 生成顶部的按钮.
- (UIBarButtonItem *)rr_creatNavBtn
{
    UIButton* Button = [[UIButton alloc ]init];
    Button.frame = CGRectMake(0, 0, 50, 44);
    
    [Button setBackgroundImage:[UIImage imageNamed:@"btn_nav"] forState:UIControlStateNormal];
    [Button setBackgroundImage:[UIImage imageNamed:@"btn_navbtn_nav_pressed"] forState:UIControlStateHighlighted];
    [Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [Button setTitleColor:[UIColor colorWithRed:1.000 green:1.000 blue:1.000 alpha:0.50] forState:UIControlStateDisabled];
    Button.titleLabel.textAlignment = NSTextAlignmentCenter;
    UIBarButtonItem *ButtonItem = [[UIBarButtonItem alloc] initWithCustomView:Button];
    Button.titleLabel.font = [UIFont systemFontOfSize:16];
    return ButtonItem;
}



#pragma mark - Setter Getter
- (void)setRrRightBtn:(UIButton *)rrRightBtn{
    objc_setAssociatedObject(self, @selector(rrRightBtn), rrRightBtn, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIButton *)rrRightBtn{
    return objc_getAssociatedObject(self, _cmd);
}


- (void)setRrLeftBtn:(UIButton *)rrLeftBtn{
    objc_setAssociatedObject(self, @selector(rrLeftBtn), rrLeftBtn, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIButton *)rrLeftBtn{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setRrTitleLabel:(UILabel *)rrTitleLabel{
    objc_setAssociatedObject(self, @selector(rrTitleLabel), rrTitleLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setRrTapTitleLabel:(UILabel *)rrTapTitleLabel{
    objc_setAssociatedObject(self, @selector(rrTapTitleLabel), rrTapTitleLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UILabel *)rrTapTitleLabel{
    
    return objc_getAssociatedObject(self, _cmd);
}
- (UILabel *)rrTitleLabel{
    return objc_getAssociatedObject(self, _cmd);
    
}



- (void)setRrBackButton:(UIButton *)rrBackButton{
    objc_setAssociatedObject(self, @selector(rrBackButton), rrBackButton, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIButton *)rrBackButton{
    return objc_getAssociatedObject(self, _cmd);
}


+ (UIViewController *)findBestViewController:(UIViewController*)vc {
    if (vc.presentedViewController) {
        // Return presented view controller
        return [UIViewController findBestViewController:vc.presentedViewController];
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        // Return right hand side
        UISplitViewController *svc = (UISplitViewController *) vc;
        if (svc.viewControllers.count > 0)
            return [UIViewController findBestViewController:svc.viewControllers.lastObject];
        else
            return vc;
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        // Return top view
        UINavigationController *svc = (UINavigationController*) vc;
        if (svc.viewControllers.count > 0)
            return [UIViewController findBestViewController:svc.topViewController];
        else
            return vc;
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        // Return visible view
        UITabBarController *svc = (UITabBarController *) vc;
        if (svc.viewControllers.count > 0)
            return [UIViewController findBestViewController:svc.selectedViewController];
        else
            return vc;
    } else {
        // Unknown view controller type, return last child view controller
        return vc;
    }
}
+ (UIViewController*)currentViewController {
    // Find best view controller
    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [UIViewController findBestViewController:viewController];
}

+ (NSString *)controllerInferredString{
    NSMutableString *finalString = [NSMutableString string];
    if ([self currentViewController].navigationController) {
        for (UIViewController *vc in [self currentViewController].navigationController.viewControllers) {
            [finalString appendFormat:@"%@->\n",NSStringFromClass(vc.class)];
        }
    }else{
        [finalString appendFormat:@"%@->\n",NSStringFromClass(self.class)];
    }
    return finalString;
}

@end

