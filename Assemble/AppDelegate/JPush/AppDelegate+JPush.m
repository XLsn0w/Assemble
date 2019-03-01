//                     _0_
//                   _oo0oo_
//                  o8888888o
//                  88" . "88
//                  (| -_- |)
//                  0\  =  /0
//                ___/`---'\___
//              .' \\|     |// '.
//             / \\|||  :  |||// \
//            / _||||| -:- |||||- \
//           |   | \\\  -  /// |   |
//           | \_|  ''\---/''  |_/ |
//           \  .-\__  '-'  ___/-. /
//         ___'. .'  /--.--\  `. .'___
//      ."" '<  `.___\_<|>_/___.' >' "".
//     | | :  `- \`.;`\ _ /`;.`/ - ` : | |
//     \  \ `_.   \_ __\ /__ _/   .-` /  /
// NO---`-.____`.___ \_____/___.-`___.-'---BUG
//                   `=---='

#import "AppDelegate+JPush.h"

@implementation AppDelegate (JPush)

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    HLLog(@"推送的通知------%@",userInfo);
    
    if (application.applicationState == UIApplicationStateActive) {
        [JPUSHService setBadge:0];
//        [[NSNotificationCenter defaultCenter]postNotificationName:kNotification_JPUSH_foreground object:userInfo];
    } else {
//        [[NSNotificationCenter defaultCenter]postNotificationName:kNotification_JPUSH_daemons object:userInfo];
        HLLog(@"程序在后台运行");
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        [JPUSHService setBadge:0];
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
    HLLog(@"收到通知:%@", userInfo);
}

//极光推送
- (void)JPushWithOptions:(NSDictionary *)launchOptions {
    //可以添加自定义categories
    [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:nil];
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:JPushAppKey channel:@"Publish channel" apsForProduction:NO advertisingIdentifier:nil];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [JPUSHService setLogOFF];
    [JPUSHService setBadge:0];
    /// 登录成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkDidLoginMessage:) name:kJPFNetworkDidLoginNotification object:nil];
}

- (void)networkDidLoginMessage:(NSNotification *)notification {
    HLLog(@"registrationID===%@",[JPUSHService registrationID]);
    NSString *registrationId = [NSString stringWithFormat:@"%@",[JPUSHService registrationID]?[JPUSHService registrationID]:@""];
    [UserSharedDefaults setObject:registrationId forKey:JPush_registrationID];
    [UserSharedDefaults synchronize];
    [UserDefaulter insertValue:registrationId key:@"UserSharedDefaults"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kJPFNetworkDidLoginNotification object:nil];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [JPUSHService registerDeviceToken:deviceToken];
}

@end
