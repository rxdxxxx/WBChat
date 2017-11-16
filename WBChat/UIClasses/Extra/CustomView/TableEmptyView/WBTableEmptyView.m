//
//  WBTableEmptyView.m
//  Whiteboard
//
//  Created by RedRain on 2017/11/7.
//  Copyright © 2017年 RedRain. All rights reserved.
//

#import "WBTableEmptyView.h"

@interface WBTableEmptyView ()
@property (weak, nonatomic) IBOutlet UIButton *actionBtn;

@end

@implementation WBTableEmptyView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)btnActionClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(tableEmptyViewDidClickAction:)]) {
        [self.delegate tableEmptyViewDidClickAction:self];
    }
    
    
}


- (void)resetActionBtnTitleWithString:(NSString *)titleString{
    [self.actionBtn setTitle:titleString forState:(UIControlStateNormal)];
}

@end
