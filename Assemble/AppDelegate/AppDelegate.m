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

#import "AppDelegate.h"
#import "AppDelegate+GuidePage.h"
#import "AppDelegate+LaunchAD.h"
#import "AppDelegate+UMeng.h"
#import "AppDelegate+Config.h"
#import "AppDelegate+JPush.h"
#import "AppDelegate+Pay.h"

@interface AppDelegate () <WXApiDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self addUncaughtException];///添加未捕获的异常
    [self registerPay];///注册支付宝+微信支付
    [self initUmeng];///添加友盟分享
//    [self JPushWithOptions:launchOptions];///添加极光推送
//    [self addLaunchAD];///添加广告页
//    [self addGuidePage];///添加引导页
    [self initWindow];///设置根控制器
    [self showPrivateAlert];///显示隐私政策
    return YES;
}

///处理openURL
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    XLsn0wLog(@"url.absoluteString = %@", url.absoluteString);
    XLsn0wLog(@"url.host = %@", url.host);
    if ([url.absoluteString hasPrefix:WeChatAppKey]) {
        return [WXApi handleOpenURL:url delegate:self];
    } else if ([url.host isEqualToString:@"safepay"]) {
        [self AlipaySDKOpenURL:url];
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    if (self.isRotation) {
        //可以针对不同的界面创建不同的值，进行返回
        return UIInterfaceOrientationMaskLandscape;
    }
    return UIInterfaceOrientationMaskPortrait;
}

@end
