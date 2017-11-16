//
//  WBTabBarButton.m
//  Whiteboard
//
//  Created by RedRain on 2017/11/5.
//  Copyright © 2017年 RedRain. All rights reserved.
//

#import "WBTabBarButton.h"

@implementation WBTabBarButton
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.imageView.contentMode = UIViewContentModeCenter;
        self.titleLabel.contentMode = UIViewContentModeCenter;
        
    }
    return self;
}
// 去除高亮状态
-(void)setHighlighted:(BOOL)highlighted{};

// 内部图片的frame
-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW = contentRect.size.width;
    CGFloat imageH = contentRect.size.height;
    return  CGRectMake(0, 0, imageW, imageH);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    return CGRectZero;
}

// 设置item
-(void)setItem:(UITabBarItem *)item
{
    _item = item;
    
    [self setImage:item.image forState:(UIControlStateNormal)];
    [self setImage:item.selectedImage forState:(UIControlStateSelected)];
    [self setTitle:item.title forState:UIControlStateNormal];
}

@end
