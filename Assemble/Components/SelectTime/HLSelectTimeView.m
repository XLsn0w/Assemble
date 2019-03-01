//
//  HLSelectTimeView.m
//  Hoolink_IoT
//
//  Created by hoolink on 2018/6/12.
//  Copyright © 2018年 hoolink_IoT. All rights reserved.
//

#import "HLSelectTimeView.h"

@interface HLSelectTimeView ()


@property (nonatomic, weak) UIView *timeBk_view;
@property (nonatomic, weak) UIDatePicker *startDateView;

@end

@implementation HLSelectTimeView

-(id)init {
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        UIView *timeBk_view = [UIView new];
        timeBk_view.frame = CGRectMake(0, self.height+5, self.width, 220);
        timeBk_view.backgroundColor = [UIColor whiteColor];
        [self addSubview:timeBk_view];
        self.timeBk_view = timeBk_view;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        [self setUpTopUI];
    }
    return self;
}

-(void)setUpTopUI {
    UIView *topView = [UIView new];
    topView.frame = CGRectMake(0, 0, self.timeBk_view.width, 40);
    topView.backgroundColor = [UIColor whiteColor];
    UIView *lineView = [UIView new];
    lineView.frame = CGRectMake(0, 0, topView.width, 1);
    lineView.backgroundColor = LineColor;
    [topView addSubview:lineView];
    UIView *bottomLine = [UIView new];
    bottomLine.frame = CGRectMake(0, topView.height-1, topView.width, 1);
    bottomLine.backgroundColor = LineColor;
    [topView addSubview:bottomLine];
    
    [self.timeBk_view addSubview:topView];
    [self addTopButton:topView];
    [self setUpdateView:topView];
}

-(void)addTopButton:(UIView *)view {
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelBtn.frame = CGRectMake(15, 0, 56, view.height);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(onCancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitleColor:Font_otherColor2 forState:UIControlStateNormal];
    [view addSubview:cancelBtn];
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    confirmBtn.frame = CGRectMake(view.width- 15-56,0 , 56, view.height);
    [confirmBtn setTitleColor:Font_otherColor1 forState:UIControlStateNormal];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(onConfirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:confirmBtn];
    UILabel *title = [UILabel new];
    title.frame = CGRectMake(cancelBtn.right, 0, view.width- cancelBtn.right - confirmBtn.width-15, view.height);
    title.textColor = FontColor;
    title.font = FFont_15;
    title.text = @"";
    title.textAlignment = NSTextAlignmentCenter;
    [view addSubview:title];
    self.titleLabel = title;
    
    [self slipIntoTimeBK_view];
}

-(void)setUpdateView:(UIView *)view {
    UIDatePicker *startDateView = [[UIDatePicker alloc] init];
    startDateView.frame = CGRectMake(0, view.bottom, self.width, self.timeBk_view.height-view.bottom);
    startDateView.datePickerMode = UIDatePickerModeDateAndTime;
    [startDateView setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans_CN"]];
    startDateView.minimumDate = [NSDate date];
    self.startDateView = startDateView;
    [self.timeBk_view addSubview:startDateView];
    
}

-(void)slipIntoTimeBK_view {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    @WeakObj(self);
    [UIView animateWithDuration:0.2 animations:^{
        selfWeak.timeBk_view.y = selfWeak.height-220;
    }];
}

-(void)slipOutTimeBK_view {
    @WeakObj(self);
    [UIView animateWithDuration:0.2 animations:^{
        selfWeak.timeBk_view.y = selfWeak.height+5;
    } completion:^(BOOL finished) {
        [selfWeak removeFromSuperview];
    }];
}

-(void)onCancelButtonClick:(UIButton *)sender {
    [self slipOutTimeBK_view];
}

-(void)onConfirmButtonClick:(UIButton *)sender {
    if (self.time_date) {
        self.time_date(self.startDateView);
    }
    [self slipOutTimeBK_view];
}

-(void)dealloc {
    HLLog(@"dealloc");
}

@end
