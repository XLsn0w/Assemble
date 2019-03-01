//
//  VerSionManage.m
//  eCarry
//
//  Created by main on 14-8-22.
//  Copyright (c) 2014年 whde. All rights reserved.
//

#import "XLsn0wCheckVersion.h"
#import <StoreKit/StoreKit.h>
#import "XLsn0wAlert.h"

static NSString * const skipVersionKey = @"skipVersionKey";

NSString * const VSERSION = @"Version";
NSString * const VSERSIONMANAGER = @"VersionManager";
static XLsn0wVersionManager *manager = nil;
@interface XLsn0wCheckVersion () <SKStoreProductViewControllerDelegate, UIAlertViewDelegate>{
    NSString *url_;
    NSMutableDictionary *versionManagerDic;
    NSString *_appstore_ID;
}
/**
 *  应用内打开Appstore
 */
- (void)openAppWithIdentifier;

/** appstore上的版本号 */
@property (nonatomic ,copy) NSString *storeVersion;
/** 更新的地址 */
@property (nonatomic ,copy) NSString *trackViewUrl;
/** 必须更新的弹出框 */
@property (nonatomic ,weak) UIAlertView *requiredAlert;
/** 可选更新的弹出框 */
@property (nonatomic ,weak) UIAlertView *optionalAlert;
@end
@implementation XLsn0wCheckVersion

+ (instancetype)shared {
    static XLsn0wCheckVersion *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[self alloc] init];
    });
    return singleton;
}

/**
 *   checkVerSion 设置中主动触发版本更新，
 */
- (void)checkUpdate {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:VSERSIONMANAGER];
        self->versionManagerDic = [NSMutableDictionary dictionaryWithCapacity:0];
        if (dic) {
            [self->versionManagerDic addEntriesFromDictionary:dic];
        }
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *appPackageName = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        NSString *firstLaunchKey = [NSString stringWithFormat:@"VersionManage_%@" , appPackageName];
        NSString *str = [self->versionManagerDic objectForKey:firstLaunchKey];
        if (![str boolValue]) {
            /*这个版本是第一次*/
            /*清除上一版本存储的信息*/
            /*第一次是NO*/
            /*第二次是YES*/
            [self->versionManagerDic removeAllObjects];
            [self->versionManagerDic setValue:@"YES" forKey:firstLaunchKey];
            [[NSUserDefaults standardUserDefaults] setValue:self->versionManagerDic forKey:VSERSIONMANAGER];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?bundleId=%@", [infoDictionary objectForKey:@"CFBundleIdentifier"]]];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/qq/id444934666?mt=8"]];
        NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error) {
                manager = nil;
            } else {
                NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
                NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
                XLsn0wLog(@"XLsn0wLog = %@", dic);
                NSArray *infoArray = [dic objectForKey:@"results"];
                if ([infoArray isKindOfClass:[NSArray class]] && [infoArray count]>0) {
                    NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
                    NSString *appstoreVersion = [releaseInfo objectForKey:@"version"];
                    self->url_ = [releaseInfo objectForKey:@"trackViewUrl"];
                    self->_appstore_ID = [NSString stringWithFormat:@"%@", [releaseInfo objectForKey:@"artistId"]];
                    if ([[self->versionManagerDic valueForKey:VSERSION] isEqual:appstoreVersion]) {
                        /*记录下来的和appstoreVersion相比, 相同的表示已经检查过的版本,不需要在去提示*/
                        manager = nil;
                        return ;
                    }
                    NSArray *appstoreVersionAry = [appstoreVersion componentsSeparatedByString:@"."];
                    NSInteger appstoreCount = [appstoreVersionAry count];
                    NSArray *currentVersionAry = [currentVersion componentsSeparatedByString:@"."];
                    NSInteger currentCount = [currentVersionAry count];
                    NSInteger count = currentCount>appstoreCount?appstoreCount:currentCount;
                    for (int i = 0; i<count; i++) {
                        if ([[appstoreVersionAry objectAtIndex:i] intValue]>[[currentVersionAry objectAtIndex:i] intValue]){
                            /*appstore版本有更新*/
                            /*记录下来版本号*/
                            [self->versionManagerDic setObject:appstoreVersion forKey:VSERSION];
                            [[NSUserDefaults standardUserDefaults] setValue:self->versionManagerDic forKey:VSERSIONMANAGER];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            dispatch_async(dispatch_get_main_queue(), ^{
#if __has_include(<Alert.h>)
                                // https://github.com/whde/Alert
                                VersionAlert *alert = [[VersionAlert alloc] initWithTitle:@"有新版本更新" message:[NSString stringWithFormat:@"更新内容:\n%@", releaseInfo[@"releaseNotes"]] delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:@"更新", nil];
                                [alert setContentAlignment:NSTextAlignmentLeft];
                                [alert setLineSpacing:5];
                                __weak __typeof__(self) weakSelf = self;
                                [alert setClickBlock:^(VersionAlert *alertView, NSInteger buttonIndex) {
                                    if (buttonIndex == 0) {
                                        manager = nil;
                                    } else {
                                        /*更新*/
                                        [weakSelf openAppWithIdentifier];
                                    }
                                }];
                                [alert show];
#else
                                if (iOS8Later) {
                                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"有新版本更新" message:[NSString stringWithFormat:@"更新内容:\n%@", releaseInfo[@"releaseNotes"]] preferredStyle:UIAlertControllerStyleAlert];
                                    [alert addAction:[UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                        /*关闭*/
                                        manager = nil;
                                    }]];
                                    [alert addAction:[UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                        /*更新*/
                                        [self openAppWithIdentifier];
                                    }]];
                                    UIWindow *window = nil;
                                    id<UIApplicationDelegate> delegate = [[UIApplication sharedApplication] delegate];
                                    if ([delegate respondsToSelector:@selector(window)]) {
                                        window = [delegate performSelector:@selector(window)];
                                    } else {
                                        window = [[UIApplication sharedApplication] keyWindow];
                                    }
                                    [window.rootViewController presentViewController:alert animated:YES completion:nil];
                                } else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_8_0
                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"有新版本更新" message:[NSString stringWithFormat:@"更新内容:\n%@", releaseInfo[@"releaseNotes"]] delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"更新", nil];
                                    [alert show];
#endif
                                }
#endif
                            });
                            return;
                        }else if ([[appstoreVersionAry objectAtIndex:i] intValue]<[[currentVersionAry objectAtIndex:i] intValue]){
                            /*本地版本号高于Appstore版本号,测试时候出现,不会提示出来*/
                            return;
                        }else{
                            continue;
                        }
                    }
                }
            }
        }];
        [dataTask resume];
    });
}

