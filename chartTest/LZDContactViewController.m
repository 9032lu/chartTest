//
//  LZDContactViewController.m
//  chartTest
//
//  Created by Bletc on 16/8/25.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "LZDContactViewController.h"
#import "LZDChartViewController.h"

@interface LZDContactViewController ()<EMContactManagerDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *arrFriends; //好友列表

@property (nonatomic, strong) NSArray *arrSystem;// 系统列表


@end

@implementation LZDContactViewController

-(NSMutableArray *)arrFriends{
    if (!_arrFriends) {
        _arrFriends = [NSMutableArray array];
    }
    return _arrFriends;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    LZDButton *rightBtn = [LZDButton creatLZDButton];
    rightBtn.frame = CGRectMake(kWeChatScreenWidth-50, 0, 30, 30);
//     [rightBtn setImage:[UIImage imageNamed:@"contacts_add_friend"] forState:UIControlStateNormal];
    
    [rightBtn setTitle:@"+" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:30];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    rightBtn.block = ^(LZDButton *btn){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"添加好友的请求信息" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        // 好友名称
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"请输入好友的名称";
        }];
        // 请求信息
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"请输入请求信息";
        }];
        
        // 获取alert中的文本输入框
        UITextField *usernameFiled = [alert.textFields firstObject];
        UITextField *descriptionFiled = [alert.textFields lastObject];
        
        // 添加按钮
        UIAlertAction *comitAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (usernameFiled.text.length == 0) {
                [[TKAlertCenter defaultCenter]postAlertWithMessage:@"请输入用户名"];
                return;
            }
            // 如果附带信息输入为空,那么就自定义一个
            NSString *message = (descriptionFiled.text.length == 0)?@"我想加你":descriptionFiled.text;
            // 发送好友请求
            

            
            [[EMClient sharedClient].contactManager asyncAddContact:usernameFiled.text message:message success:^{
                NSLog(@"添加成功");

            } failure:^(EMError *aError) {
                NSLog(@"添加失败");

            }];
            

       }];
        // 取消按钮
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        // 添加两个按钮
        [alert addAction:comitAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    };
    

   
    
    // 创建tableview
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0 , kWeChatScreenWidth, kWeChatScreenHeight-64-44) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.contentView addSubview:tableView];
    self.myTableView = tableView;
    
    
//    _arrSystem = @[@"申请与通知",@"群聊",@"聊天室"];
    // 设置代理方法
    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
    
    [self getListForFriends];
   

}


-(void)getListForFriends{
    // 从服务器获取好友列表
    [[EMClient sharedClient].contactManager asyncGetContactsFromServer:^(NSArray *aList) {
        NSLog(@"获取成功 -- %@",aList);
        
        self.arrFriends = [NSMutableArray arrayWithArray:aList];
        [self.myTableView reloadData];
        
    } failure:^(EMError *aError) {
        NSLog(@"获取失败");
    }];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return _arrSystem.count;
    }else
    return _arrFriends.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifire = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifire];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifire];
    }
    
    
    switch (indexPath.section) {
        case 0:
        {
            cell.textLabel.text = [_arrSystem objectAtIndex:indexPath.row];
            cell.imageView.backgroundColor = [UIColor redColor];
            break;
        }
            
        case 1:
        {
            
            cell.textLabel.text =[_arrFriends objectAtIndex:indexPath.row];
            break;
        }
            
        default:
            break;
    }
    

    
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section!=0 && editingStyle == UITableViewCellEditingStyleDelete) {
        
    NSString *username = _arrFriends[indexPath.row];
        // 删除好友
       [[EMClient sharedClient].contactManager asyncDeleteContact:username success:^{
            NSLog(@"删除成功");
            [[TKAlertCenter defaultCenter]postAlertWithMessage:@"删除好友成功"];

        } failure:^(EMError *aError) {
            NSLog(@"删除失败");

        }];
        
        
        
    }

        

}

- (void)didReceiveDeletedFromUsername:(NSString *)aUsername{
    
    NSLog(@"删除  = %@",aUsername);
    
    [_arrFriends removeObject:aUsername];
    [self.myTableView reloadData];
    
}


/**
 *  用户B申请加A为好友后，用户A会收到这个回调

 *
 *  @param aUsername 用户B
 *  @param aMessage  好友的邀请信息
 */
-(void)didReceiveFriendInvitationFromUsername:(NSString *)aUsername message:(NSString *)aMessage{
    
    NSLog(@"--aUsername-%@===aMessage==%@",aUsername,aMessage);
}

/*!
 @method
 @brief 用户A发送加用户B为好友的申请，用户B拒绝后，用户A会收到这个回调
 */
- (void)didReceiveDeclinedFromUsername:(NSString *)aUsername;{
    
}

- (void)didReceiveAddedFromUsername:(NSString *)aUsername;{
    NSLog(@"同意添加好友成功%@",aUsername);
    [self getListForFriends];

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section !=0) {
        
        
        NSString *url = [NSString stringWithFormat:@"http://101.201.100.191/VipCard/user_info_get.php"];
        NSLog(@"---%@",[[EMClient sharedClient] currentUsername]);
        
        [Request PostData:url Parameters:@{@"user":[[EMClient sharedClient] currentUsername]} Completion:^(NSError *error, id resultDict) {
            
            NSArray *usr_A = (NSArray*)resultDict;
            NSLog(@"usr_A=%@",usr_A);

            
            
            [Request PostData:url Parameters:@{@"user":_arrFriends[indexPath.row]} Completion:^(NSError *error, id resultDict) {
                
                NSLog(@"resultDict=%@",resultDict);
                
                
                
                LZDChartViewController *chatCtr = [[LZDChartViewController alloc]init];
                [chatCtr setHidesBottomBarWhenPushed:YES];
                chatCtr.username = self.arrFriends[indexPath.row];
                
                chatCtr.title = resultDict[0];
                chatCtr.userInfo = usr_A;
                
                
                if (chatCtr.userInfo.count!=0) {
                    [self.navigationController pushViewController:chatCtr animated:YES];
                    
                }
                
            }];

            
        }];

       

    }
   }


@end
