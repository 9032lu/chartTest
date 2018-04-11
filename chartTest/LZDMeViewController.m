//
//  LZDMeViewController.m
//  chartTest
//
//  Created by Bletc on 16/8/25.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "LZDMeViewController.h"

@interface LZDMeViewController ()

@end

@implementation LZDMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    // 添加一个退出登录按钮
    LZDButton *logoutBtn = [LZDButton creatLZDButton];
    logoutBtn.frame = CGRectMake(kWeChatPadding,  64, kWeChatScreenWidth - kWeChatPadding*2, kWeChatAllSubviewHeight);
    [logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [logoutBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.contentView addSubview:logoutBtn];
    // 退出登录
    // isUnbind 是否解绑  如果是主动退出那么 传 YES  被迫 传NO
    logoutBtn.block = ^(LZDButton *btn){

               
        [[EMClient sharedClient] asyncLogout:YES success:^{
            
            [[TKAlertCenter defaultCenter]postAlertWithMessage:@"退出登录成功"];
            [self.myAppDelegate logoutSuccess];

        } failure:^(EMError *aError) {
            NSLog(@"退出失败==%@",aError.errorDescription);
        }];
        
        
    };
}



@end
