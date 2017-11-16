//
//  RRLoginController.m
//  Whiteboard
//
//  Created by RedRain on 2017/11/5.
//  Copyright © 2017年 RedRain. All rights reserved.
//

#import "WBLoginController.h"
#import "WBRegisterController.h"
#import "WBConfig.h"

@interface WBLoginController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@end

@implementation WBLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -  Life Cycle
#pragma mark -  UITableViewDelegate
#pragma mark -  CustomDelegate
#pragma mark -  Event Response

- (IBAction)loginBtnClick:(id)sender {
    
    if (![UITools isValidateEmail:self.userNameTextField.text]) {
        [WBHUD showErrorMessage:@"请输入正确的邮箱地址" toView:self.view];
        return;
    }
    if (![UITools isValidatePassWord:self.passwordTextField.text]) {
        [WBHUD showErrorMessage:@"密码必须是8-16位数字、字符组合" toView:self.view];
        return;
    }
    
    
    [WBHUD showMessage:@"登录中" toView:self.view];
    
//    [AVUser logInWithUsernameInBackground:self.userNameTextField.text
//                                 password:self.passwordTextField.text
//                                    block:^(AVUser *user, NSError *error)
//    {
//
//        if (user != nil) {
//            [WBHUD showSuccessMessage:@"成功" toView:self.view];
//            [WBModuleControl exchangeWindowRootControllerWithUserModel:user];
//        } else {
//            WBLog(@"%@",error);
//            [WBHUD showErrorMessage:error.localizedDescription toView:self.view];
//        }
//        
//    }];
    
    
}
- (IBAction)registerBtnClick:(id)sender {
    [self presentViewController:[[WBNavigationController alloc] initWithRootViewController:[WBRegisterController new]]
                       animated:YES
                     completion:nil]; ;
    
}

#pragma mark -  Private Methods
#pragma mark -  Public Methods
#pragma mark -  Getters and Setters

@end
