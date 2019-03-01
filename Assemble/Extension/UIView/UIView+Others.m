//
//  UIView+Others.m
//  Hoolink_IoT
//
//  Created by hoolink on 2018/5/16.
//  Copyright © 2018年 hoolink_IoT. All rights reserved.
//

#import "UIView+Others.h"

@implementation UIView (Others)
- (UIImage *)snapshotImage {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snap;
}

- (instancetype)cornerAllCornersWithCornerRadius:(CGFloat)cornerRadius {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    shapeLayer.path = path.CGPath;
    self.layer.mask = shapeLayer;
    return self;
}

@end
