//
//  LZDConversationViewController.m
//  chartTest
//
//  Created by Bletc on 16/8/25.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "LZDConversationViewController.h"
#import "LZDChartViewController.h"
@interface LZDConversationViewController ()<EMClientDelegate,EMContactManagerDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, weak) UITableView *myTableView;

@end

@implementation LZDConversationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
//
//    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
    
    // 创建tableview
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0 , kWeChatScreenWidth, kWeChatScreenHeight-64-44) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 64;
    [self.contentView addSubview:tableView];
    self.myTableView = tableView;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray *conversations = [[EMClient sharedClient].chatManager loadAllConversationsFromDB];

    return conversations.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellID = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
        
    }
    

    
    
    tableView.separatorColor=[UIColor clearColor];
    NSArray *conversations = [[EMClient sharedClient].chatManager loadAllConversationsFromDB];
    
    
    EMConversation*conver=[conversations objectAtIndex:indexPath.row];
    
//    conver.enableUnreadMessagesCountEvent=YES;
    
    
    EMMessage*essage=conver.latestMessage;
    
    NSLog(@"%@essage.from========%@",essage.from,essage.to);
    
    NSString*chatUser;
//    if (USERID==nil) {
//        chatUser=MANGERID;
//    }else
//    {
//        chatUser=USERID;
//    }
//    
//    if ([chatUser isEqualToString:essage.from]) {
//        chatUser=essage.to;
//    }else
//    {
        chatUser=essage.from;
