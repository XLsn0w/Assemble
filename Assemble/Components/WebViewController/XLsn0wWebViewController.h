/*XLsn0w*

 WebViewController *web = [[WebViewController alloc]init];
 // 隐藏导航条 注意隐藏导航条要在 appDelegate.m 中发送一个通知 SHOW_NAVBAR_NOTIFI, 以防在程序进入前台时导航条没有显示
 web.isHideNavigationBar = NO;
 
 //    web.canRefresh = YES;// 是否刷新
 //    web.canCopy = YES;
 //    // 1. 传 cookie
 //    web.cookieValue = [NSString stringWithFormat:@"%@=%@",@"testWKcookie", @"testWKcookievalue"];
 //    // WKUserScript 的 source 字符串
 //    web.sourceStr = [NSString stringWithFormat:@"document.cookie ='token=%@';document.cookie = 'os=ios';",@"你的token"];
 web.url = @"http://testwx-iacloud.ceway.com.cn/app-xproject-test/#/projectDetails?projectId=1de346efea1943d2b9d9942c171821b7&token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyIjp7InJlYWxOYW1lIjoi6YKx5YGlIiwibG9naW5OYW1lIjoiQ1c1MDk1IiwidXNlcklkIjo2MjAzMTR9LCJzdWIiOiIxNTA1NTI4MjU3MzI3IiwiaXNzIjoiY2V3YXkxMDAwIiwiYXVkIjoiVkpQWFVIVXF5MENVNEdWMGdjenFFakRCTlNTZFpXZlJpdEJkQ0pqaGNVVTBlcUdTNU5nYTBDSHFEZDFrUE9JWiJ9.CJ9oY-JCWJ2wLNJgIu5WNpP7WzdiA-SuIDbWYG6Zq64";
 [self.navigationController pushViewController:web animated:YES];
 // 2. 使用 UIWebView 做 cookie 请求 要调用 setCookie的方法
 //[web setCookieWithName:<#(NSString *)#> cookieValue:<#(NSString *)#> cookieDomain:<#(NSString *)#> cookieCommentURL:<#(NSString *)#> cookiePort:<#(NSString *)#>];
 */
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

// 显示导航条的通知
#define SHOW_NAVBAR_NOTIFI @"showNavigationBar"

@interface XLsn0wWebViewController : UIViewController

@property (nonatomic, weak) UIWebView *ui_webView;
@property (nonatomic, weak) WKWebView *wk_webView;


// 使用 UIWebView  默认使用 WKWebView
@property (nonatomic, assign) BOOL useUIWebView;

// 接口
@property (nonatomic, copy) NSString *url;

// 是否隐藏 nav
@property (nonatomic, assign) BOOL isHideNavigationBar;

// 是否能刷新
@property (nonatomic, assign) BOOL canRefresh;

// 进度条颜色
@property (nonatomic, weak) UIColor *progressViewColor;

// 打开js的复制黏贴功能
@property (nonatomic, assign) BOOL canCopy;

// 脚本字符串(cookie)
@property (nonatomic, copy) NSString *sourceStr;

// 重新刷新图片
@property (nonatomic, copy) NSString *reloadButtonImage;

// 开启侧滑手势
@property (nonatomic, assign) BOOL offPopGesture;

// 设置 cookieValue
@property (nonatomic, copy) NSString *cookieValue;

// 隐藏垂直滚动条
@property (nonatomic, assign) BOOL hideVScIndicator;
// 隐藏水平滚动条
@property (nonatomic, assign) BOOL hideHScIndicator;


// 设置 cookie
- (void)setCookieWithName:(NSString *)cookieName cookieValue:(NSString *)cookieValue cookieDomain:(NSString *)cookieDomain cookieCommentURL:(NSString *)cookieCommentURL cookiePort:(NSString *)cookiePort;


@end
