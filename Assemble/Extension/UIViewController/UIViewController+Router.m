//
//  UIViewController+Router.m
//  TimeForest
//
//  Created by TimeForest on 2018/9/27.
//  Copyright © 2018年 TimeForest. All rights reserved.
//

#import "UIViewController+Router.h"
#import <objc/runtime.h>

//将会根据这个字符串来设置和获取值key。字符串的值value就是属性名。
// 定义关联的key
static const char *key = "params";

@implementation UIViewController (Router)

- (void)setParams:(NSDictionary *)params {
    objc_setAssociatedObject(self, key, params, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSDictionary *)params {
    return objc_getAssociatedObject(self, key);
}

@end
