//
//  WBTabBar.h
//  Whiteboard
//
//  Created by RedRain on 2017/11/5.
//  Copyright © 2017年 RedRain. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WBTabBar;

@protocol WBTabBarDelegate <NSObject>

@optional
/**自定义tabbar，用于在不同的控制器中切换*/
-(void)tabBar:(WBTabBar *)tabBar didSelectedButtonFrom:(NSInteger)from to:(NSInteger)to;

@end


@interface WBTabBar : UIView

-(void)addTabBarButtonWithItem:(UITabBarItem *)item;

@property (nonatomic, weak)id<WBTabBarDelegate> delegate;

@end
