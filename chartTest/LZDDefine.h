//
//  LZDDefine.h
//  chartTest
//
//  Created by Bletc on 16/8/25.
//  Copyright © 2016年 bletc. All rights reserved.
//

#ifndef LZDDefine_h
#define LZDDefine_h

#define kWeChatPadding 10
#define kWeChatScreenHeight [UIScreen mainScreen].bounds.size.height
#define kWeChatScreenWidth [UIScreen mainScreen].bounds.size.width
#define kWeChatAllSubviewHeight 44

#define RGB(a,b,c) [UIColor colorWithRed:a/255.0 green:b/255.0 blue:c/255.0 alpha:1]

#define RandomColor RGB(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255))


#endif /* LZDDefine_h */
