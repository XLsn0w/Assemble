#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define XLsn0wSharedPay [XLsn0wPay shared]

/**
 *  回调状态码
 */
typedef NS_ENUM(NSInteger, XLsn0wPayResult){
    XLsn0wPayResultSuccess,// 成功
    XLsn0wPayResultFailure,// 失败
    XLsn0wPayResultCancel  // 取消
};

typedef void(^XLsn0wPayResultCallBack)(XLsn0wPayResult payResult, NSString *errorMessage);

@interface XLsn0wPay : NSObject

//支付结果缓存回调
@property (nonatomic, copy) XLsn0wPayResultCallBack callBack;

+ (instancetype)shared;

- (void)registerXLsn0wPay;///注册App，需要在 didFinishLaunchingWithOptions中调用

///调起微信支付
- (void)AliPay:(NSString *)orderStr;
///调起支付宝
- (void)WeChatPay:(NSDictionary *)dictionary;

#pragma mark - 银联支付
typedef NS_ENUM(NSInteger, UPPaymentMode) {
    UPPaymentMode_Development,
    UPPaymentMode_Distribution
};

/**
 银联支付回调
 
 @param code 错误代码
 @param data 成功返回数据
 */
typedef void(^UnionPayPayResult)(NSString *code,NSDictionary *data);

/**
 银联支付(配置scheme = 工程名+Uppay)
 
 @param payOrder 订单号
 @param mode 模式 默认开发环境
 @param viewController 调用的控制器
 @param success 成功回调
 @param failure 失败回调
 */
- (void)UnionPayPayWithOrder:(NSString *)payOrder
                        mode:(UPPaymentMode)mode
                          vc:(UIViewController *)vc
                     success:(UnionPayPayResult)success
                     failure:(UnionPayPayResult)failure;

@end
