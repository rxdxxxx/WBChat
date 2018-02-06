//
//  WBChatMessageVoiceCellModel.h
//  WBChat
//
//  Created by RedRain on 2018/2/6.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import "WBChatMessageBaseCellModel.h"

@interface WBChatMessageVoiceCellModel : WBChatMessageBaseCellModel

@property (nonatomic, assign) CGRect voiceWaveImageFrame;
@property (nonatomic, assign) CGRect voiceTimeNumLabelFrame;
@property (nonatomic, assign) CGRect voiceBubbleFrame;


- (UIImageView *)messageVoiceAnimationImageViewWithBubbleMessageType:(BOOL)owner;
@end