/**
 *  应用内打开Appstore
 */
- (void)openAppWithIdentifier{
    dispatch_async(dispatch_get_main_queue(), ^{
        SKStoreProductViewController *storeProductVC = [[SKStoreProductViewController alloc] init];
        NSDictionary *dict = [NSDictionary dictionaryWithObject:self->_appstore_ID forKey:SKStoreProductParameterITunesItemIdentifier];
        storeProductVC.delegate = self;
        [storeProductVC loadProductWithParameters:dict completionBlock:^(BOOL result, NSError *error) {
            if (result) {
                UIWindow *window = nil;
                id<UIApplicationDelegate> delegate = [[UIApplication sharedApplication] delegate];
                if ([delegate respondsToSelector:@selector(window)]) {
                    window = [delegate performSelector:@selector(window)];
                } else {
                    window = [[UIApplication sharedApplication] keyWindow];
                }
                [window.rootViewController presentViewController:storeProductVC animated:YES completion:nil];
            }
        }];
    });
}

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:nil];
    manager = nil;
}

#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_8_0
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        /*关闭*/
        manager = nil;
    } else {
        /*更新*/
        [self openAppWithIdentifier];
    }
}
#endif









- (void)checkVersion{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:[iOSDeviceInfo appUrlInItunes] parameters:nil progress:nil success:^(NSURLSessionDataTask *task,id responseObject) {
        XLsn0wLog(@"%@",responseObject);
        //1.是否请求成功
        if (((NSArray *)responseObject[@"results"]).count<=0) return;
        //2.获取appstore版本号和提示信息
        self.storeVersion = [(NSArray *)responseObject[@"results"] firstObject][@"version"];
        NSString *releaseNotes = [(NSArray *)responseObject[@"results"] firstObject][@"releaseNotes"];
        //3.获取跳过的版本号
        NSString *skipVersion = [[NSUserDefaults standardUserDefaults] valueForKey:skipVersionKey];
        //4.比较版本号
        XLsn0wLog(@"%@--%@",self.storeVersion,skipVersion);
        if ([self.storeVersion isEqualToString:skipVersion]) {//如果store和跳过的版本相同
            return;
        }else{
//            [self compareCurrentVersion:[iOSDeviceInfo appVersion] withAppStoreVersion:self.storeVersion updateMsg:releaseNotes];
        }
    } failure:nil];
}

- (void)checkServerVersion:(NSString *)serverVersion updateMsg:(NSString *)updateMsg title:(NSString *)title isForce:(BOOL)isForce url:(NSString *)url {
    [self compareCurrentVersion:[iOSDeviceInfo appVersion] withAppStoreVersion:serverVersion updateMsg:updateMsg title:title isForce:isForce url:url];
}

