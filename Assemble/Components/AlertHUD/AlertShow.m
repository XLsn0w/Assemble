//
//  AlertShow.m
//  TimeForest
//
//  Created by TimeForest on 2018/10/10.
//  Copyright © 2018年 TimeForest. All rights reserved.
//

#import "AlertShow.h"


@implementation AlertShow

+ (void)showAlertText:(NSString *)text addedView:(UIView *)view {
    AlertHUD *progress = [AlertHUD showHUDAddedTo:view animated:YES];
    progress.mode = RQMBProgressHUDModeCustomView;
    progress.detailsLabelFont = [UIFont systemFontOfSize:15];
    progress.removeFromSuperViewOnHide = YES;
    progress.detailsLabelText = text;
    [progress hide:YES afterDelay:2];
}

+ (void)showAlertText:(NSString *)text {
    AlertHUD *progress = [AlertHUD showHUDAddedTo:kAppWindow animated:YES];
    progress.mode = RQMBProgressHUDModeCustomView;
    progress.detailsLabelFont = [UIFont systemFontOfSize:15];
    progress.removeFromSuperViewOnHide = YES;
    progress.detailsLabelText = text;
    [progress hide:YES afterDelay:2];
}

@end
