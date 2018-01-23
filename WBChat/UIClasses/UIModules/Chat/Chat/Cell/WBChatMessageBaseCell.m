//
//  WBChatBaseCell.m
//  WBChat
//
//  Created by RedRain on 2018/1/18.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import "WBChatMessageBaseCell.h"
#import "WBChatMessageTextCell.h"

@interface WBChatMessageBaseCell ()

///对方的头像
@property (nonatomic, strong) UIImageView *headerImageView;
///自己的头像
@property (nonatomic, strong) UIImageView *myHeaderImageView;
///对方的昵称
@property (nonatomic, strong) UILabel *usernameLabel;

@end

@implementation WBChatMessageBaseCell

+ (instancetype)cellWithTableView:(UITableView *)tableView cellModel:(WBChatMessageBaseCellModel *)cellModel {
    
    WBChatMessageBaseCell *cell = nil;
    switch (cellModel.cellType) {
        case WBChatCellTypeText:{
            cell = [WBChatMessageTextCell cellWithTableView:tableView];
        }
            break;
            
        default:
            break;
    }
    
    if (cell == nil) {
        cell = [WBChatMessageBaseCell new];
    }
    
    cell.cellModel = cellModel;
    return cell;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"WBChatMessageBaseCell";
    WBChatMessageBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[WBChatMessageBaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.headerImageView];
        [self.contentView addSubview:self.myHeaderImageView];
        [self.contentView addSubview:self.bubbleImageView];
        [self.contentView addSubview:self.messageStatusImageView];
        [self.contentView addSubview:self.messageReadStateLabel];
        [self.contentView addSubview:self.usernameLabel];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}



#pragma mark - getters and setters
- (void)setCellModel:(WBChatMessageBaseCellModel *)cellModel{
    _cellModel = cellModel;
    
    // 关闭掉动画,此处头像乱移动的问题.
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    self.headerImageView.frame = cellModel.headerRectFrame;
    self.myHeaderImageView.frame = cellModel.myHeaderRectFrame;
    self.messageStatusImageView.frame = cellModel.messageStatusRectFrame;
    self.messageReadStateLabel.frame = cellModel.messageReadStateRectFrame;
    self.usernameLabel.frame = cellModel.usernameRectFrame;
    
    [CATransaction commit];
    
    
    //设置页面（头像及气泡）
    [self setInterface];
}

/**
 *  区分图片message与其他消息的区别,图片message需要特殊的mask图
 */
- (UIImage *)bulleiImageWithNormelName:(NSString*)normelName{
    
    return [[UIImage wb_resourceImageNamed:normelName] stretchableImageWithLeftCapWidth:15 topCapHeight:30];
}

- (void)setInterface {
    
    AVIMTypedMessage* dataModel = self.cellModel.messageModel;
    UIImage * bubbleImage = nil;
    
    if(dataModel.ioType == AVIMMessageIOTypeIn){
        self.headerImageView.hidden = NO;
        self.myHeaderImageView.hidden = YES;
        
        bubbleImage = [self bulleiImageWithNormelName:@"dialog_bubble_other"];
        if (!self.headerImageView.gestureRecognizers.count) {
//            [self.headerImageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushToTheDetialVC)]];
//            [self.headerImageView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(headerImageViewLongPressEvent:)]];
        }
        self.headerImageView.image = [UIImage wb_userHeaderPlaceholderImage];
//        [self.headerImageView xm_imageWithUserID:dataModel.senderUserId.longLongValue
//                                     placeholder:[UIImage wb_userHeaderPlaceholderImage]];
        
        //显示昵称
        self.usernameLabel.hidden = NO;
        
//        [[XMContactManager manager] fastContactWithRequestComponets:[XMContactRequestComponets new].xm_userid(dataModel.senderUserId.longLongValue)  tryingBlock:nil result:^(XMContactModel *contactModel, BOOL sync) {
//            self.usernameLabel.text = contactModel.displayName;
//        }];
        
    }
    // 发送的信息的气泡
    else {
        self.headerImageView.hidden = YES;
        self.myHeaderImageView.hidden = NO;
        //如果为内容为图片，则另外显示气泡形状
        self.myHeaderImageView.userInteractionEnabled = YES;
        if (!self.myHeaderImageView.gestureRecognizers.count) {
//            [self.myHeaderImageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushToTheDetialVC)]];
        }
        
        if(self.cellModel.cellType == WBChatCellTypeCardInfo ||
           self.cellModel.cellType == WBChatCellTypeFile ||
           self.cellModel.cellType == WBChatCellTypeRichContent){
            
            bubbleImage = [self bulleiImageWithNormelName:@"news-bg-card-me"];
        }
        else {
            bubbleImage= [self bulleiImageWithNormelName:@"news-bg-me"];
        }
        
        
        if(dataModel.status == AVIMMessageStatusRead){
            self.messageReadStateLabel.hidden = NO;
        }else{
            self.messageReadStateLabel.hidden = YES;
        }
        

        
        // 显示自己的头像
        self.myHeaderImageView.image = [UIImage wb_userHeaderPlaceholderImage];

//        [self.myHeaderImageView wb_imageWithUserID:dataModel.senderUserId.longLongValue
//                                       placeholder:[UIImage xm_userHeaderPlaceholderImage]];
        
        //发送失败显示的图标

        
        if (dataModel.status == AVIMMessageStatusFailed || dataModel.status == AVIMMessageStatusNone) {
            self.messageStatusImageView.hidden = NO;
            self.messageStatusImageView.image = [UIImage wb_resourceImageNamed:@"ExclamationMark"];
            [self.messageStatusImageView.layer removeAllAnimations];
        } else if (dataModel.status == AVIMMessageStatusSending &&
                   self.cellModel.cellType != WBChatCellTypeImage &&
                   self.cellModel.cellType != WBChatCellTypeFile
                   ){
            self.messageStatusImageView.hidden = NO;
            self.messageStatusImageView.image = [UIImage wb_resourceImageNamed:@"refresh_icon"];
            [self.messageStatusImageView wb_addRorationAnimaitonInLayer];
        } else {
            self.messageStatusImageView.hidden = YES;
            [self.messageStatusImageView.layer removeAllAnimations];
        }
    }
    // 气泡
    self.bubbleImageView.image = bubbleImage;
}


