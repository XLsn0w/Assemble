//
//  AppDelegate+Pay.h
//  TimeForest
//
//  Created by TimeForest on 2018/10/19.
//  Copyright © 2018 TimeForest. All rights reserved.
//

#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (Pay) 

- (void)registerPay;
- (BOOL)AlipaySDKOpenURL:(NSURL *)url;

@end

NS_ASSUME_NONNULL_END
