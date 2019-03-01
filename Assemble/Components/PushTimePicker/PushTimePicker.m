//
//  PushTimePicker.m
//  Hoolink_IoT
//
//  Created by HL on 2018/6/21.
//  Copyright © 2018年 hoolink_IoT. All rights reserved.
//

#import "PushTimePicker.h"

@implementation PushTimePicker

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [self addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
        [self drawUI];
    }
    return self;
}

- (void)drawUI {
    _backgroundView = [UIView new];
    _backgroundView.frame = CGRectMake(0, SCREEN_HEIGHT-340, SCREEN_WIDTH, 340);
    _backgroundView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_backgroundView];
    
    UIView *toolBar = [UIView new];
    toolBar.frame = CGRectMake(0, 0, self.width, 40);
//    toolBar.backgroundColor = HLMyHexRGB(0xf4f4f4);
    [_backgroundView addSubview:toolBar];
    
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    cancleBtn.frame = CGRectMake(15, 0, 46, 40);
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
//    [cancleBtn setTitleColor:HLMyHexRGB(0x999999) forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:cancleBtn];
    
    UIButton *confirm = [UIButton buttonWithType:UIButtonTypeSystem];
    confirm.frame = CGRectMake(self.width-15 -46, 0, 46, 40);
//    [confirm setTitleColor:HLMyHexRGB(0xFF6600) forState:UIControlStateNormal];
    [confirm setTitle:@"确定" forState:UIControlStateNormal];
    [confirm addTarget:self action:@selector(onConfirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:confirm];
    
    UILabel *startlabel = [[UILabel alloc] init];
    startlabel.frame = CGRectMake(0, toolBar.bottom, 60, (_backgroundView.height - toolBar.bottom)/2.f);
    [_backgroundView addSubview:startlabel];
    startlabel.font = FFont_13;
    startlabel.textAlignment = NSTextAlignmentCenter;
//    startlabel.textColor = Font_otherColor2;
    startlabel.text = @"起始时间";
    self.startlabel = startlabel;
    
    UILabel *endlabel = [[UILabel alloc] init];
    endlabel.frame = CGRectMake(0, startlabel.bottom, startlabel.width, startlabel.height);
    endlabel.font = FFont_12;
    endlabel.textAlignment = NSTextAlignmentCenter;
//    endlabel.textColor = Font_otherColor2;
    endlabel.text = @"结束时间";
    [_backgroundView addSubview:endlabel];
    [self addDatePicker];
}

- (void)show {
    [UIView animateWithDuration:0.1 animations:^{
        [kKeyWindow addSubview:self];
    } completion:^(BOOL finished){

    }];
}

- (void)remove {
    [UIView animateWithDuration:0.1 animations:^{
        [self removeFromSuperview];
    } completion:^(BOOL finished){
        
    }];
}

-(void)addDatePicker {
    self.startDateView = [[UIDatePicker alloc] init];
    [_backgroundView addSubview:self.startDateView];
    self.startDateView.frame = CGRectMake(60, self.startlabel.y, self.width-45, 150);
    self.startDateView.datePickerMode = UIDatePickerModeTime;
    [self.startDateView addTarget:self action:@selector(pickerValueChange:) forControlEvents:UIControlEventValueChanged];
    
    self.endDateView = [[UIDatePicker alloc] init];
    [_backgroundView addSubview:self.endDateView];
    self.endDateView.frame = CGRectMake(60, self.startDateView.bottom, self.startDateView.width, 150);
    self.endDateView.datePickerMode = UIDatePickerModeTime;
    [self.endDateView addTarget:self action:@selector(pickerValueChange:) forControlEvents:UIControlEventValueChanged];
}

- (void)onConfirmButtonClick:(UIButton *)sender {
    if (self.action) {
        self.action();
        [self remove];
    }
}

- (void)pickerValueChange:(UIDatePicker *)sender  {
    if (sender == self.startDateView) {
        self.endDateView.minimumDate = sender.date;
    }else if(sender == self.endDateView) {
        self.startDateView.maximumDate = sender.date;
    }
}

-(void)dealloc {
    HLLog(@"dealloc");
    [self removeFromSuperview];
}


@end
