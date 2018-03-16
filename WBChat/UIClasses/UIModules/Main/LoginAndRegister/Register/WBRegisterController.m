//
//  WBRegisterController.m
//  Whiteboard
//
//  Created by RedRain on 2017/11/5.
//  Copyright © 2017年 RedRain. All rights reserved.
//

#import "WBRegisterController.h"
#import "UIViewController+NavBarItemExtension.h"
#import <WBChatIMKit/WBChatIMKit.h>
@interface WBRegisterController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;

@end

@implementation WBRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self rr_initTitleView:@"注册"];
    [self rr_initGoBackButton];
    
}

- (void)rr_backAction:(UIButton *)button{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registerBtnClick:(id)sender {
    
    
    if (![WBTools isValidateEmail:self.userNameTextField.text]) {
        [WBHUD showErrorMessage:@"请输入正确的邮箱地址" toView:self.view];
        return;
    }
    
    if (![WBTools isValidatePassWord:self.passwordTextField.text]) {
        [WBHUD showErrorMessage:@"密码必须是8-16位数字、字符组合" toView:self.view];
        return;
    }
    
    if (![self.passwordTextField.text isEqualToString:self.confirmPasswordTextField.text]) {
        [WBHUD showErrorMessage:@"两次密码不一致" toView:self.view];
        return;
    }
    
    AVUser *user = [AVUser user];// 新建 AVUser 对象实例
    user.username = self.userNameTextField.text;// 设置用户名
    user.password =  self.passwordTextField.text;// 设置密码

    [WBHUD showMessage:@"注册中" toView:self.view];
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // 注册成功
            [WBHUD showSuccessMessage:@"注册成功" toView:self.view];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            // 失败的原因可能有多种，常见的是用户名已经存在。
            [WBHUD showErrorMessage:error.localizedDescription toView:self.view];
        }
    }];
    
}


@end
