//
//  WBChatViewController.m
//  WBChat
//
//  Created by RedRain on 2018/1/16.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import "WBChatViewController.h"
#import "WBChatMessageBaseCell.h"

@interface WBChatViewController ()
@property (nonatomic, strong) AVIMConversation *conversation;
@property (nonatomic, strong) NSMutableArray<WBChatMessageBaseCellModel *> *dataArray;
@end

@implementation WBChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    [[WBChatKit sharedInstance] queryTypedMessagesWithConversation:self.conversation
                                                      queryMessage:nil
                                                             limit:20
                                                           success:^(NSArray<AVIMTypedMessage *> * messageArray)
     {
         NSMutableArray *temp = [NSMutableArray new];
         
         for (AVIMTypedMessage *message in messageArray) {
             WBChatMessageBaseCellModel *cellModel = [WBChatMessageBaseCellModel modelWithMessageModel:message];
             [temp addObject:cellModel];
        }
         
         self.dataArray = temp;
         [self.tableView reloadData];
         
     } error:^(NSError * _Nonnull error) {
         
     }];

}

#pragma mark -  Life Cycle
#pragma mark -  UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WBChatMessageBaseCell *cell = [WBChatMessageBaseCell cellWithTableView:tableView
                                                                 cellModel:self.dataArray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    WBChatMessageBaseCellModel *cellModel = self.dataArray[indexPath.row];
    return cellModel.cellHeight;
}


#pragma mark -  CustomDelegate
#pragma mark -  Event Response
#pragma mark -  Notification Callback
#pragma mark -  GestureRecognizer Action
#pragma mark -  Btn Click
#pragma mark -  Private Methods
- (void)setupUI{
    [self rr_initTitleView:self.conversation.name];
    [self.view addSubview:self.tableView];
}
#pragma mark -  Public Methods
+ (instancetype)createWithConversation:(AVIMConversation *)conversation{
    WBChatViewController *vc = [WBChatViewController new];
    vc.conversation = conversation;
    return vc;
}

#pragma mark -  Getters and Setters
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}
@end

