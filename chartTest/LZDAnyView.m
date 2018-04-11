//
//  LZDAnyView.m
//  chartTest
//
//  Created by Bletc on 16/8/25.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "LZDAnyView.h"
#define LZDAnyViewSubviewHW (kWeChatScreenWidth - 5*kWeChatPadding)/4

@interface LZDAnyView ()
/** 图片按钮 */
@property (nonatomic, weak) LZDButton *imgBtn;
// 相机按钮
@property(nonatomic,weak)LZDButton *photoBtn;


/** 语音按钮 */
@property (nonatomic, weak) LZDButton *talkBtn;

/** 视频按钮 */
@property (nonatomic, weak) LZDButton *vedioBtn;


@end

@implementation LZDAnyView

-(instancetype)initImageBlock:(void (^)(void))imageBlock PhotoBlock:(void (^)(void))photoBlock talkBlock:(void (^)(void))talkBlock vedioBlock:(void (^)(void))vedioBlock{
    

    if (self = [super init]) {
        
        self.backgroundColor = [UIColor grayColor];
        
        // 初始化
        LZDButton *imageBtn = [LZDButton creatLZDButton];
        [imageBtn setBackgroundColor:[UIColor redColor]];
        [imageBtn setTitle:@"图片" forState:UIControlStateNormal];
        [self addSubview:imageBtn];
        
        LZDButton *photoBtn = [LZDButton creatLZDButton];
        [photoBtn setBackgroundColor:RandomColor];
        [photoBtn setTitle:@"相机" forState:UIControlStateNormal];
        [self addSubview:photoBtn];
        
        LZDButton *talkChatBtn = [LZDButton creatLZDButton];
        [talkChatBtn setBackgroundColor:[UIColor greenColor]];
        [talkChatBtn setTitle:@"语音" forState:UIControlStateNormal];
        [self addSubview:talkChatBtn];
        
        LZDButton *vedioChatBtn = [LZDButton creatLZDButton];
        [vedioChatBtn setBackgroundColor:[UIColor blueColor]];
        [vedioChatBtn setTitle:@"视频" forState:UIControlStateNormal];
        [self addSubview:vedioChatBtn];
        
        // 赋值
        self.imgBtn = imageBtn;
        self.photoBtn = photoBtn;
        self.talkBtn = talkChatBtn;
        self.vedioBtn = vedioChatBtn;
        
        // 事件处理
        imageBtn.block = ^(LZDButton *btn){
            if (imageBlock) {
                imageBlock();
            }
        };
        photoBtn.block = ^(LZDButton*btn){
            if (photoBlock) {
                photoBlock();
            }
        };
        talkChatBtn.block = ^(LZDButton *btn){
            if (talkBlock) {
                talkBlock();
            }
        };
        vedioChatBtn.block = ^(LZDButton *btn){
            if (vedioBlock) {
                vedioBlock();
            }
        };
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imgBtn.frame = CGRectMake(kWeChatPadding, kWeChatPadding, LZDAnyViewSubviewHW, LZDAnyViewSubviewHW);
    self.photoBtn.frame = CGRectMake(self.imgBtn.right+kWeChatPadding, self.imgBtn.top, LZDAnyViewSubviewHW, LZDAnyViewSubviewHW);
    
    self.talkBtn.frame = CGRectMake(self.photoBtn.right + kWeChatPadding, self.imgBtn.top, LZDAnyViewSubviewHW, LZDAnyViewSubviewHW);
    self.vedioBtn.frame = CGRectMake(self.talkBtn.right + kWeChatPadding, self.talkBtn.top, LZDAnyViewSubviewHW, LZDAnyViewSubviewHW);
}


@end
