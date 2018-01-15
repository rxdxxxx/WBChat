//
//  WBChatListController.m
//  WBChat
//
//  Created by RedRain on 2017/11/17.
//  Copyright © 2017年 RedRain. All rights reserved.
//

#import "WBChatListController.h"
#import "WBChatListCell.h"

@interface WBChatListController ()
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation WBChatListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    
    

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[ChatManager sharedInstance] list:^(NSArray<AVIMConversation *> * _Nullable objects, NSError * _Nullable error) {
        NSMutableArray *tempA = [NSMutableArray arrayWithCapacity:objects.count];
        for (AVIMConversation *obj in objects) {
            WBChatListCellModel *cellModel = [WBChatListCellModel new];
            cellModel.dataModel = obj;
            [tempA addObject:cellModel];
        }
        self.dataArray = tempA;
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [self.tableView reloadData];
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -  Life Cycle
#pragma mark -  UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WBChatListCell *cell = [WBChatListCell cellWithTableView:tableView];
    cell.cellModel = self.dataArray[indexPath.row];
    return cell;
}

#pragma mark -  CustomDelegate
#pragma mark -  Event Response
#pragma mark -  Notification Callback
#pragma mark -  GestureRecognizer Action
#pragma mark -  Btn Click
#pragma mark -  Private Methods
- (void)setupUI{
    self.title = @"聊呗";

    [self.view addSubview:self.tableView];
    self.tableView.rowHeight = [WBChatListCell cellHeight];
    
}
#pragma mark -  Public Methods
#pragma mark -  Getters and Setters
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}
@end
