//
//  UITextField+HLAdd.m
//  Hoolink_IoT
//
//  Created by hoolink on 2018/5/21.
//  Copyright © 2018年 hoolink_IoT. All rights reserved.
//

#import "UITextField+HLAdd.h"

@implementation UITextField (HLAdd)

- (void)eye_rightView {
    
    UIButton *rightView = [[UIButton alloc] init];
    self.secureTextEntry = YES;
    [rightView setImage:[UIImage imageNamed:@"eye_hide"] forState:UIControlStateNormal];
    rightView.frame = CGRectMake(0, 0, 26, 16);
    rightView.centerY = self.centerY;
    self.rightView = rightView;
    self.rightViewMode = UITextFieldViewModeAlways;
    [rightView addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
}

//监听右边按钮的点击,切换密码输入明暗文状态
-(void)btnClick:(UIButton *)btn{
    //解决明暗文切换后面空格的问题的两种方式
    //NSString* text = self.text;
    //self.text = @" ";
    //self.text = text;
    //[self becomeFirstResponder];
    [self resignFirstResponder];//取消第一响应者
    btn.selected = !btn.selected;
    if (!btn.selected) {
        [btn setImage:[UIImage imageNamed:@"eye_hide"] forState:UIControlStateNormal];
        self.secureTextEntry = YES;
    }else{
        [btn setImage:[UIImage imageNamed:@"eye_show"] forState:UIControlStateSelected];
        self.secureTextEntry = NO;
    }
    [self becomeFirstResponder];//放弃第一响应者
}

- (void)eyeWhite_rightView {
    
    UIButton *rightView = [[UIButton alloc] init];
    self.secureTextEntry = YES;
    [rightView setImage:[UIImage imageNamed:@"eye_hide_white"] forState:UIControlStateNormal];
    rightView.frame = CGRectMake(0, 0, 26, 16);
    rightView.centerY = self.centerY;
    self.rightView = rightView;
    self.rightViewMode = UITextFieldViewModeAlways;
    [rightView addTarget:self action:@selector(eyeWhiteClick:) forControlEvents:UIControlEventTouchDown];
}
//监听右边按钮的点击,切换密码输入明暗文状态
-(void)eyeWhiteClick:(UIButton *)btn{
    //解决明暗文切换后面空格的问题的两种方式
    //NSString* text = self.text;
    //self.text = @" ";
    //self.text = text;
    //[self becomeFirstResponder];
    [self resignFirstResponder];//取消第一响应者
    btn.selected = !btn.selected;
    if (!btn.selected) {
        [btn setImage:[UIImage imageNamed:@"eye_hide_white"] forState:UIControlStateNormal];
        self.secureTextEntry = YES;
    }else{
        [btn setImage:[UIImage imageNamed:@"eye_show_white"] forState:UIControlStateSelected];
        self.secureTextEntry = NO;
    }
    [self becomeFirstResponder];//放弃第一响应者
}


-(BOOL)isShowToolBar {
    return NO;
}
-(void)setIsShowToolBar:(BOOL)isShowToolBar {
    if (isShowToolBar) {
        self.inputAccessoryView = [self tooBarForKeyboardTools];
    }
}

-(UIToolbar *)tooBarForKeyboardTools {
    UIToolbar *bar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,44)];
    UIImageView *imageview = [[UIImageView alloc] init];
    imageview.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
    imageview.image = [UIImage xlsn0w_imageWithColor:NavBgColor];
    [bar addSubview: imageview];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60, 7,50, 30)];
    [button setTitle:@"隐藏"forState:UIControlStateNormal];
    [button addTarget:self action:@selector(hideKeyboardTools) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:TabBarTitleColor forState:UIControlStateNormal];
    [bar addSubview:button];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    UIBarButtonItem *flexibleitem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemFlexibleSpace) target:self action:nil];
    NSArray *items = @[flexibleitem,buttonItem];
    [bar setItems:items animated:YES];
    return  bar;
}
-(void)hideKeyboardTools {
    [self resignFirstResponder];
}
@end
