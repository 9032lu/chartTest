//
//  LZDChartViewController.m
//  chartTest
//
//  Created by Bletc on 16/8/25.
//  Copyright © 2016年 bletc. All rights reserved.
//
#define LZDAnyViewSubviewHW (kWeChatScreenWidth - 4*kWeChatPadding)/3

#import "LZDChartViewController.h"
#import "LZDToolView.h"
#import "LZDChartCell.h"
#import "LZDAnyView.h"
#import "MWPhotoBrowser.h"
#import "UIImage+WebP.h"


@interface LZDChartViewController ()<UITableViewDataSource,UITableViewDelegate,EMChatManagerDelegate,LZDToolViewVoiceDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,MWPhotoBrowserDelegate,LZDChartCellShowImageDelegate>

@property (nonatomic, weak) UITableView *chatTableView;
@property (nonatomic , strong) NSMutableArray *msg_A;/** 聊天消息 */

/** 更多功能 */
@property (nonatomic, weak) LZDAnyView *chatAnyView;
/** 更多功能需要拿到的textView */
@property (nonatomic, weak) UITextView *anyViewNeedTextView;

@property(nonatomic,weak)UIImagePickerController *imgPicker;//***图片选择器


/** 保存图片的message */
@property (nonatomic, strong) EMMessage *photoMessage;




@end

@implementation LZDChartViewController
-(NSMutableArray *)msg_A{
    if (!_msg_A) {
        _msg_A = [[NSMutableArray alloc]init];
    }
    return _msg_A;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.contentView.backgroundColor = [UIColor whiteColor];
    // 1. 创建tableview
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWeChatScreenWidth, kWeChatScreenHeight - 64 - 44) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview:tableView];
    
    self.chatTableView = tableView;
    
   
    // 获取本地的聊天消息
    
    [self  getdata];
    
    
    // 添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrameNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];

    
    // 2. 创建自定义控件
    LZDToolView *toolView = [[LZDToolView alloc]init];
    toolView.frame = CGRectMake(0, tableView.bottom, tableView.width, 44);
    toolView.delegate = self;
    [self.contentView addSubview:toolView];
    
    
    // 发送消息

    toolView.sendTextBlock = ^(UITextView *textView ,LZDToolViewEditTextViewType tpye){
        NSLog(@"你点击了完成按钮==%d",tpye);
        if (tpye == LZDToolViewEditTextViewSend) {
            [self sendMsg:textView];
 
        }else{
            
            if (self.chatAnyView.top < kWeChatScreenHeight) {
                self.chatAnyView.top = kWeChatScreenHeight;
            }
            
            self.anyViewNeedTextView = textView;

        }
        
        
       
    };
    
    // 创建更多功能
     LZDAnyView *anyView = [[LZDAnyView alloc]initImageBlock:^{
         NSLog(@"你点击了图片");
         UIImagePickerController *picker = [[UIImagePickerController alloc]init];
         picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
         picker.delegate = self;
         self.imgPicker = picker;
         [self presentViewController:picker animated:YES completion:nil];
     } PhotoBlock:^{
         NSLog(@"你点击了相机");
         
#if TARGET_IPHONE_SIMULATOR//模拟器
         
#elif TARGET_OS_IPHONE//真机
         UIImagePickerController *picker = [[UIImagePickerController alloc]init];
         picker.sourceType = UIImagePickerControllerSourceTypeCamera;
         picker.delegate = self;
         self.imgPicker = picker;
         [self presentViewController:picker animated:YES completion:nil];
         
#endif
         
         
        

         
     } talkBlock:^{
         NSLog(@"你点击了语音");

     } vedioBlock:^{
         NSLog(@"你点击了视频");

     }];

       anyView.frame = CGRectMake(0, kWeChatScreenHeight, kWeChatScreenWidth, LZDAnyViewSubviewHW+30);
    [[UIApplication sharedApplication].keyWindow addSubview:anyView];
    self.chatAnyView = anyView;

    
    // 1. 现在滚动视图隐藏
    // 2. 在输入文字的时候同时点击更多功能
    // 3. 在文本框同时显示的时候隐藏更多功能
    // 4. 当开始编辑的时候应该隐藏掉更多功能
    
    //moreBtn的点击
    toolView.moreBtnBlock = ^(){
        
        NSLog(@"你点击了更多==%@",self.anyViewNeedTextView);
        
        
        if (self.anyViewNeedTextView) {
            [self.anyViewNeedTextView resignFirstResponder];
        }
        [UIView animateWithDuration:0.5 animations:^{
            self.contentView.top = -LZDAnyViewSubviewHW;
            anyView.top = kWeChatScreenHeight - LZDAnyViewSubviewHW;
            

        }];
           };
    

  }

