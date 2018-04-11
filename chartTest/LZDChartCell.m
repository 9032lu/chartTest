//
//  LZDChartCell.m
//  chartTest
//
//  Created by Bletc on 16/8/25.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "LZDChartCell.h"
#import "UIButton+WebCache.h"
@interface LZDChartCell ()

/** 时间 */
@property (nonatomic, weak) UILabel *chatTime;

/** 聊天内容 */
@property (nonatomic, weak) LZDButton *chatButton;

/** 头像 */
@property (nonatomic, weak) LZDButton *chatIcon;
/**
 *  用户名
 */
@property (nonatomic, weak) UILabel *name_lab;

@end

@implementation LZDChartCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 添加子控件
        // 时间
        UILabel *timeLbl = [[UILabel alloc]init];
        timeLbl.textAlignment = NSTextAlignmentCenter;
        timeLbl.font = [UIFont systemFontOfSize:11];
        [self.contentView addSubview:timeLbl];
        
        // 聊天消息
        LZDButton *chatBtn = [LZDButton creatLZDButton];
        chatBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [chatBtn addTarget:self action:@selector(chatBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        // 需要设置内容的内边距
        chatBtn.contentEdgeInsets = UIEdgeInsetsMake(15, 20, 25, 20);
        chatBtn.titleLabel.numberOfLines = 0;

        [self.contentView addSubview:chatBtn];
        
        // 头像
        LZDButton *iconBtn = [LZDButton creatLZDButton];
        iconBtn.layer.masksToBounds = YES;
        iconBtn.layer.cornerRadius = kWeChatAllSubviewHeight/2;
        [self.contentView addSubview:iconBtn];
        
        UILabel *name_lab = [[UILabel alloc]init];
        name_lab.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:name_lab];
        
        
        self.chatButton = chatBtn;
        self.chatIcon = iconBtn;
        self.chatTime = timeLbl;
        self.name_lab = name_lab;
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.chatTime.frame = CGRectMake(0, 0, kWeChatScreenWidth, 30);
    self.name_lab.frame = CGRectMake(kWeChatPadding, self.chatTime.bottom, kWeChatScreenWidth-2*kWeChatPadding, 20);

}

- (void)setMessage:(EMMessage *)message
{
    _message = message;
    // 获取消息体
    id body = message.body;

//    NSString *time = [self conversationTime:message.timestamp];
//
//        NSString *lastTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastTime"];
//        if (![time isEqualToString:lastTime]) {
//            self.chatTime.text = time;
//            [[NSUserDefaults standardUserDefaults] setObject:time forKey:@"lastTime"];
//        }
    NSDictionary *userDic =  message.ext;
    
    self.chatTime.text = [self conversationTime:message.timestamp];
    
    if ([body isKindOfClass:[EMTextMessageBody class]]) {// 文本类型
        EMTextMessageBody *textBody = body;
        
        [self.chatButton setTitle:textBody.text forState:UIControlStateNormal];
        [self.chatButton setImage:nil forState:UIControlStateNormal];
        
        [self.chatButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //        double time = message.timestamp;
        //        if (message.timestamp > 140000000000) {
        //            time = message.timestamp/1000;
        //        }
        //        NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:time];
        //        NSString *timeStr = [date dateTimeString2];
        CGSize size = [textBody.text boundingRectWithSize:CGSizeMake(kWeChatScreenWidth/2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f]} context:nil].size;
        CGSize realSize = CGSizeMake(size.width + 40, size.height + 40);
        // 聊天按钮的size
        self.chatButton.size = realSize;
        
        
    }else if ([body isKindOfClass:[EMVoiceMessageBody class]]){// 语音类型
        EMVoiceMessageBody *voiceBody = body;
        // 设置图片 和 时间
        [self.chatButton setImage:[UIImage imageNamed:@"chat_receiver_audio_playing_full"] forState:UIControlStateNormal];
        [self.chatButton setTitle:[NSString stringWithFormat:@"%zd'",voiceBody.duration] forState:UIControlStateNormal];
        self.chatButton.size = CGSizeMake(kWeChatAllSubviewHeight + 40, kWeChatAllSubviewHeight + 40);
        self.chatButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        self.chatButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    }else if([body isKindOfClass:[EMImageMessageBody class]]){
        EMImageMessageBody *imgBody = body;
        //        imgBody.localPath; 本地大图片
        //        imgBody.thumbnailLocalPath, 本地的预览图
        //        imgBody.remotePath, 服务端上的大图
        //        imgBody.thumbnailRemotePath, 服务端的预览图
        
        CGFloat scale = imgBody.size.height/imgBody.size.height;
        self.chatButton.size = CGSizeMake(kWeChatAllSubviewHeight*3 + 40, (kWeChatAllSubviewHeight*3 + 40)*scale);
        
//        self.chatButton.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 8, 10);

        // 获得本地预览图片的路径
        NSString *path = imgBody.thumbnailLocalPath;
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        // 使用sdWedImage下载图片
        // 设置URL
        NSURL *url = nil;
        if ([fileMgr fileExistsAtPath:path]) {
            url = [NSURL fileURLWithPath:path];
        }else{
            url = [NSURL URLWithString:imgBody.thumbnailRemotePath];
        }
        
        
        [self.chatButton sd_setImageWithURL:url forState:0 placeholderImage:[UIImage imageNamed:@"default_header"]];
        
        
    }
    
    
   
    
    [self.chatIcon sd_setImageWithURL:[NSURL URLWithString:userDic[@"headerImg"]] forState:0 placeholderImage:[UIImage imageNamed:@"userHeader"]];
    
    self.name_lab.text = userDic[@"headerName"];


    NSString *chatter = [[EMClient sharedClient] currentUsername];
    
    if ([message.from isEqualToString:chatter]) {// 自己发送的
        
        [self.chatButton setBackgroundImage:[UIImage resizingImageWithName:@"bubbleSelf"] forState:UIControlStateNormal];
//        [self.chatIcon sd_setBackgroundImageWithURL:[NSURL URLWithString:userDic[@"headerImg"]] forState:0];
//        [self.chatIcon setBackgroundImage:[UIImage imageNamed:@"2.jpg"] forState:UIControlStateNormal];

        // 头像在右边
        self.chatIcon.frame = CGRectMake(kWeChatScreenWidth - kWeChatAllSubviewHeight - kWeChatPadding,20 +30 + kWeChatPadding, kWeChatAllSubviewHeight, kWeChatAllSubviewHeight);
//        self.name_lab.text = userDic[@"headerName"];
        self.name_lab.textAlignment = NSTextAlignmentRight;
        
        // 聊天消息是左边
        self.chatButton.left = kWeChatScreenWidth - self.chatButton.width - self.chatIcon.width - kWeChatPadding*2;
        
    }else{// 别人发的
        // 头像在右边
        self.chatIcon.frame = CGRectMake(kWeChatPadding,20 +30 + kWeChatPadding, kWeChatAllSubviewHeight, kWeChatAllSubviewHeight);
        [self.chatIcon setBackgroundImage:[UIImage imageNamed:@"1.jpg"] forState:UIControlStateNormal];

//        self.name_lab.text = message.from;
        self.name_lab.textAlignment = NSTextAlignmentLeft;

        
        // 聊天消息是左边
        self.chatButton.left = self.chatIcon.right + kWeChatPadding;
        [self.chatButton setBackgroundImage:[UIImage resizingImageWithName:@"bubble"] forState:UIControlStateNormal];

    }
    // Y轴
    self.chatButton.top = self.chatIcon.top;
    
    if([body isKindOfClass:[EMImageMessageBody class]]){
        
        [self.chatButton setBackgroundImage:nil forState:UIControlStateNormal];

    }
    
}

