//
//  RQMBProgressHUD+RQ.h
//  IntelligentStreetLamp
//
//  Created by 瑞琪 on 2017/8/11.
//  Copyright © 2017年 cn.rich. All rights reserved.
//

#import "AlertHUD.h"

@interface AlertHUD (Extension)

+ (void)showSuccess:(NSString *)success;

+ (void)showSuccess:(NSString *)success toView:(UIView *)view;

+ (void)showError:(NSString *)error;

+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (void)showMessage:(NSString *)message toView:(UIView *)view;

+ (void)hideView;

+ (void)hideHUDForView:(UIView *)view;

@end