// 通知回调的方法
- (void)keyboardWillChangeFrameNotification:(NSNotification *)noti
{
//    NSLog(@"    noti.userInfo = %@",    noti.userInfo);
    CGRect keyboardF = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (keyboardF.origin.y < kWeChatScreenHeight) {
        self.chatTableView.top =keyboardF.size.height;
        self.chatTableView.height = kWeChatScreenHeight-keyboardF.size.height-64-44;

        
        self.contentView.top = - keyboardF.size.height;
    }else{
        self.chatTableView.top = 0;
        self.chatTableView.height = kWeChatScreenHeight-64-44;

        self.contentView.top = 0;
    }
//    [self scrollBottom];
}

- (void)scrollBottom
{
    // 滚到最后一行
    
    
    if (_msg_A.count>6) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.msg_A.count - 1 inSection:0];
        [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
   
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
    [self.contentView endEditing:YES];
    [UIView animateWithDuration:0.4f animations:^{
        self.chatAnyView.top = kWeChatScreenHeight;
        if (self.contentView.top < 0) self.contentView.top = 0;
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    return self.msg_A.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"CHATCELL";
    LZDChartCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[LZDChartCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.message = self.msg_A[indexPath.row];
    
    return cell.rowHeight;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"CHATCELL";
    LZDChartCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[LZDChartCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.message = self.msg_A[indexPath.row];
    cell.delegate = self;
    return cell;
}


//收到消息调用
- (void)didReceiveMessages:(NSArray *)aMessages
{
    
    NSLog(@"didReceiveMessages");
    for (int i =0; i < aMessages.count; i ++) {
        EMMessage*message = aMessages[i];
        EMMessageBody *msgbody = message.body;
        NSLog(@"-收到来自:%@ 的:-----%d",message.from,msgbody.type);;
        [self.msg_A addObject:message];
                
        
    }
    
    [_chatTableView reloadData];

    
    [self scrollBottom];

    
}
- (void)didReceiveCmdMessages:(NSArray *)aCmdMessages;
{
    NSLog(@"didReceiveCmdMessages");

}
- (void)didReceiveHasDeliveredAcks:(NSArray *)aMessages;
{
    NSLog(@"didReceiveHasDeliveredAcks");
}


-(void)dealloc{
    NSLog(@"dealloc");
    
//    [[EMClient sharedClient].chatManager removeDelegate:self];
//    [[EMClient sharedClient] removeDelegate:self];
}


// 获取本地的聊天消息

-(void)getdata{
    
    EMConversation*conver=[[EMClient sharedClient].chatManager getConversation:self.username type:EMConversationTypeChat createIfNotExist:YES]; 
    
    [conver markAllMessagesAsRead];
    NSArray *array =[conver loadMoreMessagesFromId:nil limit:30 direction:EMMessageSearchDirectionUp];
    
    for (int i =0; i < array.count; i ++) {
        EMMessage*message = array[i];
//        message.mineImg = self.mineImg;
        
                [self.msg_A addObject:message];
    }
    
    
    [_chatTableView reloadData];

    [self scrollBottom];

}


#pragma mark - XMGTollViewVoiceDelegate

-(void)toolViewWithType:(LZDToolViewVoiceType)type Button:(LZDButton *)btn{
    

//    switch (type) {
//        case XMGTollViewVoiceTypeStart:
//        {
//            NSLog(@"开始录音");
//            int fileNameNum = arc4random() % 1000;
//            NSTimeInterval time = [NSDate timeIntervalSinceReferenceDate];
//            [[EMCDDeviceManager sharedInstance] asyncStartRecordingWithFileName:[NSString stringWithFormat:@"%zd%d",fileNameNum,(int)time] completion:^(NSError *error) {
//                if (!error) {
//                    NSLog(@"录音成功");
//                    
//                }
//            }];
//        }
//            break;
//            
//        case XMGTollViewVoiceTypeStop:
//        {
//            NSLog(@"停止录音");
//            [[EMCDDeviceManager sharedInstance] asyncStopRecordingWithCompletion:^(NSString *recordPath, NSInteger aDuration, NSError *error) {
//                NSLog(@"recordPath = %@ , duration = %zd",recordPath,aDuration);
//                [self sendVoiceWithFilePath:recordPath duration:aDuration];
//            }];
//        }
//            break;
//            
//        case XMGTollViewVoiceTypeCancel:
//        {
//            NSLog(@"退出录音");
//        }
//            break;
//            
//        default:
//            break;
//    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.contentView.top = 0;
    self.chatAnyView.top = kWeChatScreenHeight;
    [[EMClient sharedClient].chatManager removeDelegate:self];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
}


// 发送语音消息
- (void)sendVoiceWithFilePath:(NSString *)path duration:(NSInteger)aDuration
{
//    EMChatVoice *voice = [[EMChatVoice alloc]initWithFile:path displayName:@"audio"];
//    // 需要设置语音时间
//    voice.duration = aDuration;
//    
//    EMVoiceMessageBody *voiceBody = [[EMVoiceMessageBody alloc]initWithChatObject:voice];
//    
//    // message
//    EMMessage *message = [[EMMessage alloc]initWithReceiver:self.budddy.username bodies:@[voiceBody]];
//    
//    // 发送消息
//    [[EaseMob sharedInstance].chatManager asyncSendMessage:message progress:self prepare:^(EMMessage *message, EMError *error) {
//        NSLog(@"即将发送");
//    } onQueue:nil completion:^(EMMessage *message, EMError *error) {
//        NSLog(@"发送完成");
//        // 添加数据
//        [self.messageData addObject:message];
//        // 刷新表格
//        [self.chatTableView reloadData];
//        // 滚到最后一行
//        [self scrollBottom];
//    } onQueue:nil];
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    // 隐藏picker
    [picker dismissViewControllerAnimated:YES completion:nil];
    // 取出图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    // 发送图片
    [self sendImage:image];
}

#pragma mark 发送图片
- (void)sendImage:(UIImage *)image
{
    
    NSLog(@"==sendImage");
    NSData * data = UIImageJPEGRepresentation(image, 1.0);
    
    
    NSData *thumbnailData=UIImageJPEGRepresentation (image, 0.3);
    //生成图片的data
//    EMImageMessageBody *body=[[EMImageMessageBody alloc]initWithData:data displayName:@"image.png"];
    
    EMImageMessageBody *body = [[EMImageMessageBody alloc]initWithData:data thumbnailData:thumbnailData];
    body.size = image.size;
    NSString *from=[[EMClient sharedClient] currentUsername];
    
    //生成Message
    NSString *img_str = [NSString stringWithFormat:@"%@",[NSURL URLWithString:[HEADIMAGE stringByAppendingString:self.userInfo[1]]]];
    
    NSDictionary *dic = @{@"headerName":self.userInfo[0],@"headerImg":img_str};

    EMMessage *message=[[EMMessage alloc]initWithConversationID:self.username from:from to:self.username body:body ext:dic];
    message.chatType=EMChatTypeChat;
    
    [MBProgressHUD showMessag:@"发送中..." toView:self.view];
    [[EMClient sharedClient].chatManager asyncSendMessage:message progress:^(int progress) {
        if (progress==100)
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];//隐藏菊花
        }
        
    } completion:^(EMMessage *message, EMError *error) {
        NSLog(@"发送图片Error%@",error.errorDescription);
        
        if (!error)
        {   //存入数组
            NSLog(@"发送成功");
            [self.msg_A addObject:message];
            
           
            
                [_chatTableView reloadData];
                
                [self scrollBottom];

            
                    }
        
    }];
    
    [_imgPicker dismissViewControllerAnimated:YES completion:nil];//模态视图


}


#pragma mark - 显示大图片
-(void)chartCellWithMessage:(EMMessage *)message
{
    self.photoMessage = message;
    NSLog(@"delegate message = %@",message);
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc]initWithDelegate:self];
    
    [self.navigationController pushViewController:browser animated:YES];
}


