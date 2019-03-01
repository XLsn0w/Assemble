#import "XLsn0wPay.h"
///引入SDK
#import <AlipaySDK/AlipaySDK.h>
#import <WXApi.h>

/**
 *  此处必须保证在Info.plist 中的 URL Types 的 Identifier 对应一致
 */
#define WeChat_URLTypesIdentifier @"wechatpay"
#define Alipay_URLTypesIdentifier @"alipay"

// 回调url地址为空
#define callBackURL @"url地址不能为空！"

// 订单信息为空字符串或者nil
#define orderMessage_nil @"订单信息不能为空！"
// 没添加 URL Types
#define addURLTypes @"请先在Info.plist 添加 URLTypes"
// 添加了 URL Types 但信息不全
#define addURLSchemes(URLTypes) [NSString stringWithFormat:@"请先在Info.plist对应的 URLTypes 添加 %@ 对应的 URL Schemes", URLTypes]

@interface XLsn0wPay () <WXApiDelegate>

// 缓存appScheme
@property (nonatomic, strong) NSMutableDictionary *Alipay_URL_Scheme_Dictionary;

/** 银联成功回调 */
@property (nonatomic, strong) UnionPayPayResult UPSuccess;
/** 银联失败回调 */
@property (nonatomic, strong) UnionPayPayResult UPFailure;

@end

@implementation XLsn0wPay

+ (instancetype)shared {
    static XLsn0wPay *xlsn0wPay;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        xlsn0wPay = [[self alloc] init];
    });
    return xlsn0wPay;
}

- (void)registerXLsn0wPay {
    NSString *Info_plist_path = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    NSDictionary *Info_plist_dic = [NSDictionary dictionaryWithContentsOfFile:Info_plist_path];
    NSArray *URL_Types_Array = Info_plist_dic[@"CFBundleURLTypes"];
    NSAssert(URL_Types_Array, addURLTypes);///断言 URLTypes不能为空
    
    for (NSDictionary *URL_Type_Dic in URL_Types_Array) {
        NSString *URL_Name = URL_Type_Dic[@"CFBundleURLName"];
        NSArray *URL_Schemes_Array = URL_Type_Dic[@"CFBundleURLSchemes"];
        NSAssert(URL_Schemes_Array.count, addURLSchemes(URL_Name));
        // 一般对应只有一个
        NSString *URL_Schemes = URL_Schemes_Array.lastObject;
        
        if ([URL_Name isEqualToString:WeChat_URLTypesIdentifier]) {//微信支付
            [self.Alipay_URL_Scheme_Dictionary setValue:URL_Schemes forKey:WeChat_URLTypesIdentifier];
            // 注册微信 appid 微信开发者ID即 WeChat URL Schemes
//            XLsn0wLog(@"微信开放平台App ID = %@", URL_Schemes);
            [WXApi registerApp:URL_Schemes];
            
        } else if ([URL_Name isEqualToString:Alipay_URLTypesIdentifier]){//支付宝
            // 保存支付宝scheme，以便发起支付使用
            //注意：这里的URL Schemes，在实际商户的app中要填写独立的scheme，建议跟商户的app有一定的标示度，
            //要做到和其他的商户app不重复，否则可能会导致支付宝返回的结果无法正确跳回商户app。
//            XLsn0wLog(@"支付宝开放平台App ID = %@", URL_Schemes);
            [self.Alipay_URL_Scheme_Dictionary setValue:URL_Schemes forKey:Alipay_URLTypesIdentifier];
            
        } else{
            
        }
    }
}

#pragma mark -- Setter & Getter

- (NSMutableDictionary *)Alipay_URL_Scheme_Dictionary {
    if (_Alipay_URL_Scheme_Dictionary == nil) {
        _Alipay_URL_Scheme_Dictionary = [NSMutableDictionary dictionary];
    }
    return _Alipay_URL_Scheme_Dictionary;
}

/*
 返回码    含义
 9000    订单支付成功
 8000    正在处理中，支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态
 4000    订单支付失败
 5000    重复请求
 6001    用户中途取消
 6002    网络连接出错
 6004    支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态
 其它    其它支付错误
 */
#pragma mark - 支付宝支付

