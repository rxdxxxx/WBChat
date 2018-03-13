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
#import "WBSelectPhotoTool.h"
#import "WBChatMessageTimeCellModel.h"
#import "UIScrollView+WBRefresh.h"
#import "WBImageBrowserView.h"

@interface WBChatViewController ()<WBChatBarViewDelegate,WBChatBarViewDataSource,WBSelectPhotoToolDelegate,WBChatMessageCellDelegate>
@property (nonatomic, strong) AVIMConversation *conversation;
@property (nonatomic, strong) NSMutableArray<WBChatMessageBaseCellModel *> *dataArray;
@property (nonatomic, strong) WBChatBarView *chatBar;
@property (nonatomic, strong) WBSelectPhotoTool *photoTool;
@property (nonatomic, strong) WBImageBrowserView *pictureBrowserView;
@end

@implementation WBChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    
    [self loadMoreMessage];
    [self.tableView wb_scrollToBottomAnimated:NO];
    

    __weak typeof(self)weakSelf = self;
    [self.tableView wb_addRefreshHeaderViewWithBlock:^{
        [weakSelf loadMoreMessage];

    }];
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[WBChatKit sharedInstance] readConversation:self.conversation];
    WBChatInfoModel *infoModel = [[WBChatKit sharedInstance] chatInfoWithID:self.conversation.conversationId];
    self.chatBar.chatText = infoModel.draft;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    [[WBChatKit sharedInstance] readConversation:self.conversation];
    BOOL restlt = [[WBChatKit sharedInstance] saveConversation:self.conversation.conversationId draft:self.chatBar.chatText];
    
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
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    WBChatMessageBaseCellModel *cellModel = self.dataArray[indexPath.row];
    return cellModel.cellHeight;
}

#pragma mark -  UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
    
    [self.chatBar stateToInit];
    
    if ([[UIMenuController sharedMenuController] isMenuVisible]) {
        [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
    }
}

#pragma mark -  CustomDelegate
#pragma mark - WBImageBrowserViewDelegate
#pragma mark - WBChatMessageCellDelegate
- (void)cell:(WBChatMessageBaseCell *)cell tapImageViewModel:(WBChatMessageBaseCellModel *)cellModel{
    
    NSMutableArray *imageMessageArray = [NSMutableArray array];
    for (WBChatMessageBaseCellModel *cellModel in self.dataArray) {
        if (cellModel.cellType == WBChatCellTypeImage) {
            [imageMessageArray addObject:cellModel.messageModel];
        }
    }
    
    WBImageBrowserView *pictureBrowserView = [WBImageBrowserView browserWithImageArray:imageMessageArray];
    pictureBrowserView.startIndex = [imageMessageArray indexOfObject:cellModel.messageModel] + 1;  //开始索引
}

- (void)cell:(WBChatMessageBaseCell *)cell resendMessage:(WBChatMessageBaseCellModel *)cellModel{
    [self.dataArray removeObject:cellModel];
    [self sendMessage:cellModel.messageModel];
}

#pragma mark - WBChatBarViewDataSource
- (NSArray<NSDictionary *> *)plusBoardItemInfos:(WBChatBarView *)keyBoardView{
    return @[PlusBoardItemDicInfo([UIImage wb_resourceImageNamed:@"chat_bar_icons_pic"],@"相册",@(WBPlusBoardButtonTypePhotoAlbum)),
             PlusBoardItemDicInfo([UIImage wb_resourceImageNamed:@"chat_bar_icons_camera"],@"相机",@(WBPlusBoardButtonTypeCamera))];
    
    //    PlusBoardItemDicInfo([UIImage wb_resourceImageNamed:@"chat_bar_icons_location"],@"位置",@(WBPlusBoardButtonTypeLocation))
}

#pragma mark - WBChatBarViewDelegate
- (void)chatBar:(WBChatBarView *)chatBar didSelectItemInfo:(NSDictionary *)itemInfo{
    switch ([itemInfo[kPlusBoardType] integerValue]) {
        case WBPlusBoardButtonTypePhotoAlbum:{
            [self.photoTool visitPhotoLibraryInController:self];
        }
            break;
        case WBPlusBoardButtonTypeCamera:{
            [self.photoTool visitCameraInController:self];
        }
            break;
        case WBPlusBoardButtonTypeLocation:{
            
        }
            break;
            
        default:
            break;
    }
}

- (void)chatBar:(WBChatBarView *)keyBoardView sendText:(NSString *)sendText{
    if (sendText.length > 0) {
        
        WBMessageModel *message = [WBMessageModel createWithText:sendText];
        [self sendMessage:message];
    }
}
- (void)chatBar:(WBChatBarView *)keyBoardView recoderAudioPath:(NSString *)audioPath duration:(NSNumber *)duration{
    
    WBMessageModel *message = [WBMessageModel createWithAudioPath:audioPath duration:duration];
    [self sendMessage:message];
}

#pragma mark - WBSelectPhotoToolDelegate

