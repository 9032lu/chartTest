//
//  AppDelegate.m
//  chartTest
//
//  Created by Bletc on 16/8/24.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"


#import "MBProgressHUD+Add.h"
#import "LZDLoginViewController.h"
#import "LZDRootNavgationController.h"

#import "LZDContactViewController.h"
#import "LZDMeViewController.h"
#import "LZDConversationViewController.h"
@interface AppDelegate ()<EMClientDelegate,EMContactManagerDelegate>

@property (nonatomic , strong) LZDRootNavgationController *loginNav;// 登录控制器

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    LZDLoginViewController *loginVC = [[LZDLoginViewController alloc]init];
    self.loginNav = [[LZDRootNavgationController alloc]initWithRootViewController:loginVC];
    self.window.backgroundColor =[UIColor whiteColor];
    self.window.rootViewController = self.loginNav;
    


    //AppKey:注册的AppKey，详细见下面注释。
    //apnsCertName:推送证书名（不需要加后缀），详细见下面注释。
    
    EMOptions *options = [EMOptions optionsWithAppkey:@"1101#testrongyun"];
    options.apnsCertName = @"TestHuanXin";
    
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    
        
    //添加代理
    
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
    

    
    // 自动登录
    if ([[EMClient sharedClient].options isAutoLogin]) {
        [MBProgressHUD showMessag:@"正在登录" toView:self.window];
    }
    
    
        return YES;
}

/**
 *  登录成功
 */
-(void)loginSuccess{
    UITabBarController *tabbarCtr = [[UITabBarController alloc]init];
    LZDConversationViewController *conversationCtr = [[LZDConversationViewController alloc]init];
    LZDRootNavgationController *conversationNav = [[LZDRootNavgationController alloc]initWithRootViewController:conversationCtr];
    conversationCtr.tabBarItem.image = [UIImage imageNamed:@"tabbar_mainframe"];
    conversationCtr.tabBarItem.selectedImage = [UIImage imageNamed:@"tabbar_mainframeHL"];
    conversationCtr.title = @"会话列表";
    
    
    LZDContactViewController *contactCtr = [[LZDContactViewController alloc]init];
    LZDRootNavgationController *contactNav = [[LZDRootNavgationController alloc]initWithRootViewController:contactCtr];
    contactCtr.tabBarItem.image = [UIImage imageNamed:@"tabbar_contacts"];
    contactCtr.tabBarItem.selectedImage = [UIImage imageNamed:@"tabbar_contactsHL"];
    contactCtr.title = @"通讯录";
    
    
    LZDMeViewController *meCtr = [[LZDMeViewController alloc]init];
    LZDRootNavgationController *meNav = [[LZDRootNavgationController alloc]initWithRootViewController:meCtr];
    meCtr.tabBarItem.image = [UIImage imageNamed:@"tabbar_me"];
    meCtr.tabBarItem.selectedImage = [UIImage imageNamed:@"tabbar_meHL"];
    meCtr.title = @"我";
    
    tabbarCtr.viewControllers = @[conversationNav,contactNav,meNav];
    
    self.window.rootViewController = tabbarCtr;
}
/**
 *  退出登录
 */
-(void)logoutSuccess{
    self.window.rootViewController = self.loginNav;
    [EMClient sharedClient].options.isAutoLogin = NO;
}
- (void)didAutoLoginWithError:(EMError *)aError{
    
    if (!aError) {
        [MBProgressHUD hideAllHUDsForView:self.window animated:YES];
        // 切换控制器
        [self loginSuccess];
        
        
        NSLog(@"自动登录成功==%@",[[EMClient sharedClient] currentUsername]);
    }
    
}



-(void)didReceiveFriendInvitationFromUsername:(NSString *)aUsername message:(NSString *)aMessage{
    
    
    //    NSMutableDictionary *dic2 = [NSMutableDictionary dictionaryWithContentsOfFile:self.plistPath];
    NSDictionary *dic =[[NSUserDefaults standardUserDefaults]objectForKey:@"FriendRequest"];
    
    NSMutableDictionary *dic2 = [NSMutableDictionary dictionaryWithDictionary:dic];
    if (!dic2) {
        dic2= [NSMutableDictionary dictionary];
    }
    
    //    NSMutableDictionary *dic2= [NSMutableDictionary dictionary];
    NSLog(@"dic =%@",dic2);
    //    //没有数据的时候创建一个文件
    //    if (dic2 ==nil) {
    //        NSFileManager *fm =  [NSFileManager defaultManager];
    //
    //        [fm createFileAtPath:self.plistPath contents:nil attributes:nil];
    //    }
    //    //写入文件
    
    [dic2 setObject:@{@"userName":aUsername,@"message":aMessage} forKey:aUsername];
    
    //    [dic2 writeToFile:self.plistPath atomically:YES];
    //
    //    NSLog(@"plistPath===%@",self.plistPath);
    
    [[NSUserDefaults standardUserDefaults]setObject:dic2 forKey:@"FriendRequest"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    
    
    
    
    NSLog(@"- appdelegate-aUsername-%@===aMessage==%@",aUsername,aMessage);
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}
// APP进入后台

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    [[EMClient sharedClient] applicationDidEnterBackground:application];

    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}
// APP将要从后台返回

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    
    [[EMClient sharedClient] applicationWillEnterForeground:application];

    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
