//
//  AlertShow.h
//  TimeForest
//
//  Created by TimeForest on 2018/10/10.
//  Copyright © 2018年 TimeForest. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlertShow : NSObject

+ (void)showAlertText:(NSString *)text;
+ (void)showAlertText:(NSString *)text addedView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
