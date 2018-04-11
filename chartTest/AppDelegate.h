//
//  AppDelegate.h
//  chartTest
//
//  Created by Bletc on 16/8/24.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/*
 * 登录成功
 */
- (void)loginSuccess;

/*
 * 退出登录成功
 */
- (void)logoutSuccess;

@end

