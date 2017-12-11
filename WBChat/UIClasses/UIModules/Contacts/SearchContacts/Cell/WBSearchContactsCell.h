//
//  WBSearchContactsCell.h
//  WBChat
//
//  Created by RedRain on 2017/11/17.
//  Copyright © 2017年 RedRain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBSearchContactsCell : UITableViewCell
/**
 创建cell, cell的复用逻辑已经实现, 使用类名作为唯一标识ID
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