/**
 当前版本号和appstore比较
 
 @param currentVersion 当前版本
 @param appStoreVersion appstore上的版本
 @param updateMsg 更新内容
 */
- (void)compareCurrentVersion:(NSString *)currentVersion
          withAppStoreVersion:(NSString *)appStoreVersion
                    updateMsg:(NSString *)updateMsg
                        title:(NSString *)title
                      isForce:(BOOL)isForce
                          url:(NSString *)url {
//    NSMutableArray *currentVersionArray = [[currentVersion componentsSeparatedByString:@"."] mutableCopy];
//    NSMutableArray *appStoreVersionArray = [[appStoreVersion componentsSeparatedByString:@"."] mutableCopy];
//    if (!currentVersionArray.count ||!appStoreVersionArray.count) return;
//    //修订版本号
//    int modifyCount = abs((int)(currentVersionArray.count - appStoreVersionArray.count));
//    if (currentVersionArray.count > appStoreVersionArray.count) {
//        for (int index = 0; index < modifyCount; index ++) {
//            [appStoreVersionArray addObject:@"0"];
//        }
//    } else if (currentVersionArray.count < appStoreVersionArray.count) {
//        for (int index = 0; index < modifyCount; index ++) {
//            [currentVersionArray addObject:@"0"];
//        }
//    }
//
//    XLsn0wLog(@"XLsn0wLog [currentVersionArray.firstObject integerValue] = %@",  currentVersionArray);
//    XLsn0wLog(@"XLsn0wLog [appStoreVersionArray.firstObject integerValue] = %@", appStoreVersionArray);
//
//
    NSString* localVersion =  [currentVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSString* serverVersion = [appStoreVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    NSInteger localVersionInt =  [localVersion integerValue];
    NSInteger serverVersionInt = [serverVersion integerValue];
    
    
    if (localVersionInt < serverVersionInt) {///提示更新
        [self showUpdateAlertMust:isForce withStoreVersion:appStoreVersion message:updateMsg title:title url:url];
    } else if (localVersionInt == serverVersionInt) {///已经最新
        [self showAlreadyNew];
    } else {///已经最新
        [self showAlreadyNew];
    }
}

- (void)showAlreadyNew {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您的版本已经最新" delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil];
    [alert show];
}

- (void)exitApp {
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [UIView animateWithDuration:1.0f animations:^{
        show(@"正在退出...");
        window.alpha = 0;
        window.frame = CGRectMake(0, window.bounds.size.width, 0, 0);
    } completion:^(BOOL finished) {
        exit(0);
    }];
}

/**
 弹出提示框  是否更新
 
 @param must 是否强制更新  YES ->是的:NO -> 不是
 @param storeVersion 需要更新版本(store版本)
 @param message 提示信息
 */
- (void)showUpdateAlertMust:(BOOL)must withStoreVersion:(NSString *)storeVersion message:(NSString *)message title:(NSString *)title url:(NSString *)url {
//    NSString *title = [NSString stringWithFormat:@"最新版本:%@",storeVersion];
    @WeakObj(self);
    if (must) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *exitAction = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [selfWeak exitApp];
        }];
        [alertVC addAction:exitAction];
        
        UIAlertAction *updateAct = [UIAlertAction actionWithTitle:@"立即更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [selfWeak openAppStoreFromURL:url];
        }];
        [alertVC addAction:updateAct];
        [kAppWindow.rootViewController presentViewController:alertVC animated:YES completion:^{
            
        }];
    } else {
        UIAlertView *optionalAlert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"立即更新" otherButtonTitles:@"下次再说",@"跳过此版", nil];
        self.optionalAlert = optionalAlert;
        [optionalAlert show];
    }
    
    //1.强制更新
    
    
    //2.非强制更新
    
    //2.1 取消
    
    //2.2 忽略版本
    
    //2.3 更新
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    XLsn0wLog(@"%zd",buttonIndex);
//    if (self.requiredAlert == alertView) {//必须更新
//        [self openAppStoreToUpdate];
//    }else{//可选更新
//        if (0 == buttonIndex) {//立即更新
//            [self openAppStoreToUpdate];
//        }else if (1 == buttonIndex){//下次再说
//            XLsn0wLog(@"下次再说");
//        }else{//跳过此版本
//            [AppDefaults setObject:self.storeVersion forKey:skipVersionKey];
//            [AppDefaults synchronize];
//            XLsn0wLog(@"跳过此版本");
//        }
//    }
}

/**
 打开appstore 执行更新操作
 */
- (void)openAppStoreFromURL:(NSString*)url {
    XLsn0wLog(@"打开到appstore");
    NSURL *trackUrl = [NSURL URLWithString:url];
    if ([AppShared canOpenURL:trackUrl]) {
        [[UIApplication sharedApplication] openURL:trackUrl];
    }
}


@end
