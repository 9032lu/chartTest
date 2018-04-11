//
//  LZDToolView.m
//  chartTest
//
//  Created by Bletc on 16/8/25.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "LZDToolView.h"

@interface LZDToolView ()<UITextViewDelegate>

/** 语音按钮 */
@property (nonatomic, weak) LZDButton *my_voiceBtn;

/** 文本输入框 */
@property (nonatomic, weak) UITextView *my_inputView;

/** 录音按钮 */
@property (nonatomic, weak) LZDButton *my_sendVoiceBtn;

/** 更多按钮 */
@property (nonatomic, weak) LZDButton *my_moreBtn;

@end
@implementation LZDToolView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        // 添加子控件
        // 1. 语音按钮
        LZDButton *voiceBtn = [LZDButton creatLZDButton];
        [voiceBtn setImage:[UIImage imageNamed:@"ToolViewInputVoice"] forState:UIControlStateNormal];
        [self addSubview:voiceBtn];
        // 2. 文本输入框
        UITextView *inputView = [[UITextView alloc]init];
        inputView.backgroundColor = [UIColor whiteColor];
        inputView.returnKeyType = UIReturnKeyDone;
        inputView.delegate = self;
        [self addSubview:inputView];
        
        // 3. 录音按钮
        LZDButton *sendVoiceBtn = [LZDButton creatLZDButton];
        [sendVoiceBtn setTitle:@"按住录音" forState:UIControlStateNormal];
        [sendVoiceBtn setTitle:@"松开发送" forState:UIControlStateHighlighted];
        [sendVoiceBtn addTarget:self action:@selector(startVoice:) forControlEvents:UIControlEventTouchDown];
        [sendVoiceBtn addTarget:self action:@selector(stopVoice:) forControlEvents:UIControlEventTouchUpInside];
        [sendVoiceBtn addTarget:self action:@selector(cancelVoice:) forControlEvents:UIControlEventTouchUpOutside];
        
        
        [self addSubview:sendVoiceBtn];
        sendVoiceBtn.hidden = YES;
        
        // 4. 更多按钮
        LZDButton *moreBtn = [LZDButton creatLZDButton];
        [moreBtn setImage:[UIImage imageNamed:@"TypeSelectorBtn_Black"] forState:UIControlStateNormal];
        
        moreBtn.block = ^(LZDButton*btn){
            _moreBtnBlock();
        };
        [self addSubview:moreBtn];
        
        // 赋值
        self.my_voiceBtn = voiceBtn;
        self.my_inputView = inputView;
        self.my_sendVoiceBtn = sendVoiceBtn;
        self.my_moreBtn = moreBtn;


        // 事件处理
        voiceBtn.block = ^(LZDButton *btn){
            inputView.hidden = sendVoiceBtn.hidden;
            sendVoiceBtn.hidden = !inputView.hidden;
            
        };
    }
    return self;
}

// 开始录音
- (void)startVoice:(LZDButton *)btn
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(toolViewWithType:Button:)]) {
        [self.delegate toolViewWithType:LZDToolViewVoiceTypeStart Button:btn];
    }
}

// 停止语音
- (void)stopVoice:(LZDButton *)btn
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(toolViewWithType:Button:)]) {
        [self.delegate toolViewWithType:LZDToolViewVoiceTypeStop Button:btn];
    }
}

- (void)cancelVoice:(LZDButton *)btn
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(toolViewWithType:Button:)]) {
        [self.delegate toolViewWithType:LZDToolViewVoiceTypeCancel Button:btn];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.my_voiceBtn.frame = CGRectMake(kWeChatPadding, kWeChatPadding/2 , self.height - kWeChatPadding , self.height - kWeChatPadding);
    
    self.my_inputView.frame = CGRectMake(self.my_voiceBtn.right + kWeChatPadding, self.my_voiceBtn.top, kWeChatScreenWidth - self.my_inputView.left*2, self.my_voiceBtn.height);
    
    self.my_sendVoiceBtn.frame = self.my_inputView.frame;
    
    self.my_moreBtn.frame = CGRectMake(self.my_inputView.right + kWeChatPadding, self.my_voiceBtn.top, self.my_voiceBtn.width, self.my_voiceBtn.height);
}


#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    NSString *txt =  [textView.text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//    NSLog(@"=textView.text.length===%lu",(unsigned long)txt.length);

    if (txt.length <1) return;
    
    // 点击了完成按钮
    if ([textView.text hasSuffix:@"\n"]) {
        if (_sendTextBlock) {
            
            textView.text = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
            self.sendTextBlock(textView,LZDToolViewEditTextViewSend);
        }
    }
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (_sendTextBlock) {
        self.sendTextBlock(textView,LZDToolViewEditTextViewBegin);
    }
    return YES;
}
@end
