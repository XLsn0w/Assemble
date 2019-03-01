//
//  XLsn0wPullMenuCell.m
//  Hoolink_IoT
//
//  Created by HL on 2018/8/1.
//  Copyright © 2018年 hoolink_IoT. All rights reserved.
//

#import "XLsn0wPullMenuCell.h"

@implementation XLsn0wPullMenuCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = HexColor(@"#333333");
        [self drawSubviews];
    }
    return self;
}

- (void)drawSubviews {
     _status = [UIButton new];
    [self addSubview:_status];
    [_status mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(22);
        make.height.mas_equalTo(22);
    }];
    [_status addTarget:self action:@selector(statusSEL:) forControlEvents:(UIControlEventTouchUpInside)];
    
    _title = [[UILabel alloc] init];
    [self addSubview:_title];
    
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_status.mas_right).offset(10);
        make.centerY.mas_equalTo(self);
        make.height.mas_equalTo(12);
    }];
    [_title addTextFont:[UIFont systemFontOfSize:13] textColor:[UIColor xlsn0w_hexString:@"#333333"]];
}

- (void)statusSEL:(UIButton*)btn {
    btn.selected = !btn.selected;
    if (self.action) {
        self.action(btn.selected);
    }
}

@end
