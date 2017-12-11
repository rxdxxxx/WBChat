//
//  WBChatListCellModel.m
//  WBChat
//
//  Created by RedRain on 2017/12/11.
//  Copyright © 2017年 RedRain. All rights reserved.
//

#import "WBChatListCellModel.h"
#import "WBConfig.h"

@implementation WBChatListCellModel

- (void)setDataModel:(AVIMConversation *)dataModel{
    _dataModel = dataModel;
    
    CGFloat cellW = kWBScreenWidth;
    CGFloat margin = 10;
    CGFloat cellH = 70;

    CGFloat headerWH = 50;
    _chatUserHeaderViewF = CGRectMake(margin, margin, headerWH, headerWH);
    
    
    CGFloat chatTitleW = cellW - headerWH - 2 * margin - 80;
    CGFloat chatTitleX = CGRectGetMaxX(_chatUserHeaderViewF) + margin;
    _chatTitleF = CGRectMake(chatTitleX, margin, chatTitleW, 26);
    
    
    CGFloat chatTimeW = 60;
    CGFloat chatTimeH = 16;
    CGFloat chatTimeX = cellW - chatTimeW - margin;
    CGFloat chatTimeY = ceil(CGRectGetHeight(_chatTitleF) - chatTimeH) / 2 + margin;
    _chatTimeF = CGRectMake(chatTimeX, chatTimeY, chatTimeW, chatTimeH);
    
    
    CGFloat chatMessageH = 18;
    CGFloat chatMessageY = cellH - margin * 1.3 - chatMessageH;
    CGFloat chatMessageW = cellW - chatTitleX - 2 * margin;
    _chatMessageF = CGRectMake(chatTitleX, chatMessageY, chatMessageW, chatMessageH);
}


@end