- (void)AliPay:(NSString *)orderStr {///schemeStr 调用支付宝注册在info.plist中对应的URL Schemes = Alipay+AppID
    NSString* schemeStr = [self.Alipay_URL_Scheme_Dictionary objectForKey:Alipay_URLTypesIdentifier];
    XLsn0wLog(@"schemeStr=== %@", schemeStr);
    ///调起支付
    if (orderStr != nil && schemeStr != nil) {
        
        //调用支付结果开始支付
        //服务器 把订单签名后的字符串穿过来 然后在info URL Schemes里面配置统一的字符串
        //然后执行支付宝的 支付方法 在回调里面写支付结果的代码
        [[AlipaySDK defaultService] payOrder:orderStr fromScheme:schemeStr callback:^(NSDictionary *resultDic) {
            NSLog(@"resultDic=== %@", resultDic);
            NSLog(@"memo=== %@", resultDic[@"memo"]);
            NSLog(@"result=== %@", resultDic[@"result"]);
            NSLog(@"resultStatus=== %@", resultDic[@"resultStatus"]);
            NSInteger result = 0;
            NSString *message = @"";
            NSString *resultStatus = resultDic[@"resultStatus"];
            
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
            
            //NSDictionary *messageAsDictionary = @{@"result":@(result), @"message":message};
            
            
        }];
        
    }
    
}

#pragma mark - 微信支付
/*XLsn0w*
 
 prepayid（统一下单里返回的标识符），
 
 partnerid（商户号），
 
 appid，(微信开放平台App ID)
 
 package（微信要求必须有，内容是“Sign=WXPay”），
 
 noncestr（随机数，不适用微信返回的，是重新生成一个，注意!!!不是统一下单里的参数是nonce_str），
 
 timestamp（时间戳，十位，注意!!!不是统一下单里的时间是完整的时间，这里是时间戳），UInt32
 
 sign（签名，将上述字段重新签名，而不是用统一下单返回的sign）。
 
 */
- (void)WeChatPay:(NSDictionary *)dictionary {
    XLsn0wLog(@"timestamp class = %@", [dictionary[@"timestamp"] class]);
    PayReq *req = [[PayReq alloc] init];
    req.openID    = [dictionary objectForKey:@"appid"];//AppID
    req.partnerId = [dictionary objectForKey:@"partnerid"];
    req.prepayId  = [dictionary objectForKey:@"prepayid"];
    req.nonceStr  = [dictionary objectForKey:@"noncestr"];
    req.timeStamp = (UInt32)[dictionary[@"timestamp"] intValue];
    req.package   = [dictionary objectForKey:@"wxPackage"];
    req.sign      = [dictionary objectForKey:@"sign"];
    
    if ([WXApi isWXAppInstalled] == YES) {
        [WXApi sendReq:req];
    } else {
        [AlertShow showAlertText:@"微信未安装"];
    }
}

#pragma mark - 银联支付
/**
 银联支付(配置scheme = 工程名+Uppay)
 
 @param payOrder 订单号
 @param mode 模式 默认开发环境
 @param vc 调用的控制器
 @param success 成功回调
 @param failure 失败回调
 */
- (void)UnionPayPayWithOrder:(NSString *)payOrder
                        mode:(UPPaymentMode)mode
                          vc:(UIViewController *)vc
                     success:(UnionPayPayResult)success
                     failure:(UnionPayPayResult)failure {
    self.UPSuccess = success;
    self.UPFailure = failure;
    
    //    NSString *scheme = [NSString stringWithFormat:@"%@UpPay",[[NSBundle mainBundle] infoDictionary][@"CFBundleExecutable"]];
    //    [[UPPaymentControl defaultControl] startPay:payOrder fromScheme:scheme mode:mode == JJPayManagerModeDistribution ? @"00" : @"01" viewController:viewController];
}
/**
 银联支付（APP回调）AppDelegate用到
 
 @param paymentResult 支付回调URL
 */
- (BOOL)upPayProcessOrderWithPaymentResult:(NSURL *)paymentResult {
    //    [[UPPaymentControl defaultControl] handlePaymentResult:paymentResult completeBlock:^(NSString *code, NSDictionary *data) {
    //
    //        if ([code isEqualToString:@"success"]) {
    //            !self.upPaySuccessBlock ? : self.upPaySuccessBlock(code,data);
    //        } else if ([code isEqualToString:@"cancel"]) {
    //            !self.upPayFailureBlock ? : self.upPayFailureBlock(code,data);
    //        } else if ([code isEqualToString:@"fail"]) {
    //            !self.upPayFailureBlock ? : self.upPayFailureBlock(code,data);
    //        } else {
    //            !self.upPayFailureBlock ? : self.upPayFailureBlock(code,data);
    //        }
    //    }];
    return YES;
}

/** 处理AppDelegate中的回调

    if ([url.host isEqualToString:@"safepay"]) {
        //支付宝处理
        [self alipayProcessOrderWithPaymentResult:url];
        return YES;
    } else if ([url.host isEqualToString:@"pay"]) {
        //微信处理
        return [WXApi handleOpenURL:url delegate:self];
    } else if ([url.host isEqualToString:@"uppayresult"]) {
        //银联支付处理
       return [self upPayProcessOrderWithPaymentResult:url];
    } else {
        //第三方跳转处理
        return YES;
    }

*/

@end
