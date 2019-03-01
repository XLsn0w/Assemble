//
//  AppDelegate+WebView.m
//  TimeForest
//
//  Created by TimeForest on 2018/10/18.
//  Copyright © 2018 TimeForest. All rights reserved.
//

#import "AppDelegate+WebView.h"

@implementation AppDelegate (WebView)

///H5为webview的请求添加userAgent，以用来识别操作系统等一下信息，app中创建的webview都会存在我们添加的userAgent的信息。
///userAgent 属性是一个只读的字符串，声明了浏览器用于 HTTP 请求的用户代理头的值。
- (void)userAgent {
    self.webView = [[WKWebView alloc] initWithFrame:CGRectZero];
    [self.webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id result, NSError *error) {
        if (error) { return; }
        NSString *userAgent = result;
        if (![userAgent containsString:@"/mobile-iOS"]) {
            userAgent = [userAgent stringByAppendingString:@"/mobile-iOS"];
            NSDictionary *dict = @{@"UserAgent": userAgent};
            [UserDefaulter insertValue:dict key:@"UserAgent"];
        }
    }];
}

@end
