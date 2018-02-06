//
//  WBChatMessageVoiceCell.m
//  WBChat
//
//  Created by RedRain on 2018/2/6.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import "WBChatMessageVoiceCell.h"
#import "WBChatMessageVoiceCellModel.h"

@interface WBChatMessageVoiceCell ()
@property (nonatomic, strong) WBMessageModel *currentChatModel;
@property (nonatomic, strong) UIImageView *voiceWaveImageView;
@property (nonatomic, strong) UILabel *voiceTimeNumLabel;

@end

@implementation WBChatMessageVoiceCell
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"WBChatMessageVoiceCell";
    WBChatMessageVoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[WBChatMessageVoiceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.bubbleImageView addSubview:self.voiceWaveImageView];
        [self.bubbleImageView addSubview:self.voiceTimeNumLabel];
    }
    return self;
}

- (void)setCellModel:(WBChatMessageBaseCellModel *)cellModel{
    [super setCellModel:cellModel];
    
    WBChatMessageVoiceCellModel *voiceCellFrameModel = (WBChatMessageVoiceCellModel *)self.cellModel;
    
    self.currentChatModel = voiceCellFrameModel.messageModel;
    
    
    self.bubbleImageView.frame = voiceCellFrameModel.voiceBubbleFrame;
    
    
    self.voiceTimeNumLabel.frame = voiceCellFrameModel.voiceTimeNumLabelFrame;
    
    AVIMAudioMessage *audioM = (AVIMAudioMessage*)voiceCellFrameModel.messageModel.content;
    self.voiceTimeNumLabel.text = [NSString stringWithFormat:@"%.0f'",audioM.duration];
    
    UIImageView *waveImageView = [voiceCellFrameModel messageVoiceAnimationImageViewWithBubbleMessageType:(audioM.ioType != AVIMMessageIOTypeIn)];
    [self.voiceWaveImageView removeFromSuperview];
    [self.bubbleImageView addSubview:waveImageView];
    waveImageView.frame = voiceCellFrameModel.voiceWaveImageFrame;
    self.voiceWaveImageView = waveImageView;
}



///声音波动图
- (UIImageView *)voiceWaveImageView {
    if (!_voiceWaveImageView) {
        _voiceWaveImageView = [[UIImageView alloc] init];
        _voiceWaveImageView.backgroundColor = [UIColor clearColor];
        _voiceWaveImageView.userInteractionEnabled = YES;
    }
    return _voiceWaveImageView;
}
///声音时长
- (UILabel *)voiceTimeNumLabel {
    if (!_voiceTimeNumLabel) {
        _voiceTimeNumLabel = [[UILabel alloc] init];
        _voiceTimeNumLabel.font = [UIFont systemFontOfSize:14];
        _voiceTimeNumLabel.textColor = [UIColor blackColor];
    }
    return _voiceTimeNumLabel;
}
@end