//    }
    
    UIImageView*image=[[UIImageView alloc]initWithFrame:CGRectMake(kWeChatScreenWidth*0.03, kWeChatScreenWidth*0.03, kWeChatScreenWidth*0.14, kWeChatScreenWidth*0.14)];
    image.image=[UIImage imageNamed:@"1"];
    
    UILabel*rednumbel=[[UILabel alloc]initWithFrame:CGRectMake(kWeChatScreenWidth*0.14-15, 0, 15, 15)];
    rednumbel.backgroundColor=[UIColor redColor];
    rednumbel.text=[NSString stringWithFormat:@"%lu",(unsigned long)[conver unreadMessagesCount]];
    if ([rednumbel.text intValue]==0) {
        rednumbel.hidden=YES;
    }
    rednumbel.font=[UIFont systemFontOfSize:13];
    rednumbel.layer.cornerRadius=7.5;
    rednumbel.clipsToBounds=YES;
    rednumbel.textAlignment=NSTextAlignmentCenter;
    [image addSubview:rednumbel];
    [cell.contentView addSubview:image];
    
    UIView *kuang=[[UIView alloc]initWithFrame:CGRectMake(kWeChatScreenWidth*0.03-2, kWeChatScreenWidth*0.03-2, kWeChatScreenWidth*0.14+4, kWeChatScreenWidth*0.14+4)];
    kuang.layer.borderColor=RGB(234, 234, 234).CGColor;
    kuang.layer.borderWidth=1;
    [cell.contentView addSubview:kuang];
    
    
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(kWeChatScreenWidth*0.2, kWeChatScreenWidth*0.03, kWeChatScreenWidth*0.44, kWeChatScreenWidth*0.07)];
    
    NSLog(@"----%lu",(unsigned long)chatUser.length);
    
    if (chatUser.length==11) {
        chatUser=[NSString stringWithFormat:@"%@****%@",[chatUser substringToIndex:3],[chatUser substringFromIndex:7]];
    }
        label.text=[NSString stringWithFormat:@"%@",chatUser];

    
    


    label.textAlignment=NSTextAlignmentLeft;
    label.textColor=[UIColor blackColor];
    label.font=[UIFont systemFontOfSize:14];
    [cell.contentView addSubview:label];
    
    NSString*info;
    EMMessageBody *msgBody = essage.body;
    
    if (msgBody.type==EMMessageBodyTypeText) {
        info=((EMTextMessageBody *)msgBody).text;
    }else {
        info=@"";
    }
    
    
    
    UILabel*user_L=[[UILabel alloc]initWithFrame:CGRectMake(kWeChatScreenWidth*0.2, kWeChatScreenWidth*0.1, kWeChatScreenWidth*0.44, kWeChatScreenWidth*0.07)];
    user_L.text=[NSString stringWithFormat:@"%@",info];
    user_L.textAlignment=NSTextAlignmentLeft;
    user_L.textColor=[UIColor grayColor];
    user_L.font=[UIFont systemFontOfSize:14];
    [cell.contentView addSubview:user_L];
    
    
    NSDate*confromTimesp = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)essage.timestamp/1000];
    NSString*date=[NSString stringWithFormat:@"%@",confromTimesp];
    NSString*newDate=[[date substringToIndex:16] substringFromIndex:2];
    
    
    UILabel*time_L=[[UILabel alloc]initWithFrame:CGRectMake(kWeChatScreenWidth*0.65, kWeChatScreenWidth*0.03, kWeChatScreenWidth*0.32, kWeChatScreenWidth*0.1)];
    time_L.text=[NSString stringWithFormat:@"%@",newDate];
    time_L.textAlignment=NSTextAlignmentRight;
    time_L.textColor=[UIColor grayColor];
    time_L.font=[UIFont systemFontOfSize:12];
    [cell.contentView addSubview:time_L];
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    {
        
        NSArray *conversations = [[EMClient sharedClient].chatManager loadAllConversationsFromDB];
        EMConversation *conversation = conversations[indexPath.row];
        
        

        
        NSString *url = [NSString stringWithFormat:@"http://101.201.100.191/VipCard/user_info_get.php"];
        
        [Request PostData:url Parameters:@{@"user":[[EMClient sharedClient] currentUsername]} Completion:^(NSError *error, id resultDict) {
            
            NSArray *usr_A = (NSArray*)resultDict;
            
//            NSLog(@"==resultDict==%@",resultDict);
            
            [Request PostData:url Parameters:@{@"user":conversation.conversationId} Completion:^(NSError *error, id resultDict) {
                
                
                LZDChartViewController *chatCtr = [[LZDChartViewController alloc]init];
                [chatCtr setHidesBottomBarWhenPushed:YES];
                chatCtr.username = conversation.conversationId;
                
                chatCtr.userInfo = usr_A;
//                NSLog(@"------%@",resultDict);
                if (chatCtr.userInfo.count!=0) {
                    chatCtr.title = resultDict[0];

                    [self.navigationController pushViewController:chatCtr animated:YES];
                    
                }
                
            }];
            
            
        }];
        
        
        
    }
}

// 自动重连，只需要监听重连相关的回调，无需进行任何操作
- (void)didConnectionStateChanged:(EMConnectionState)connectionState
{
    NSLog(@"类型为 = %zd",connectionState);
    switch (connectionState) {
        case EMConnectionConnected:
        {
            self.title = @"连接成功";
        }
            break;
        case EMConnectionDisconnected:
        {
            self.title = @"未连接";
        }
            break;
            
        default:
            break;
    }
}
// 接收到好友的请求

-(void)didReceiveFriendInvitationFromUsername:(NSString *)aUsername message:(NSString *)aMessage{
    

    NSLog(@"userName = %@ msg = %@",aUsername,aMessage);
    // 同意 或者 拒绝
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"好友请求信息" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    // 确定按钮
    UIAlertAction *addAction = [UIAlertAction actionWithTitle:@"添加" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
       
        EMError *error = [[EMClient sharedClient].contactManager acceptInvitationForUsername:aUsername];
        if (!error) {
            NSLog(@"发送同意成功");
        }

    }];
    // 拒绝按钮
    UIAlertAction *rejecteAction = [UIAlertAction actionWithTitle:@"拒绝" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        EMError *error = [[EMClient sharedClient].contactManager declineInvitationForUsername:aUsername];
        if (!error) {
            NSLog(@"发送拒绝成功");
        }    }];
    
    [alert addAction:addAction];
    [alert addAction:rejecteAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
