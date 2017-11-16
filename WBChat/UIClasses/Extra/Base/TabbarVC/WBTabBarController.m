//
//  WBTabBarController.m
//  Whiteboard
//
//  Created by RedRain on 2017/11/5.
//  Copyright © 2017年 RedRain. All rights reserved.
//

#import "WBTabBarController.h"
#import "WBTabBar.h"
#import "WBNavigationController.h"

@interface WBTabBarController ()<WBTabBarDelegate>
@property (nonatomic, weak)WBTabBar* customTabBar;

@end

@implementation WBTabBarController
#pragma mark -  Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 初始化tabbar
    [self setupTabbar];
    
    // 初始化所有的子控制器
    [self setupChildViewControllers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // 删除系统自动生成的UITabBarButton
    for (UIView *child in self.tabBar.subviews) {
        if ([child isKindOfClass:[UIControl class]]) {
            [child removeFromSuperview];
        }
    }
}
- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    // 删除系统自动生成的UITabBarButton
    for (UIView *child in self.tabBar.subviews) {
        if ([child isKindOfClass:[UIControl class]]) {
            [child removeFromSuperview];
        }
    }
}

/**
 *  初始化tabbar
 */
-(void)setupTabbar
{
    WBTabBar * customTabbar = [[WBTabBar alloc]init];
    customTabbar.frame = self.tabBar.bounds;
    customTabbar.delegate = self;
    [self.tabBar addSubview:customTabbar];
    self.customTabBar = customTabbar;
    
    self.tabBar.shadowImage = [UIImage new];
    self.tabBar.backgroundImage = [UIImage new];
    self.tabBar.backgroundColor = [UIColor clearColor];
}
/**
 * 初始化所有的子控制器
 */
- (void)setupChildViewControllers
{
//    WBHomePageController *cloudChat = [[WBHomePageController alloc] init];
//    [self setupOneChildViewController:cloudChat title:@"" image:@"ico_tab_event" selectedImage:@"ico_tab_event_selected"];
//    
//    WBMEController *addressBook = [[WBMEController alloc] init];
//    [self setupOneChildViewController:addressBook title:@"" image:@"ico_tab_more" selectedImage:@"ico_tab_more_selected"];
}

- (void)setupOneChildViewController:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    vc.title = title;
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:image];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self addChildViewController:[[WBNavigationController alloc] initWithRootViewController:vc]];
    
    [self.customTabBar addTabBarButtonWithItem:vc.tabBarItem];
}

#pragma mark - tabbar的代理方法
/**
 *  监听tabbar按钮的改变
 *  @param from   原来选中的位置
 *  @param to     最新选中的位置
 */

-(void)tabBar:(WBTabBar *)tabBar didSelectedButtonFrom:(NSInteger)from to:(NSInteger)to
{
    self.selectedIndex = to;
    
    if (to == 0) { // 点击了首页
        //        [self.findVC refresh];
    }
}


@end
