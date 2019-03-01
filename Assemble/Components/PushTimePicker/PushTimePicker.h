//
//  PushTimePicker.h
//  Hoolink_IoT
//
//  Created by HL on 2018/6/21.
//  Copyright © 2018年 hoolink_IoT. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PushTimePickerBlock)(void);

@interface PushTimePicker : UIButton

@property (nonatomic, copy) PushTimePickerBlock action;

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIDatePicker *startDateView;
@property (nonatomic, strong) UIDatePicker *endDateView;
@property (nonatomic, strong) UILabel *startlabel;

- (void)show;
- (void)remove;

@end
