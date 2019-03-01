//
//  AppDelegate+Pay.m
//  TimeForest
//
//  Created by TimeForest on 2018/10/19.
//  Copyright © 2018 TimeForest. All rights reserved.
//

#import "AppDelegate+Pay.h"

@interface AppDelegate () <WXApiDelegate>

@end

@implementation AppDelegate (Pay)

- (void)registerPay {
    [XLsn0wSharedPay registerXLsn0wPay];
}

#pragma mark 跳转处理
//被废弃的方法. 但是在低版本中会用到.建议写上
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [WXApi handleOpenURL:url delegate:self];
}
//被废弃的方法. 但是在低版本中会用到.建议写上

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [WXApi handleOpenURL:url delegate:self];
}

#pragma mark - iOS 9.0 & iOS 10.0 微信&支付宝回调函数
// 9000    订单支付成功
// 8000    正在处理中，支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态
// 4000    订单支付失败
// 5000    重复请求
// 6001    用户中途取消
// 6002    网络连接出错
// 6004    支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态
// 其它    其它支付错误
- (BOOL)AlipaySDKOpenURL:(NSURL *)url {
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        NSLog(@"resultDic=== %@", resultDic);
        NSLog(@"memo=== %@", resultDic[@"memo"]);
        NSLog(@"result=== %@", resultDic[@"result"]);
        NSLog(@"resultStatus=== %@", resultDic[@"resultStatus"]);
        
        NSString *resultStatus = resultDic[@"resultStatus"];
        NSString *message = [NSString string];
        NSInteger result = 0;
        switch (resultStatus.integerValue) {
                
            case 9000:    //支付成功
                result = 0;
                message = @"支付成功";
                break;
                
            case 8000:
                result = 10;
                message = @"正在处理中，支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态";
                break;
                
            case 4000:
                result = 10;
                message = @"订单支付失败";
                break;
                
            case 5000:
                result = 10;
                message = @"重复请求";
                break;
                
            case 6001:
                result = 10;
                message = @"用户中途取消";
                break;
                
                
            case 6002:
                result = 10;
                message = @"网络连接出错";
                break;
                
            case 6004:
                result = 10;
                message = @"支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态";
                break;
                
            default:
                result = 10;
                message = @"支付失败";
                break;
        }
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
        
        XLsn0wLog(@"AlipaySDK支付回调: 状态码:%ld - 描述信息: %@", result, message);
        PostNotification(AlipaySDKNotification, (@{@"message":message, @"payName":@"支付宝"}))
    }];
    
    return YES;
}

#pragma mark - 微信支付回调代理方法 WXApiDelegate
//WXSuccess           =  0,   成功
//WXErrCodeCommon     = -1,   普通错误类型
//WXErrCodeUserCancel = -2,   用户点击取消并返回
//WXErrCodeSentFail   = -3,   发送失败
//WXErrCodeAuthDeny   = -4,   授权失败
//WXErrCodeUnsupport  = -5,   微信不支持
- (void)onResp:(BaseResp *)resp {
    // 判断支付类型
    if([resp isKindOfClass:[PayResp class]]){
        //支付回调
        NSInteger result = 0;
        NSString *message = resp.errStr;

        switch (resp.errCode) {
                
            case 0:
                message = @"支付成功";
                result = 0;
                break;
                
            case -1:
                message = @"支付失败";
                result = 10;
                break;
                
            case -2:
                message = @"用户中途取消";
                result = 10;
                break;
                
            case -3:
                message = @"发送失败";
                result = 10;
                break;
                
            case -4:
                message = @"授权失败";
                result = 10;
                break;
                
            case -5:
                message = @"微信不支持";
                result = 10;
                break;
                
            default:
                message = resp.errStr;
                result = 10;
                break;
        }
        
        NSLog(@"微信支付回调: 状态码:%ld - 描述信息: %@", result, message);
        //发出通知 从微信回调回来之后,发一个通知,让请求支付的页面接收消息,并且展示出来,或者进行一些自定义的展示或者跳转
        PostNotification(WechatOpenSDKNotification, (@{@"message":message, @"payName":@"微信支付"}));
    }
}

@end
