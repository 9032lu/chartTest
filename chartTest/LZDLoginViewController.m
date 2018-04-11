//
//  LZDLoginViewController.m
//  chartTest
//
//  Created by Bletc on 16/8/25.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "LZDLoginViewController.h"
#import "AppDelegate.h"

@interface LZDLoginViewController ()<EMClientDelegate>

@end

@implementation LZDLoginViewController


/*
 * 自动登录: 登录成功之后,将用户名 和 密码 存储本地数据库中
 * 下次打开程序的时候直接取出本地数据库中账号 和 密码进行登录 appdelegate中操作
 * 环信已经帮我做好了  只需要设置一个属性就可以了
 * 属性应该是在登录成功之后设置
 */


- (void)viewDidLoad

{
    [super viewDidLoad];
    self.title = @"登录";
    
    // 用户名
    UILabel *userLbl = [[UILabel alloc]init];
    userLbl.frame = CGRectMake(20, 50, 60, 44);
    userLbl.text = @"用户名";
    [self.contentView addSubview:userLbl];
    
    // 用户名输入框
    UITextField *userFiled = [[UITextField alloc]init];
    userFiled.frame = CGRectMake(userLbl.right + 10, userLbl.top, 200, 44);
    userFiled.borderStyle = UITextBorderStyleRoundedRect;
    [self.contentView addSubview:userFiled];
    
    // 密码
    UILabel *pswLbl = [[UILabel alloc]init];
    pswLbl.frame = CGRectMake(20, userLbl.bottom + 20, 60, 44);
    pswLbl.text = @"密码";
    [self.contentView addSubview:pswLbl];
    
    // 密码输入框
    UITextField *pswFiled = [[UITextField alloc]init];
    pswFiled.frame = CGRectMake(pswLbl.right + 10, pswLbl.top, 200, 44);
    pswFiled.borderStyle = UITextBorderStyleRoundedRect;
    [self.contentView addSubview:pswFiled];
    
    // 登录按钮
    LZDButton *loginBtn = [LZDButton creatLZDButton];
    loginBtn.frame = CGRectMake(20, pswFiled.bottom + 20, 100, 44);
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.contentView addSubview:loginBtn];
    
    // 注册按钮
    LZDButton *registerBtn = [LZDButton creatLZDButton];
    registerBtn.frame = CGRectMake(loginBtn.right, pswFiled.bottom + 20, 100, 44);
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.contentView addSubview:registerBtn];
    
    // 注册事件处理
    registerBtn.block = ^(LZDButton *btn){
        if (userFiled.text.length == 0) {
            [[TKAlertCenter defaultCenter] postAlertWithMessage:@"用户名不能为空"];
            return ;
        }
        
        if (pswFiled.text.length == 0) {
            [[TKAlertCenter defaultCenter] postAlertWithMessage:@"密码不能为空"];
            return ;
        }
        // 注册
        //        BOOL isSuccess = [[EaseMob sharedInstance].chatManager registerNewAccount:userFiled.text password:pswFiled.text error:nil];
        //        if (isSuccess) {
        //            NSLog(@"注册成功");
        //        }
        
        //    //登录,之后设置自动登录
        //    EMError *error1 = [[EMClient sharedClient] loginWithUsername:@"wang1bao9qiang" password:@"123"];
        //    if (!error1)
        //    {
        //        [[EMClient sharedClient].options setIsAutoLogin:YES];
        //    }
        [[EMClient sharedClient]asyncRegisterWithUsername:userFiled.text  password:pswFiled.text success:^{
            NSLog(@"注册成功");
            [[TKAlertCenter defaultCenter] postAlertWithMessage:@"注册成功"];

            
        } failure:^(EMError *aError) {
            NSLog(@"注册失败==%@",aError.errorDescription);

        }];
        
        
    
        
            };
    
    
    // 登录事件处理
    loginBtn.block = ^(LZDButton *btn){
        if (userFiled.text.length == 0) {
            [[TKAlertCenter defaultCenter] postAlertWithMessage:@"用户名不能为空"];
            return ;
        }
        
        if (pswFiled.text.length == 0) {
            [[TKAlertCenter defaultCenter] postAlertWithMessage:@"密码不能为空"];
            return ;
        }
        // 方式一
        //        BOOL isSuccess = [[EaseMob sharedInstance].chatManager loginWithUsername:userFiled.text password:pswFiled.text error:nil];
        //        if (isSuccess) {
        //            NSLog(@"登录成功");
        //        }
        // 方式二
        //        [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:userFiled.text password:pswFiled.text];
        
        // 方式三
        //        [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:userFiled.text password:pswFiled.text completion:^(NSDictionary *loginInfo, EMError *error) {
        //            NSLog(@"loginInfo = %@",loginInfo);
        //            if (!error) {
        //                [[TKAlertCenter defaultCenter] postAlertWithMessage:@"登录成功"];
        //                [self.myAppDelegate loginSuccess];
        //
        //                // 设置自动登录
        //                [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
        //            }
        //        } onQueue:nil];
        
        //登录,之后设置自动登录
        
        [[EMClient sharedClient]asyncLoginWithUsername:userFiled.text password:pswFiled.text success:^{
            [[TKAlertCenter defaultCenter] postAlertWithMessage:@"登录成功"];
            [[EMClient sharedClient].options setIsAutoLogin:YES];

            [self.myAppDelegate loginSuccess];

            
        } failure:^(EMError *aError) {
            NSLog(@"登录失败==%@",aError.errorDescription);

            
        }];
        
    };
    
    // 添加代理
    
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
    

    
    
}

- (void)didLoginFromOtherDevice;
{
    NSLog(@"didLoginFromOtherDevice");
}

- (void)didRemovedFromServer;
{
    NSLog(@"didRemovedFromServer");
    
    
}
- (void)didAutoLoginWithError:(EMError *)aError{
    
    NSLog(@"didAutoLoginWithError====%@",aError.errorDescription);
}

    
    
@end
