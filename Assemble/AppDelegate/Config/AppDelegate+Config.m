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
#import "AppDelegate+Config.h"
#import "CodeLoginViewController.h"
#import "UserManager.h"

@implementation AppDelegate (Config)

#pragma mark ****** 初始化window ****
- (void)initWindow {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [self addLoginStatusNotificationAndSetRootViewController];
    [[UserPlist shared] createUserPlist];
    [HTTPManager checkingNetworkResult:^(NetworkStatus status) {
        if (status == StatusNotReachable) {
            [AlertShow showAlertText:@"网络断开"];
        }
        if (status == StatusUnknown) {
            [AlertShow showAlertText:@"未知网络"];
        }
    }];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
}

/*XLsn0w*
 ///接收登录状态通知
 */
- (void)addLoginStatusNotificationAndSetRootViewController {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                                 name:KNotificationLoginStateChange
                                               object:nil];///必须先添加观察者
    PostNotification(KNotificationLoginStateChange, @YES);///然后发通知才有执行者
}

- (void)dealloc {
    [NotificationShared removeObserver:self];
}

#pragma mark ————— 登录状态处理 —————
- (void)loginStateChange:(NSNotification *)notifiction {
    BOOL isLoginSuccess = [notifiction.object boolValue];
    if (isLoginSuccess) {/// 登陆成功加载主窗口控制器
        [self setRootViewControllerEqualToTabBarController];
    } else {
        [self setRootViewControllerEqualToLoginViewController];
    }
}

- (void)setRootViewControllerEqualToTabBarController {
    ///为避免自动登录成功刷新tabbar
    if (!self.tabBarController || ![self.window.rootViewController isKindOfClass:[MainTabBarController class]]) {
        self.tabBarController = [[MainTabBarController alloc]init];
        CATransition *anima = [CATransition animation];
        anima.type = TrAnimaType_Fade;//设置动画的类型
        anima.subtype = kCATransitionFromRight; //设置动画的方向
        anima.duration = 0.5f;
        self.window.rootViewController = self.tabBarController;
        [kAppWindow.layer addAnimation:anima forKey:@"revealAnimation"];
    }
}

- (void)setRootViewControllerEqualToLoginViewController {
    [UserDefaulter deleteValueForKey:@"token"];
    self.tabBarController = nil;
    CodeLoginViewController *login_vc =[[CodeLoginViewController alloc] init];
    BaseNavigationController *loginNav = [[BaseNavigationController alloc] initWithRootViewController:login_vc];
    CATransition *anima = [CATransition animation];
    anima.type = TrAnimaType_Fade;//设置动画的类型
    anima.subtype = kCATransitionFromRight; //设置动画的方向
    anima.duration = 0.3f;
    self.window.rootViewController = loginNav;
    [kAppWindow.layer addAnimation:anima forKey:@"revealAnimation"];
}

#pragma mark ————— 初始化服务 —————

- (void)showPrivateAlert {
    [self getPrivacyWebURL];
    NSString* agreeCallback = [UserDefaulter selectValueFromKey:@"agreeCallback"];
    if (!agreeCallback) {
        NSArray* contents = @[@"        时间林会尽全力保护您的个人信息安全可靠，恪守以下原则，保护您的个人信息：权责一致原则、目的明确原则、选择同意原则、最少够用原则、确保安全原则、主体参与原则、公开透明原则等。同时，我们承诺，我们将按业界成熟的安全标准，采取相应的安全保护措施来保护您的个人信息。"];
        PrivateAlertService* alert = [PrivateAlertService new];
        ///取到NavigationController
        BaseNavigationController * nav = (BaseNavigationController *)[self getNavigationController];
        UIViewController * visibleVC = (UIViewController *)nav.visibleViewController;
        ///显示隐私弹窗
        [alert showWith:contents
                     in:visibleVC.view
          agreeCallback:^{
              [UserDefaulter insertValue:@"agreeCallback" key:@"agreeCallback"];///同意
          } disAgreeCallback:^{
              UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"退出应用警告"
                                                                             message:@"您不同意《隐私政策》将会退出应用"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
              UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
              UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                  [self exitApp];///不同意->退出App
              }];
              [alert addAction:cancelAction];
              [alert addAction:okAction];
              [visibleVC presentViewController:alert animated:YES completion:nil];
          } privateProCallback:^{///跳转隐私协议
              ProtocolsWebViewController *vc = [[ProtocolsWebViewController alloc] init];
              vc.isHideNavigationBar = NO;
              vc.canRefresh = NO;// 是否刷新
              vc.title = @"隐私政策";
              if (isNotNull(self.privacyWebUrl)) {
                  vc.url = self.privacyWebUrl;
              }
              [[self getNavigationController] pushViewController:vc animated:true];
          }];
    }
}

