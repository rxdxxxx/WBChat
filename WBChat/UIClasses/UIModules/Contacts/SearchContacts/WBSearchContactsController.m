//
//  WBSearchContactsController.m
//  WBChat
//
//  Created by RedRain on 2017/11/17.
//  Copyright © 2017年 RedRain. All rights reserved.
//

#import "WBSearchContactsController.h"
#import "WBSearchContactsCell.h"

@interface WBSearchContactsController ()

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;

@end

@implementation WBSearchContactsController
#pragma mark -  Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self rr_initTitleView:@"搜索联系人"];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    self.tableView.frame = self.view.bounds;
    self.tableView.top = self.searchTextField.height + 10;
    self.tableView.height = self.tableView.height - self.tableView.top;
}

#pragma mark -  UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WBSearchContactsCell *cell = [WBSearchContactsCell cellWithTableView:tableView];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 84;
}


#pragma mark -  CustomDelegate
#pragma mark -  Event Response

- (IBAction)searchBtnClick:(id)sender {
    [self.dataArray addObject:@""];
    [self.tableView reloadData];
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
