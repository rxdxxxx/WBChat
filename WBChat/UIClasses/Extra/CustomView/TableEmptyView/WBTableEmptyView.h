//
//  WBTableEmptyView.h
//  Whiteboard
//
//  Created by RedRain on 2017/11/7.
//  Copyright © 2017年 RedRain. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WBTableEmptyView;

@protocol WBTableEmptyViewDelegate <NSObject>

- (void)tableEmptyViewDidClickAction:(WBTableEmptyView *)emptyView;

@end

@interface WBTableEmptyView : UIView

@property (nonatomic, weak) id<WBTableEmptyViewDelegate> delegate;

/**
 重新设置按钮文字, 如果参数传入 nil 或 @"". 按钮会被隐藏,
 注意需要在设置empty之后重置
 */
- (void)resetActionBtnTitleWithString:(NSString *)titleString;
@end
