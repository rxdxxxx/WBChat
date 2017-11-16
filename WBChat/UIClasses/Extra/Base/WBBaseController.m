//
//  RRBaseController.m
//  Whiteboard
//
//  Created by RedRain on 2017/11/5.
//  Copyright © 2017年 RedRain. All rights reserved.
//

#import "WBBaseController.h"
#import "WBConfig.h"

@interface WBBaseController ()


@end

@implementation WBBaseController
- (void)dealloc{
    [WBNotificationCenter removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor wb_navigationBarColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //统一设置导航栏的返回按钮，如要改变，在控制器内设置覆盖
    if (self.navigationController.viewControllers.count  > 1) {
        [self rr_initGoBackButton];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -  Life Cycle
#pragma mark -  UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DefaultCell"];
}

#pragma mark -  CustomDelegate
- (void)tableEmptyViewDidClickAction:(WBTableEmptyView *)emptyView{
    
}
#pragma mark -  Event Response
#pragma mark -  Private Methods
#pragma mark -  Public Methods
#pragma mark -  Getters and Setters
- (UITableView *)tableView{
    if (!_tableView) {
        CGRect frame =[UIScreen mainScreen].bounds;
        _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];

        self.tableEmptyView.delegate = self;
        _tableView.backgroundView = self.tableEmptyView;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.autoresizingMask = UIViewAutoresizingNone;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        
        
    }
    return _tableView;
}

- (WBTableEmptyView *)tableEmptyView{
    
    if (!_tableEmptyView) {
        _tableEmptyView = [WBTableEmptyView lcg_viewFromXib];
        _tableEmptyView.hidden = YES;
    }
    return _tableEmptyView;
}

@end

