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
        //[self scrollBackToMessageBottom];
        
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
#pragma mark -  GestureRecognizer Action
#pragma mark -  Btn Click
#pragma mark -  Private Methods
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
    [self rr_initTitleView:self.conversation.name];
    [self.view addSubview:self.tableView];
    
    
    
    WBChatBarView *keyBoard = [[WBChatBarView alloc] initWithFrame:CGRectMake(0, kWBScreenHeight - 48 - WB_NavHeight - WB_IPHONEX_BOTTOM_SPACE,
                                                                        kWBScreenWidth, 48)];
    [self.view addSubview:keyBoard];
    self.chatBar = keyBoard;
    self.chatBar.delegate = self;
    
    //3,缩小tableView的高度
    self.tableView.height_wb = self.chatBar.top_wb;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
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

