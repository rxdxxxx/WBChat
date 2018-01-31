//
//  WBChatListCellModel.m
//  WBChat
//
//  Created by RedRain on 2017/12/11.
//  Copyright © 2017年 RedRain. All rights reserved.
//

#import "WBChatListCellModel.h"
#import "WBConfig.h"
@interface WBChatListCellModel ()
@property (nonatomic, assign) BOOL didSearchName;
@end


@implementation WBChatListCellModel

- (void)handleLastMessageString:(WBChatListModel *)dataModel {
    AVIMTypedMessage *typedMessage = [dataModel.conversation.lastMessage wb_getValidTypedMessage];
    switch (typedMessage.mediaType) {
        case kAVIMMessageMediaTypeText:
            self.lastMessageString = typedMessage.text;
            break;
        case kAVIMMessageMediaTypeImage:
            self.lastMessageString = @"[图片]";
            break;
        case kAVIMMessageMediaTypeAudio:
            self.lastMessageString = @"[语音]";
            break;
        case kAVIMMessageMediaTypeVideo:
            self.lastMessageString = @"[视频]";
            break;
        case kAVIMMessageMediaTypeLocation:
            self.lastMessageString = @"[位置]";
            break;
        case kAVIMMessageMediaTypeFile:
            self.lastMessageString = @"[文件]";
            break;
        case kAVIMMessageMediaTypeRecalled:
            self.lastMessageString = @"[有一条撤回的消息]";
            break;
        case kAVIMMessageMediaTypeNone:
            self.lastMessageString = @"";
            break;
        default:
            self.lastMessageString = @"[不支持的消息类型]";
            break;
    }
}

- (void)handleTitle:(WBChatListModel *)dataModel{
    NSArray *member = dataModel.conversation.members;
    if (member.count == 2 ) {
        if (!self.didSearchName) {
            NSString *otherObjectId = member.firstObject;
            if ([otherObjectId isEqualToString:[AVUser currentUser].objectId]) {
                otherObjectId = member.lastObject;
            }
            AVQuery *query = [AVQuery queryWithClassName:@"_User"];
            [query getObjectInBackgroundWithId:otherObjectId block:^(AVObject *object, NSError *error) {
                self.didSearchName = YES;
                self.title = ((AVUser *)object).username;
            }];
        }
    }else{
        self.title = dataModel.conversation.name;
    }
}

- (void)setDataModel:(WBChatListModel *)dataModel{
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
    
    
    CGFloat unreadBadgeBtnWH = 20;
    CGFloat unreadBadgeBtnX = CGRectGetMaxX(_chatUserHeaderViewF) - 12;
    CGFloat unreadBadgeBtnY = CGRectGetMinY(_chatUserHeaderViewF) - 4;
    _unreadBadgeBtnF = CGRectMake(unreadBadgeBtnX, unreadBadgeBtnY, unreadBadgeBtnWH, unreadBadgeBtnWH);
    
    CGFloat cutLineH = 1;
    CGFloat cutLineY = cellH - cutLineH;
    CGFloat cutLineW = cellW;
    _cutLineF = CGRectMake(0, cutLineY, cutLineW, cutLineH);
    
    [self handleLastMessageString:dataModel];
    [self handleTitle:dataModel];

}


@end
