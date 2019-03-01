
#import "AlertHUD+Extension.h"

@implementation AlertHUD (Extension)

+ (void)showText:(NSString *)text imageName:(NSString *)imageName view:(UIView *)view{
    if (view == nil) {
        view = [[UIApplication sharedApplication].windows lastObject];
    }
    AlertHUD *hud = [AlertHUD showHUDAddedTo:view animated:YES];
    //hud.color = [UIColor blackColor];
    hud.labelText = text;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    [hud setMode:RQMBProgressHUDModeCustomView];
    hud.removeFromSuperViewOnHide = YES;
    //[hud hideAnimated:YES afterDelay:1.0];
    [hud hide:YES afterDelay:1.0];
}

/**
 *  显示成功信息
 */
+ (void)showSuccess:(NSString *)success{
    [self showText:success imageName:@"success@2x" view:nil];
}

/**
 *  显示成功信息(自定义视图)
 */
+ (void)showSuccess:(NSString *)success toView:(UIView *)view{
    [self showText:success imageName:@"success@2x" view:view];
}

/**
 *  显示错误信息
 */
+ (void)showError:(NSString *)error{
    [self showText:error imageName:@"error@2x" view:nil];
}

/**
 *  显示错误信息(自定义视图)
 */
+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self showText:error imageName:@"error@2x" view:view];
}


/**
 *  显示加载信息(自定义视图)
 */
+ (void)showMessage:(NSString *)message toView:(UIView *)view{
    if (view == nil) {
        view = [[UIApplication sharedApplication].windows lastObject];
    }
    AlertHUD *hud = [AlertHUD showHUDAddedTo:view animated:YES];
    hud.labelText = message;
}

/**
 *  隐藏视图
 */
+ (void)hideView{
    [self hideHUDForView:nil];
}

/**
 *  隐藏视图(自定义视图)
 */
+ (void)hideHUDForView:(UIView *)view{
    [self hideHUDForView:view animated:YES];
}

@end
