//
//  UITableViewCell+AddSeparatorLine.m
//  TimeForest
//
//  Created by TimeForest on 2018/12/6.
//  Copyright © 2018 TimeForest. All rights reserved.
//

#import "UITableViewCell+AddSeparatorLine.h"
#import <objc/runtime.h>

@implementation UITableViewCell (AddSeparatorLine)

static char lineKey;
- (void)setLine:(UIView *)line {
    objc_setAssociatedObject(self, &lineKey, line, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIView *)line {
    return objc_getAssociatedObject(self, &lineKey);
}

- (void)remakeLineScreenWidth {
    [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
        make.bottom.mas_equalTo(0);
    }];
}

- (void)addLine {
    self.line = [[UIView alloc] init];
    [self addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
        make.bottom.mas_equalTo(0);
    }];
    self.line.backgroundColor = AppLineColor;
}

- (void)addTopSeparatorLine {
    self.line = [[UIView alloc] init];
    [self addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    self.line.backgroundColor = AppLineColor;
}

- (void)addBottomSeparatorLine {
    self.line = [[UIView alloc] init];
    [self addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    self.line.backgroundColor = AppLineColor;
}

- (void)removeLine {
    [self.line removeFromSuperview];
}

- (void)noneCellSelection {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
