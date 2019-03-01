//
//  UIView+Others.h
//  Hoolink_IoT
//
//  Created by hoolink on 2018/5/16.
//  Copyright © 2018年 hoolink_IoT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Others)
//截图
- (nullable UIImage *)snapshotImage;
- (instancetype _Nullable )cornerAllCornersWithCornerRadius:(CGFloat)cornerRadius;///绘制圆角

@end
