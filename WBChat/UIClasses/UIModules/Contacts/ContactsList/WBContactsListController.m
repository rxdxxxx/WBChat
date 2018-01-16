//
//  WBContactsListController.m
//  WBChat
//
//  Created by RedRain on 2017/11/17.
//  Copyright © 2017年 RedRain. All rights reserved.
//

#import "WBContactsListController.h"
#import "WBSearchContactsController.h"

@interface WBContactsListController ()

@end

@implementation WBContactsListController
#pragma mark -  Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self rr_initTitleView:@"联系人"];
    [self rr_initNavRightBtnWithImageName:@"ico_nav_add" target:self action:@selector(navRightBtnClick)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -  UITableViewDelegate
#pragma mark -  CustomDelegate
#pragma mark -  Event Response
#pragma mark -  Btn Click
- (void)navRightBtnClick{
//    [[ChatManager sharedInstance].client createConversationWithName:@"猫和老鼠"
//                                                          clientIds:@[@"Jerry"]
//                                                           callback:^(AVIMConversation *conversation, NSError *error)
//    {
//        NSString *text = [NSString stringWithFormat:@"%@,hello",[NSDate date]];
//    
//        [conversation sendMessage:[AVIMTextMessage messageWithText:text attributes:nil] callback:^(BOOL succeeded, NSError *error) {
//            if (succeeded) {
//                WBLog(@"发送成功！");
//            }
//        }];
//    }];
    
    
//    WBSearchContactsController *vc = [WBSearchContactsController new];
//    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -  Private Methods
- (void)setupUI{
    
}
#pragma mark -  Public Methods
#pragma mark -  Getters and Setters
@end
