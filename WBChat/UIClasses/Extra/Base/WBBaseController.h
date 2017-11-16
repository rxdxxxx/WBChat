//
//  RRBaseController.h
//  Whiteboard
//
//  Created by RedRain on 2017/11/5.
//  Copyright © 2017年 RedRain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+NavBarItemExtension.h"
#import "WBNavigationController.h"
#import "WBTableEmptyView.h"
#import "WBConfig.h"

@interface WBBaseController : UIViewController<UITableViewDataSource,UITableViewDelegate,WBTableEmptyViewDelegate>

@property (nonatomic, strong) WBTableEmptyView *tableEmptyView;
@property (nonatomic, strong) UITableView *tableView;

@end
