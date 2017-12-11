//
//  WBSearchContactsCell.m
//  WBChat
//
//  Created by RedRain on 2017/11/17.
//  Copyright © 2017年 RedRain. All rights reserved.
//

#import "WBSearchContactsCell.h"

@interface WBSearchContactsCell()

@property (weak, nonatomic) IBOutlet UIImageView *userHeaderImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;


@end

@implementation WBSearchContactsCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"WBSearchContactsCell";
    WBSearchContactsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        UINib * nib = [UINib nibWithNibName:@"WBSearchContactsCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:ID];
        cell = [[nib instantiateWithOwner:self options:nil] lastObject];
        
        
        //cell = [[XMSettingItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    return cell;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
