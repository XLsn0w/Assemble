//
//  XLsn0wPullMenuCell.h
//  Hoolink_IoT
//
//  Created by HL on 2018/8/1.
//  Copyright © 2018年 hoolink_IoT. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TapStatus)(BOOL selected);

@interface XLsn0wPullMenuCell : UITableViewCell

@property (nonatomic, copy) TapStatus action;

@property (nonatomic, strong) UILabel  *title;
@property (nonatomic, strong) UIButton *status;

@end
