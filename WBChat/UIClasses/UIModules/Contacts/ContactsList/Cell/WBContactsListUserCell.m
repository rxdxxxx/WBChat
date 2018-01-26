//
//  WBContactsListUserCell.m
//  WBChat
//
//  Created by RedRain on 2018/1/26.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import "WBContactsListUserCell.h"
#import "WBConfig.h"
@interface WBContactsListUserCell ()


@end

@implementation WBContactsListUserCell
#pragma mark -  Life Cycle

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"WBContactsListUserCell";
    WBContactsListUserCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[WBContactsListUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.userHeaderImageView];
        [self.contentView addSubview:self.userNameLabel];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat headerWH = 30;
    self.userHeaderImageView.frame = CGRectMake(8, (self.height_wb - headerWH) / 2, headerWH, headerWH);
    
    CGFloat labelX = self.userHeaderImageView.right_wb + 10;
    CGFloat labelH = 30;
    self.userNameLabel.frame = CGRectMake(labelX , (self.height_wb - labelH) / 2, self.width_wb - labelX - 10 , labelH);
}

#pragma mark -  CustomDelegate
#pragma mark -  Event Response
#pragma mark -  Notification Callback
#pragma mark -  GestureRecognizer Action
#pragma mark -  Btn Click
#pragma mark -  Private Methods


#pragma mark -  Public Methods
#pragma mark -  Getters and Setters
- (UIImageView *)userHeaderImageView{
    if (!_userHeaderImageView) {
        _userHeaderImageView = [[UIImageView alloc] init];
        _userHeaderImageView.contentMode = UIViewContentModeScaleAspectFill;
        _userHeaderImageView.layer.masksToBounds = YES;
    }
    return _userHeaderImageView;
}
- (UILabel *)userNameLabel{
    if (!_userNameLabel) {
        _userNameLabel = [[UILabel alloc] init];
    }
    return _userNameLabel;
}

@end
