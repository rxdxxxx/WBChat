//
//  WBNavigationController.m
//  Whiteboard
//
//  Created by RedRain on 2017/11/5.
//  Copyright © 2017年 RedRain. All rights reserved.
//

#import "WBNavigationController.h"

@interface WBNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation WBNavigationController


- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.navigationBarHidden = YES;
    self.navigationBar.translucent = NO;//透明
    
}



- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}


@end
