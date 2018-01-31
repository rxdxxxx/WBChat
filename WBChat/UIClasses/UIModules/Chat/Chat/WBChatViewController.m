//
//  WBChatViewController.m
//  WBChat
//
//  Created by RedRain on 2018/1/16.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import "WBChatViewController.h"
#import "WBChatMessageBaseCell.h"
#import "WBChatBarView.h"
#import "UITableView+WBScrollToIndexPath.h"

@interface WBChatViewController ()<WBChatBarViewDelegate>
@property (nonatomic, strong) AVIMConversation *conversation;
@property (nonatomic, strong) NSMutableArray<WBChatMessageBaseCellModel *> *dataArray;
@property (nonatomic, strong) WBChatBarView *chatBar;
@end

@implementation WBChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    [[WBChatKit sharedInstance] queryTypedMessagesWithConversation:self.conversation
                                                      queryMessage:nil
                                                             limit:20
                                                           success:^(NSArray<WBMessageModel *> * messageArray)
     {
         NSMutableArray *temp = [NSMutableArray new];
         
         for (WBMessageModel *message in messageArray) {
             
             WBChatMessageBaseCellModel *cellModel = [WBChatMessageBaseCellModel modelWithMessageModel:message];
             [temp addObject:cellModel];
        }
         
         self.dataArray = temp;
         [self.tableView reloadData];
         [self.tableView wb_scrollToBottomAnimated:NO];
         
     } error:^(NSError * _Nonnull error) {
         
     }];
    [self.tableView wb_scrollToBottomAnimated:NO];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[WBChatKit sharedInstance] readConversation:self.conversation];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    [[WBChatKit sharedInstance] readConversation:self.conversation];
}



- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
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

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
    
    if ([[UIMenuController sharedMenuController] isMenuVisible]) {
        [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
    }
}

#pragma mark -  CustomDelegate
#pragma mark - WBChatBarViewDelegate
- (void)chatBar:(WBChatBarView *)keyBoardView sendText:(NSString *)sendText{
    if (sendText.length > 0) {
        
        WBMessageModel *message = [WBMessageModel createWithText:sendText];
        [self appendAMessageToTableView:message];
        
        // 2.1 滚动tableVeiw的代码放在了消息状态变化的通知里面了.不然此处会发生体验不好.
        [self.tableView wb_scrollToBottomAnimated:NO];
        
        [[WBChatKit sharedInstance] sendTargetConversation:self.conversation
                                                   message:message
                                                   success:^(WBMessageModel * _Nonnull aMessage)
        {
            
            [self refershAMessageState:aMessage];
            
        } error:^(WBMessageModel * _Nonnull aMessage, NSError * _Nonnull error) {
            
            [self refershAMessageState:aMessage];
            
        }];
        
    }
}


#pragma mark -  Event Response
#pragma mark -  Notification Callback

/**
 *  键盘即将显示的时候调用
 */
- (void)keyboardWillShow:(NSNotification *)note {
    
    // 1.取出键盘弹出的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    
    // 2.执行动画4
    [UIView animateWithDuration:duration animations:^{
        
        //3,缩小tableView的高度
        self.tableView.height_wb = self.chatBar.top_wb ;
        
        // 4,让tableView偏移到最底部.
        [self scrollBackToMessageBottom];
        
    } ];
    
    
}

/**
 *  键盘即将退出的时候调用
 */
- (void)keyboardWillHide:(NSNotification *)note {
    
    // 1.取出键盘弹出的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 2.执行动画
    [UIView animateWithDuration:duration animations:^{
        
        
        //3,缩小tableView的高度
        self.tableView.height_wb = self.chatBar.top_wb;
        
    }];
    
}


- (void)receiveNewMessgae:(NSNotification *)noti{
    AVIMConversation *conv = noti.userInfo[WBMessageConversationKey];
    AVIMTypedMessage *tMsg = noti.userInfo[WBMessageMessageKey];

    if (![conv.conversationId isEqualToString:self.conversation.conversationId]) {
        return;
    }
    
    
    if (tMsg)
    {
        // 把收到的消息加入列表,并刷新
        do_dispatch_async_mainQueue(^{
            BOOL isBottom = [self isTableViewBottomVisible];

            WBMessageModel *message = [WBMessageModel createWIthTypedMessage:tMsg];
            [self appendAMessageToTableView:message];
            
            if (isBottom) {
                // 此处动画,需要是NO,不然tableView会乱蹦.导致不能显示到最后一行.
                [self.tableView wb_scrollToBottomAnimated:NO];
            }
            
            BOOL isActive = [UIApplication sharedApplication].applicationState == UIApplicationStateActive;
            // 栈顶的控制器, 是不是当前控制器.
            if (isActive && self == self.navigationController.topViewController){
                // 清除未读记录信息
                [[WBChatKit sharedInstance] readConversation:self.conversation];
            }
        });
        
    }

}
#pragma mark -  GestureRecognizer Action
#pragma mark -  Btn Click
#pragma mark -  Private Methods
- (void)scrollBackToMessageBottom{
    
    [self.tableView wb_scrollToBottomAnimated:NO];
}
- (BOOL)isTableViewBottomVisible{
    BOOL isScroolBottom = NO;
    
    if (self.tableView.visibleCells.count == 0) {
        return YES;
    }
    
    if (self.tableView.visibleCells.count &&
        ([self.tableView.visibleCells.lastObject isKindOfClass:[WBChatMessageBaseCell class]])) {
        
        
        WBChatMessageBaseCellModel* lastFrameModel =((WBChatMessageBaseCell*)self.tableView.visibleCells.lastObject).cellModel;
        if ( lastFrameModel == self.dataArray.lastObject) {
            isScroolBottom = YES;
        }
        
    }
    return isScroolBottom;
}
- (void)appendAMessageToTableView:(WBMessageModel *)aMessage{

    WBChatMessageBaseCellModel *cellModel = [WBChatMessageBaseCellModel modelWithMessageModel:aMessage];
    [self.dataArray addObject:cellModel];
    [self.tableView reloadData];
}

- (void)refershAMessageState:(WBMessageModel *)aMessage{
    for (NSInteger i = self.dataArray.count - 1; i >=0 ; i--) {
        WBChatMessageBaseCellModel *cellModel = self.dataArray[i];
        if (cellModel.messageModel == aMessage) {
//            NSInteger index = [self.dataArray indexOfObject:cellModel];
            [self.tableView reloadData];
            break;
        }
    }
}

- (void)setupUI{
    
    [self.view addSubview:self.tableView];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    
    
    WBChatBarView *keyBoard = [[WBChatBarView alloc] initWithFrame:CGRectMake(0, kWBScreenHeight - 48 - WB_NavHeight - WB_IPHONEX_BOTTOM_SPACE,
                                                                        kWBScreenWidth, 48)];
    [self.view addSubview:keyBoard];
    self.chatBar = keyBoard;
    self.chatBar.delegate = self;
    
    //3,缩小tableView的高度
    self.tableView.height_wb = self.chatBar.top_wb;
    
    
    [WBNotificationCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [WBNotificationCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [WBNotificationCenter addObserver:self selector:@selector(receiveNewMessgae:) name:WBMessageNewReceiveNotification object:nil];

    
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

