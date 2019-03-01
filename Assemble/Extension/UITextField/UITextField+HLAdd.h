//
//  UITextField+HLAdd.h
//  Hoolink_IoT
//
//  Created by hoolink on 2018/5/21.
//  Copyright © 2018年 hoolink_IoT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (HLAdd)

@property (nonatomic, assign) BOOL isShowToolBar;
//设置密码输入框
- (void)eye_rightView;
- (void)eyeWhite_rightView;

@end