#pragma mark - 图片浏览器的代理方法
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return 1;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    EMImageMessageBody *body = (EMImageMessageBody*)self.photoMessage.body;
    
    NSString *path = body.localPath;
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    if ([fileMgr fileExistsAtPath:path]) {
        // 设置图片浏览器中的图片对象 (本地获取的)
        return [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:path]];
    }else{
        // 设置图片浏览器中的图片对象 (使用网络请求)
        path = body.remotePath;
        return [MWPhoto photoWithURL:[NSURL URLWithString:path]];
    }
    
    return nil;
}


// 发送消息

-(void)sendMsg:(UITextView*)textView{
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:textView.text];
    NSString *from = [[EMClient sharedClient] currentUsername];
    
    //生成Message
    NSString *img_str = [NSString stringWithFormat:@"%@",[NSURL URLWithString:[HEADIMAGE stringByAppendingString:self.userInfo[1]]]];
    
    NSDictionary *dic = @{@"headerName":self.userInfo[0],@"headerImg":img_str};
    
    EMMessage *message = [[EMMessage alloc] initWithConversationID:self.username from:from to:self.username body:body ext:dic];
    
    [[EMClient sharedClient].chatManager asyncSendMessage:message progress:^(int progress) {
        
    } completion:^(EMMessage *message, EMError *error) {
        NSLog(@"===发送成功");
        
        // 添加数据
        {
            EMMessageBody *msgbody = message.body;
            
            switch (msgbody.type) {
                case EMMessageBodyTypeText:
                {
                    
//                    LZDMessage *mess = (LZDMessage*)message;
//                    mess.mineImg = self.mineImg;
                    [self.msg_A addObject:message];
                    
                }
                    break;
                    
                default:
                    break;
            }
            
        }            // 刷新表格
        // 清空数据
        [_chatTableView reloadData];
        
        textView.text = @"";
        [self scrollBottom];
        
    }];
    
    
    message.chatType = EMChatTypeChat;// 设置为单聊消息
    
    
    
}

@end
