//
//  WBTabBar.m
//  Whiteboard
//
//  Created by RedRain on 2017/11/5.
//  Copyright © 2017年 RedRain. All rights reserved.
//

#import "WBTabBar.h"
#import "WBTabBarButton.h"
#import "WBConfig.h"

@interface WBTabBar ()

@property (nonatomic, strong)NSMutableArray* tabBarButtons;

@property (nonatomic, weak) WBTabBarButton* selectedButton;

@end

@implementation WBTabBar



-(NSMutableArray *)tabBarButtons
{
    if (_tabBarButtons == nil) {
        _tabBarButtons = [NSMutableArray array];
    }
    return _tabBarButtons;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor wb_navigationBarColor];
    }
    return self;
}


-(void)addTabBarButtonWithItem:(UITabBarItem *)item
{
    // 1.创建按钮
    WBTabBarButton *button = [[WBTabBarButton alloc] init];
    [self addSubview:button];
    // 添加按钮到数组中
    [self.tabBarButtons addObject:button];
    
    // 2.设置数据
    button.item = item;
    
    // 3.监听按钮点击
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
    
    // 4.默认选中第0个按钮
    if (self.tabBarButtons.count == 1) {
        [self buttonClick:button];
    }
}

/**
 *  监听按钮点击
 */
- (void)buttonClick:(WBTabBarButton *)button
{
    // 1.通知代理
    if ([self.delegate respondsToSelector:@selector(tabBar:didSelectedButtonFrom:to:)]) {
        [self.delegate tabBar:self didSelectedButtonFrom:self.selectedButton.tag to:button.tag];
    }
    
    // 2.设置按钮的状态
    self.selectedButton.selected = NO;
    button.selected = YES;
    self.selectedButton = button;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat h = self.frame.size.height;
    CGFloat w = self.frame.size.width;
    
    // 按钮的frame数据
    CGFloat buttonH = h;
    CGFloat buttonW = 70;
    CGFloat buttonY = 0;
    CGFloat buttonX = (w - buttonW * (self.tabBarButtons.count)) * 0.5;

    for (int index = 0; index<self.tabBarButtons.count; index++) {
        // 1.取出按钮
        WBTabBarButton *button = self.tabBarButtons[index];
        
        // 2.设置按钮的frame
        buttonX = buttonX + (index) * buttonW;

        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        // 3.绑定tag
        button.tag = index;
    }
}

-(void)dealloc
{
    
}

@end
