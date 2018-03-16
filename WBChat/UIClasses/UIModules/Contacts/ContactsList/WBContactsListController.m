//
//  WBContactsListController.m
//  WBChat
//
//  Created by RedRain on 2017/11/17.
//  Copyright © 2017年 RedRain. All rights reserved.
//

#import "WBContactsListController.h"
#import "WBSearchContactsController.h"
#import "WBContactsListUserCell.h"
#import "WBChatViewController.h"
#import "UIViewController+NavBarItemExtension.h"

@interface WBContactsListController ()
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation WBContactsListController
#pragma mark -  Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self rr_initTitleView:@"联系人"];
    [self rr_initNavRightBtnWithImageName:@"ico_nav_add" target:self action:@selector(navRightBtnClick)];
    [self setupUI];
    AVQuery *userQuery = [AVQuery queryWithClassName:@"_User"];
    AVUser *currentUser = [AVUser currentUser];
    NSMutableArray *temp = [NSMutableArray new];
    [userQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (AVUser *user in objects) {
                if ([user.objectId isEqualToString:currentUser.objectId]) {
                    continue;
                }
                [temp addObject:user];
            }
            self.dataArray = temp;
            [self.tableView reloadData];
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
    self.tableView.height_wb -= WB_TabBarHeight;
}

#pragma mark -  UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WBContactsListUserCell *cell = [WBContactsListUserCell cellWithTableView:tableView];
    AVUser *user = self.dataArray[indexPath.row];
    cell.userNameLabel.text = user.username;
    cell.userHeaderImageView.image = [UIImage wb_userHeaderPlaceholderImage];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AVUser *user = self.dataArray[indexPath.row];
    [self tableDidSelectUser:user];
}
#pragma mark -  CustomDelegate
#pragma mark -  Event Response
#pragma mark -  Btn Click
- (void)tableDidSelectUser:(AVUser *)user{
    
    [[WBChatKit sharedInstance] createConversationWithName:user.username members:@[user.objectId]
                                                   success:^(AVIMConversation * _Nonnull convObj)
    {


        WBChatViewController *vc = [WBChatViewController createWithConversation:convObj];
        [self.navigationController pushViewController:vc animated:YES];

    } error:^(NSError * _Nonnull error) {
        [WBHUD showErrorMessage:error.wb_localizedDesc toView:self.view];

    }];
    
}
- (void)navRightBtnClick{
    
}
#pragma mark -  Private Methods
- (void)setupUI{
    [self.view addSubview:self.tableView];
}
#pragma mark -  Public Methods
#pragma mark -  Getters and Setters
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}
@end