- (CGFloat)rowHeight
{
    return self.chatButton.bottom + kWeChatPadding;
}

// 图片按钮的点击
- (void)chatBtnClick:(LZDButton *)btn
{
    NSLog(@"message = %@",self.message);
    id body = self.message.body;
    if ([body isKindOfClass:[EMVoiceMessageBody class]]) {// 播放语音
        [self playVoice:body];
    }else if([body isKindOfClass:[EMImageMessageBody class]]){
//        EMImageMessageBody *imageBody = (EMImageMessageBody*)body;
        // 显示大图片
        if (self.delegate && [self.delegate respondsToSelector:@selector(chartCellWithMessage:)]) {
            [self.delegate chartCellWithMessage:self.message];
        }
    }
}
- (void)playVoice:(EMVoiceMessageBody *)body
{
//    EMVoiceMessageBody *voiceBody = body;
//    // 获取本地路径
//    NSString *path = voiceBody.localPath;
//    NSFileManager *fileMgr = [NSFileManager defaultManager];
//    // 判断path是否存在
//    // 如果是不存在
//    if (![fileMgr fileExistsAtPath:path]) {
//        // 从远程服务器获取地址
//        path = voiceBody.remotePath;
//    }
//    
//    //        NSLog(@"path = %@ voiceBody.localPath = %@  voiceBody.remotePath = %@",path,voiceBody.localPath,voiceBody.remotePath);
//    [[EMCDDeviceManager sharedInstance] asyncPlayingWithPath:path completion:^(NSError *error) {
//        if (!error) {
//            NSLog(@"播放成功");
//        }
//    }];
}

// 时间的转换
- (NSString *)conversationTime:(long long)time
{
    // 今天 11:20
    // 昨天 23:23
    // 前天以前 11:11
    // 1. 创建一个日历对象
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 2. 获取当前时间
    NSDate *currentDate = [NSDate date];
    // 3. 获取当前时间的年月日
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:currentDate];
    NSInteger currentYear = components.year;
    NSInteger currentMonth = components.month;
    NSInteger currentDay = components.day;
    // 4. 获取发送时间
    NSDate *sendDate = [NSDate dateWithTimeIntervalSince1970:time/1000];
    // 5. 获取发送时间的年月日
    NSDateComponents *sendComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:sendDate];
    NSInteger sendYear = sendComponents.year;
    NSInteger sendMonth =  sendComponents.month;
    NSInteger sendDay = sendComponents.day;
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    // 6. 当前时间与发送时间的比较
    if (currentYear == sendYear &&
        currentMonth == sendMonth &&
        currentDay == sendDay) {// 今天
        fmt.dateFormat = @"今天 HH:mm";
    }else if(currentYear == sendYear &&
             currentMonth == sendMonth &&
             currentDay == sendDay + 1){
        fmt.dateFormat = @"昨天 HH:mm";
    }else{
        fmt.dateFormat = @"昨天以前 HH:mm";
    }
    
    return  [fmt stringFromDate:sendDate];
}



@end