/**
 *  对方头像
 */
- (UIImageView *)headerImageView {
    if (_headerImageView == nil) {
        _headerImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _headerImageView.layer.cornerRadius = 3.0;
        _headerImageView.layer.masksToBounds = YES;
        _headerImageView.userInteractionEnabled = YES;
    }
    return _headerImageView;
}

- (UIImageView *)myHeaderImageView {
    if (_myHeaderImageView == nil) {
        _myHeaderImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _myHeaderImageView.layer.cornerRadius = 3.0;
        _myHeaderImageView.layer.masksToBounds = YES;
    }
    return _myHeaderImageView;
}

/**
 *  气泡背景
 */
- (UIImageView *)bubbleImageView {
    if (_bubbleImageView == nil) {
        _bubbleImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _bubbleImageView.userInteractionEnabled = YES;
        _bubbleImageView.backgroundColor = [UIColor clearColor];
        UILongPressGestureRecognizer *contentLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(bubbleLongPress:)];
        contentLongPress.minimumPressDuration = 0.5;
        [_bubbleImageView addGestureRecognizer:contentLongPress];
        
    }
    
    return _bubbleImageView;
}

- (UIImageView *)messageStatusImageView {
    if (_messageStatusImageView == nil) {
        _messageStatusImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _messageStatusImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *resentMessage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resentMessage:)];
        [_messageStatusImageView addGestureRecognizer:resentMessage];
        
        // 1,图片旋转
        [_messageStatusImageView wb_addRorationAnimaitonInLayer];
    }
    return _messageStatusImageView;
}

- (UILabel *)messageReadStateLabel
{
    if (_messageReadStateLabel == nil) {
        _messageReadStateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _messageReadStateLabel.font = [UIFont systemFontOfSize:14.0f];
        _messageReadStateLabel.textColor = [UIColor lightGrayColor];
        _messageReadStateLabel.hidden = YES;
        _messageReadStateLabel.text = @"已读";
        
    }
    return _messageReadStateLabel;
}

- (UILabel *)usernameLabel {
    if (!_usernameLabel) {
        _usernameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _usernameLabel.font = [UIFont systemFontOfSize:12.0f];
        _usernameLabel.hidden = YES;
        _usernameLabel.textAlignment = NSTextAlignmentLeft;
        _usernameLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _usernameLabel;
}

- (UILabel *)timeLabel{
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] init];
        [_timeLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [_timeLabel setTextColor:[UIColor whiteColor]];
        [_timeLabel setBackgroundColor:[UIColor grayColor]];
        [_timeLabel setAlpha:0.7f];
        [_timeLabel.layer setMasksToBounds:YES];
        [_timeLabel.layer setCornerRadius:5.0f];
    }
    return _timeLabel;
}
@end
