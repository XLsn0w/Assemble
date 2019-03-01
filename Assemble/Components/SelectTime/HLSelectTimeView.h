//
//  HLSelectTimeView.h
//  Hoolink_IoT
//
//  Created by hoolink on 2018/6/12.
//  Copyright © 2018年 hoolink_IoT. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^HLSelectTimeViewBlock) (UIDatePicker *dateView);

@interface HLSelectTimeView : UIView
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, copy) HLSelectTimeViewBlock time_date;

@end