- (void)toolWillSelectImage:(WBSelectPhotoTool *)tool{
    
}

- (void)tool:(WBSelectPhotoTool *)tool didSelectImage:(UIImage *)image{
    WBMessageModel *message = [WBMessageModel createWithImage:image];
    [self sendMessage:message];
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
- (void)loadMoreMessage{
    
    AVIMMessage *lastMessage = nil;
    for (WBChatMessageBaseCellModel *cellModel in self.dataArray) {
        if (cellModel.messageModel.content != nil) {
            lastMessage = cellModel.messageModel.content;
            break;
        }
    }
    
    [[WBChatKit sharedInstance] queryTypedMessagesWithConversation:self.conversation
                                                      queryMessage:lastMessage
                                                             limit:20
                                                           success:^(NSArray<WBMessageModel *> * messageArray)
     {
         
         NSMutableArray *temp = [NSMutableArray new];
         for (WBMessageModel *message in messageArray) {
             WBChatMessageBaseCellModel *cellModel = [WBChatMessageBaseCellModel modelWithMessageModel:message];
             [temp addObject:cellModel];
         }
         
         NSMutableArray *newLoadMessage = [self appendTimerStampIntoMessageArray:temp];
         
         NSUInteger loadMoreMessageCount = newLoadMessage.count;
         
         if (self.dataArray.count) {
             [newLoadMessage addObjectsFromArray:self.dataArray];
             self.dataArray = newLoadMessage;
             [self.tableView reloadData];
             [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:loadMoreMessageCount inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
             
         }else{
             self.dataArray = newLoadMessage;
             [self.tableView reloadData];
             [self.tableView wb_scrollToBottomAnimated:NO];
         }
         
         [self.tableView wb_endRefreshing];
         
     } error:^(NSError * _Nonnull error) {
         
     }];
}

- (void)sendMessage:(WBMessageModel *)message{
    
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
    NSMutableArray *messagesArray = [[NSMutableArray alloc]initWithCapacity:20];

    WBChatMessageBaseCellModel *cellModel = [WBChatMessageBaseCellModel modelWithMessageModel:aMessage];
    
    // 如果没有消息, 增加一个时间
    if (self.dataArray.count == 0) {
        WBChatMessageTimeCellModel *timeFM = [WBChatMessageTimeCellModel modelWithTimeStamp:cellModel.cellTimeStamp];
        [messagesArray addObject:timeFM];
    }
    
    // 如果有消息, 和上一条消息的时间间隔
    else{
        WBChatMessageBaseCellModel *lastCellModel = self.dataArray.lastObject;
        
        BOOL timeOffset = [NSDate wb_miniteInterval:3 firstTime:cellModel.cellTimeStamp secondTime:lastCellModel.cellTimeStamp];
        if (timeOffset) {
            WBChatMessageTimeCellModel *timeFM = [WBChatMessageTimeCellModel modelWithTimeStamp:cellModel.cellTimeStamp];
            [messagesArray addObject:timeFM];
        }
    }
    [messagesArray addObject:cellModel];

    [self.dataArray addObjectsFromArray:messagesArray];
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

- (NSMutableArray *)appendTimerStampIntoMessageArray:(NSArray *)localMessages{
    
    NSMutableArray *messagesArray = [[NSMutableArray alloc]initWithCapacity:20];
    
    if (localMessages.count == 0) {
        return messagesArray;
    }
    
    //当前会话中的消息<kNum条
    for (NSInteger i = 0; i < localMessages.count; i++) {
        
        WBChatMessageBaseCellModel *firstModel = localMessages[i];
        
        //第一条消息的时间和第一条数据插入数组
        if (messagesArray.count <= 0) {
            
            WBChatMessageTimeCellModel *timeFM = [WBChatMessageTimeCellModel modelWithTimeStamp:firstModel.cellTimeStamp];
            [messagesArray addObject:timeFM];
            
            [messagesArray addObject:firstModel];
            
        }
        
        //比较当前消息和下一条消息的时间
        NSInteger j = i + 1;
        if(j < localMessages.count){
            
            WBChatMessageBaseCellModel *secondModel = localMessages[j];
            
            // 3.1,处理时间
            //判断两条会话时间，是否在3分钟
            BOOL timeOffset = [NSDate wb_miniteInterval:3 firstTime:firstModel.cellTimeStamp secondTime:secondModel.cellTimeStamp];
            if (timeOffset) {
                WBChatMessageTimeCellModel *timeFM = [WBChatMessageTimeCellModel modelWithTimeStamp:secondModel.cellTimeStamp];
                [messagesArray addObject:timeFM];
            }
            [messagesArray addObject:secondModel];
        }
    }
    
    return messagesArray;
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
    self.chatBar.dataSource = self;
    
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

- (WBSelectPhotoTool *)photoTool{
    if (!_photoTool) {
        _photoTool = [WBSelectPhotoTool new];
        _photoTool.delegate = self;
    }
    return _photoTool;
}
@end

