//
//  LZDButton.h
//  chartTest
//
//  Created by Bletc on 16/8/25.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LZDButton;
typedef void(^LZDButtonClickBlock)(LZDButton*);

@interface LZDButton : UIButton

/**
 *  回调
 */
@property (nonatomic,copy)LZDButtonClickBlock block;

+(instancetype)creatLZDButton;
@end
