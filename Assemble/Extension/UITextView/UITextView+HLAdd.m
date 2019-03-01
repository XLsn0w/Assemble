//
//  UITextView+HLAdd.m
//  Hoolink_IoT
//
//  Created by hoolink on 2018/6/5.
//  Copyright © 2018年 hoolink_IoT. All rights reserved.
//

#import "UITextView+HLAdd.h"

@implementation UITextView (HLAdd)
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