- (UINavigationController *)getNavigationController {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    if ([window.rootViewController isKindOfClass:[UINavigationController class]]) {
        
        return (UINavigationController *)window.rootViewController;
        
    } else if ([window.rootViewController isKindOfClass:[UITabBarController class]]) {
        
        UIViewController *selectedVC = [((UITabBarController *)window.rootViewController)selectedViewController];
        
        if ([selectedVC isKindOfClass:[UINavigationController class]]) {
            
            return (UINavigationController *)selectedVC;
        }
    }
    return nil;
}

- (void)getPrivacyWebURL {
    @WeakObj(self);
    [HTTPSharedManager GET:HTTPAPI(privacyWebURL)
                Parameters:@{}
                   Success:^(id responseObject) {
                       if (isNotNull(responseObject[@"success"])) {
                           if ([responseObject[@"success"] boolValue] == true) {
                               if (isNotNull(responseObject[@"data"])) {
                                   selfWeak.privacyWebUrl = responseObject[@"data"];
                               }
                           }
                       }
                   } Failure:^(NSError *error) {
                       
                   }];
}

- (void)exitApp {
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [UIView animateWithDuration:1.0f animations:^{
        window.alpha = 0;
        show(@"正在退出...");
    } completion:^(BOOL finished) {
        exit(0);
    }];
}

- (void)initService {
    //注册登录状态监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                                 name:KNotificationLoginStateChange
                                               object:nil];
    
    //网络状态监听
    [NotificationShared addObserver:self selector:@selector(netWorkStateChange:) name:KNotificationNetWorkStateChange object:nil];
}

#pragma mark ————— 初始化window —————
- (void)initAppConfig {
    [[UIButton appearance] setExclusiveTouch:YES];
    [[UIButton appearance] setShowsTouchWhenHighlighted:YES];
    [[UIView appearance] setExclusiveTouch:YES];
    [UIActivityIndicatorView appearanceWhenContainedInInstancesOfClasses:@[[MBProgressHUD class]]].color = KWhiteColor;;
    if (@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    [self config_estimatedHeight];
//    IQKeyboardSharedManager.enable = YES;
//    IQKeyboardSharedManager.shouldResignOnTouchOutside = YES;
//    IQKeyboardSharedManager.shouldToolbarUsesTextFieldTintColor = YES;
}

#pragma mark ————— 初始化网络配置 —————
-(void)NetWorkConfig{
    
}

-(void)config_estimatedHeight {
    [UITableView appearance].estimatedRowHeight = 0;
    [UITableView appearance].estimatedSectionHeaderHeight = 0;
    [UITableView appearance].estimatedSectionFooterHeight = 0;
}

- (void)addUncaughtException {
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);///捕获异常
}

void UncaughtExceptionHandler(NSException *exception) {
    XLsn0wLog(@"exception(异常信息) = %@", exception);
    //[UserDefaulter insertValue:exception key:@"exception"];
    ///存储 exception  上传服务器 或者保存本地
}

#pragma mark ————— 初始化用户系统 —————
-(void)configLogin {
    
    
    if([userManager loadUserInfo]){
        
        //如果有本地数据，先展示TabBar 随后异步自动登录
        self.tabBarController = [MainTabBarController new];
        self.window.rootViewController = self.tabBarController;
        
        //自动登录
        [userManager autoLoginToServer:^(BOOL success, NSString *des) {
            if (success) {
                DLog(@"自动登录成功");
                //                    [MBProgressHUD showSuccessMessage:@"自动登录成功"];
                PostNotification(KNotificationAutoLoginSuccess, nil);
            }else{
                [MBProgressHUD showErrorMessage:NSStringFormat(@"自动登录失败：%@",des)];
            }
        }];
        
    }else{
        //没有登录过，展示登录页面
        PostNotification(KNotificationLoginStateChange, @NO)
        //        [MBProgressHUD showErrorMessage:@"需要登录"];
    }
}

