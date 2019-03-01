//
//  BaseView.m
//  TimeForest
//
//  Created by TimeForest on 2018/9/28.
//  Copyright © 2018年 TimeForest. All rights reserved.
//

#import "BaseView.h"

@implementation BaseView

- (void)clipRoundCornersFromView:(UIView*)view {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(6, 6)];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    
    maskLayer.frame = view.bounds;
    
    maskLayer.path = maskPath.CGPath;
    
    view.layer.mask = maskLayer;
}

- (void)call {
    UIWebView *callWebview = [[UIWebView alloc] init];
    [self addSubview:callWebview];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[[NSMutableString alloc] initWithFormat:@"tel:%@", @"4006379558"]]]];
}

- (void)loadDataFromModelArray:(NSMutableArray *)modelArray {
    
}

- (void)loadDataFromModel:(id)model {
    
}

- (void)loadDataFromDictionary:(NSDictionary *)dictionary {
    
}

- (void)loadDataFromArray:(NSArray *)array {
    
}

- (void)loadDataFromString:(NSString *)string {
    
}

- (void)showErrorView {
    
}

- (UINavigationController*)currentNav {
    return [self getCurrentVCWithCurrentView:self].navigationController;
}

- (UIViewController *)getCurrentVCWithCurrentView:(UIView *)currentView {
    for (UIView *next = currentView ; next ; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

- (void)drawSubviews {
    
}

@end
