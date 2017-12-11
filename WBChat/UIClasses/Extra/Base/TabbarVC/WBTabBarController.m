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
#import "WBMeListController.h"
#import "WBDiscoverListController.h"
#import "WBContactsListController.h"
#import "WBChatListController.h"

@interface WBTabBarController ()<WBTabBarDelegate>
@property (nonatomic, weak)WBTabBar* customTabBar;

@end

@implementation WBTabBarController
#pragma mark -  Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 初始化tabbar
    
    
    // 初始化所有的子控制器
    [self setupChildViewControllers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * 初始化所有的子控制器
 */
- (void)setupChildViewControllers
{
    WBChatListController *chatList = [[WBChatListController alloc] init];
    [self setupOneChildViewController:chatList title:@"聊呗" image:@"ico_tab_event" selectedImage:@"ico_tab_event_selected"];
    
    WBContactsListController *contactsList = [[WBContactsListController alloc] init];
    [self setupOneChildViewController:contactsList title:@"通讯录" image:@"ico_tab_schedule" selectedImage:@"ico_tab_schedule_selected"];
    
    
    WBDiscoverListController *discoverList = [[WBDiscoverListController alloc] init];
    [self setupOneChildViewController:discoverList title:@"发现" image:@"ico_tab_user" selectedImage:@"ico_tab_user_selected"];
    
    
    WBMeListController *meList = [[WBMeListController alloc] init];
    [self setupOneChildViewController:meList title:@"我" image:@"ico_tab_more" selectedImage:@"ico_tab_more_selected"];
}

- (void)setupOneChildViewController:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    vc.title = title;
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:image];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self addChildViewController:[[WBNavigationController alloc] initWithRootViewController:vc]];
}


@end