#pragma mark ————— 网络状态变化 —————
- (void)netWorkStateChange:(NSNotification *)notification
{
    BOOL isNetWork = [notification.object boolValue];
    
    if (isNetWork) {//有网络
        if ([userManager loadUserInfo] && !isLogin) {//有用户数据 并且 未登录成功 重新来一次自动登录
            [userManager autoLoginToServer:^(BOOL success, NSString *des) {
                if (success) {
                    DLog(@"网络改变后，自动登录成功");
                    //                    [MBProgressHUD showSuccessMessage:@"网络改变后，自动登录成功"];
                    PostNotification(KNotificationAutoLoginSuccess, nil);
                }else{
                    [MBProgressHUD showErrorMessage:NSStringFormat(@"自动登录失败：%@",des)];
                }
            }];
        }
        
    }else {//登陆失败加载登陆页面控制器
        //        [MBProgressHUD showTopTipMessage:@"网络状态不佳" isWindow:YES];
    }
}

#pragma mark ————— 友盟 初始化 —————
-(void)initUMeng{
    /* 打开调试日志 */
    [[UMSocialManager defaultManager] openLog:YES];
    
    /* 设置友盟appkey */
    //    [[UMSocialManager defaultManager] setUmSocialAppkey:UMengKey];
    
    [self configUSharePlatforms];
}
#pragma mark ————— 配置第三方 —————
-(void)configUSharePlatforms{
    /* 设置微信的appKey和appSecret */
    //    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:kAppKey_Wechat appSecret:kSecret_Wechat redirectURL:nil];
    /*
     * 移除相应平台的分享，如微信收藏
     */
    //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     */
    //    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:kAppKey_Tencent/*设置QQ平台的appID*/  appSecret:nil redirectURL:nil];
}

#pragma mark ————— OpenURL 回调 —————
//// 支持所有iOS系统。注：此方法是老方法，建议同时实现 application:openURL:options: 若APP不支持iOS9以下，可直接废弃当前，直接使用application:openURL:options:
//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
//{
//    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
//    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
//    if (!result) {
//        // 其他如支付等SDK的回调
//    }
//    return result;
//}
//
//// NOTE: 9.0以后使用新API接口
//- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
//{
//    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
//    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url options:options];
//    if (!result) {
//        // 其他如支付等SDK的回调
//        if ([url.host isEqualToString:@"safepay"]) {
//            //跳转支付宝钱包进行支付，处理支付结果
//            //            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//            //                NSLog(@"result = %@",resultDic);
//            //            }];
//            return YES;
//        }
//        //        if  ([OpenInstallSDK handLinkURL:url]){
//        //            return YES;
//        //        }
//        //        //微信支付
//        //        return [WXApi handleOpenURL:url delegate:[PayManager sharedPayManager]];
//    }
//    return result;
//}

#pragma mark ————— 网络状态监听 —————
- (void)monitorNetworkStatus
{
    
}

+ (AppDelegate *)shared {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}


-(UIViewController *)getCurrentVC{
    
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

-(UIViewController *)getCurrentUIVC
{
    UIViewController  *superVC = [self getCurrentVC];
    
    if ([superVC isKindOfClass:[UITabBarController class]]) {
        
        UIViewController  *tabSelectVC = ((UITabBarController*)superVC).selectedViewController;
        
        if ([tabSelectVC isKindOfClass:[UINavigationController class]]) {
            
            return ((UINavigationController*)tabSelectVC).viewControllers.lastObject;
        }
        return tabSelectVC;
    }else
        if ([superVC isKindOfClass:[UINavigationController class]]) {
            
            return ((UINavigationController*)superVC).viewControllers.lastObject;
        }
    return superVC;
}



@end
