//
//  WBChatBaseViewController.m
//  WBChat
//
//  Created by RedRain on 2018/1/16.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import "WBChatBaseViewController.h"

@interface WBChatBaseViewController ()
@property (nonatomic, strong) AVIMConversation *conversation;
@property (nonatomic, strong) NSMutableArray<AVIMTypedMessage *> *dataArray;
@end

@implementation WBChatBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    [[WBChatKit sharedInstance] queryTypedMessagesWithConversation:self.conversation
                                                      queryMessage:nil
                                                             limit:20
                                                             block:^(NSArray * _Nullable messageArray, NSError * _Nullable error)
    {
        self.dataArray = [NSMutableArray arrayWithArray:messageArray];
        [self.tableView reloadData];
    }];
}

#pragma mark -  Life Cycle
#pragma mark -  UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:@"KEy"];
    cell.textLabel.text = self.dataArray[indexPath.row].content;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
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
    WBChatBaseViewController *vc = [WBChatBaseViewController new];
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
