//
//  WBChatBaseCellModel.m
//  WBChat
//
//  Created by RedRain on 2018/1/18.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import "WBChatMessageBaseCellModel.h"
#import "WBChatMessageTextCellModel.h"

@implementation WBChatMessageBaseCellModel

+ (instancetype)modelWithMessageModel:(AVIMTypedMessage *)messageModel{
    AVIMTypedMessage *typedMessage = [messageModel wb_getValidTypedMessage];
    
    WBChatMessageBaseCellModel *model = nil;
    switch (typedMessage.mediaType) {
        case kAVIMMessageMediaTypeText:
             model = [WBChatMessageTextCellModel new];
            break;
        case kAVIMMessageMediaTypeImage:
            
            break;
        case kAVIMMessageMediaTypeAudio:
            
            break;
        case kAVIMMessageMediaTypeVideo:
            
            break;
        case kAVIMMessageMediaTypeLocation:
            
            break;
        case kAVIMMessageMediaTypeFile:
            
            break;
        case kAVIMMessageMediaTypeRecalled:
            
            break;
        default:
            
            break;
    }
    if (model == nil) {
        model = [WBChatMessageBaseCellModel new];
    }
    model.messageModel = messageModel;
    return model;
}

- (void)setMessageModel:(AVIMTypedMessage *)messageModel{
    _messageModel = messageModel;
    
    
    
    
    WBChatCellConfig *config = [WBChatCellConfig sharedInstance];
    CGFloat headerMarginSpace = config.headerMarginSpace;
    CGSize headerSize = config.headerImageSize;
    
    
    _messageReadStateRectFrame = CGRectZero;
    _usernameRectFrame = CGRectZero;
    
    // 如果是多图文消息 或者 回撤消息.
    if (self.cellType == WBChatCellTypeUnknow ||
        self.cellType == WBChatCellTypeTime ||
        self.cellType == WBChatCellTypeNotification ||
        self.cellType == WBChatCellTypeCallHint ||
        self.cellType == WBChatCellTypePSRichContent||
        self.cellType == WBChatCellTypePSMultiRichContent ||
        self.cellType == WBChatCellTypeRecallNotification) {
        
        _headerRectFrame = CGRectZero;
        _myHeaderRectFrame = CGRectZero;
        _messageStatusRectFrame = CGRectZero;
        _myHeaderRectFrame = CGRectZero;
        
    } else if (messageModel.ioType == AVIMMessageIOTypeIn) {
        // 收到的消息的状态就是MessageStatusNone
        
        _headerRectFrame = CGRectMake(headerMarginSpace, headerMarginSpace, headerSize.width, headerSize.height);
        
    } else {
        CGFloat headerX = kWBScreenWidth - headerMarginSpace - headerSize.width;
        _myHeaderRectFrame = CGRectMake(headerX, headerMarginSpace, headerSize.width, headerSize.height);
    }
    if ([self needShowUsernameLabel]) {
        CGFloat userNameX = CGRectGetMaxX(_headerRectFrame) + config.headerBubbleSpace + config.bubbleClosedAngleWidth;
        CGFloat userNameY = CGRectGetMinY(_headerRectFrame);
        _usernameRectFrame = CGRectMake(userNameX, userNameY, config.userNameSize.width, config.userNameSize.height);
    }
}

- (BOOL)needShowUsernameLabel {
    //AVIMMessageIOType status = self.messageModel.ioType;
    return NO;
//    return (self.messageModel.conversationType == XM_ConversationType_DISCUSSION ||
//            self.messageModel.conversationType == XM_ConversationType_GROUP) &&
//    status == XM_MessageDirection_RECEIVE;
}

- (void)adjustCellHeightIfNeeded {
//    if ([self needShowUsernameLabel]) {
//        self.cellHeight += kDialogUserNameLabelHeight + kDialogUserNameLabelYWithBubble;
//    }
}

@end
