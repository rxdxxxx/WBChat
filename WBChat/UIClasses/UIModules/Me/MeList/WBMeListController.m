//
//  WBMeListController.m
//  WBChat
//
//  Created by RedRain on 2017/11/17.
//  Copyright © 2017年 RedRain. All rights reserved.
//

#import "WBMeListController.h"
#import "UIViewController+NavBarItemExtension.h"
#import "WBModuleControl.h"
@interface WBMeListController ()

@end

@implementation WBMeListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self rr_initTitleView:@"我"];
    
    [self rr_initNavRightBtnWithTitle:@"退出" target:self
                               action:@selector(logOut)];

    UILabel *name = [[UILabel alloc] init];
    name.text = [AVUser currentUser].username;
    [name sizeToFit];
    name.centerX_wb = self.view.centerX_wb;
    name.centerY_wb = self.view.centerY_wb;
    [self.view addSubview:name];
}
- (void)logOut{
    [WBModuleControl quit];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
