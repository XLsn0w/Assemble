
#import "NativeNetworking.h"

#define Request_timeoutInterval 10 // 联网时间

@interface NativeNetworking ()

@property (nonatomic, strong) UIActivityIndicatorView* loadingView;
@property (nonatomic, assign) int maskCount;

@end

@implementation NativeNetworking

+ (instancetype)shared {
    static NativeNetworking *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[self alloc] init];
    });
    return singleton;
}

- (instancetype)init {
    if (self = [super init]) {
        _loadingView = [[UIActivityIndicatorView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _loadingView.color = [UIColor blackColor];
    }
    return self;
}

#pragma MARK-- GET

- (void)GET:(NSString *)urlString params:(NSDictionary *)params success:(SuccessAction)success failure:(FailureAction)failure {

    NSURL *url;
    NSString *paramsString = [NSString string];
    if (params) {//带字典参数
        paramsString = [self nsdictionaryToNSStting:params];
        //1. GET 请求，直接把请求参数跟在URL的后面以？(问号前是域名与/接口名)隔开，多个参数之间以&符号拼接
        url = [NSURL URLWithString:[self urlConversionFromOriginalURL:[NSString stringWithFormat:@"%@?%@", urlString, paramsString]]];
    }else{
        //1. GET 请求，直接把请求参数跟在URL的后面以？(问号前是域名与/接口名)隔开，多个参数之间以&符号拼接
        url = [NSURL URLWithString:[self urlConversionFromOriginalURL:urlString]];
    }
    //2. 创建请求对象内部默认了已经包含了请求头和请求方法(GET）的对象
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:Request_timeoutInterval];
    
    /*   设置请求头  */
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"UTF_8" forHTTPHeaderField:@"charset"];
    NSString *token = [UserDefaulter selectValueFromKey:@"token"];
    XLsn0wLog(@"token = %@", token);
    if (token) {
        [request setValue:token forHTTPHeaderField:@"token"];
    }

    
    //4. 根据会话对象创建一个task任务(发送请求）
    [self dataTaskWithRequest:request style:NativeNetworkingLoadingViewStyleNotTouch responType:NativeNetworkingResponseObjectTypeJSON success:success headerField:nil failure:failure];
}

- (void)POST:(NSString *)urlString params:(NSDictionary *)params success:(SuccessAction)success failure:(FailureAction)failure {
    //POST请求需要修改请求方法为POST，并把参数转换为二进制数据设置为请求体
    NSURL *url = [NSURL URLWithString:[self urlConversionFromOriginalURL:urlString]];
    //2.创建可变的请求对象
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:Request_timeoutInterval];
    /*   设置请求头  */
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"UTF_8" forHTTPHeaderField:@"charset"];
    NSString *token = [UserDefaulter selectValueFromKey:@"token"];
    XLsn0wLog(@"token = %@", token);
    if (token) {
        [request setValue:token forHTTPHeaderField:@"token"];
    }
    request.HTTPMethod =@"POST";
    
    if (params) {
        NSString *paramsString = [self nsdictionaryToNSStting:params];
        
        request.HTTPBody = [paramsString dataUsingEncoding:NSUTF8StringEncoding];
    }
    //6.根据会话对象创建一个Task(发送请求）
    
    [self dataTaskWithRequest:request style:NativeNetworkingLoadingViewStyleNotTouch responType:NativeNetworkingResponseObjectTypeJSON success:success headerField:nil failure:failure];
}

- (void)GET:(NSString *)urlString params:(NSDictionary *)params loadingViewStyle:(NativeNetworkingLoadingViewStyle)style responseType:(NativeNetworkingResponseObjectType)type success:(SuccessAction)successBlock requestHead:(HeaderFieldAction)requestHeadBlock faile:(FailureAction)faileBlock {
    NSURL *url;
    NSString *paramsString = [NSString string];
    if (params) {//带字典参数
        paramsString = [self nsdictionaryToNSStting:params];
        //1. GET 请求，直接把请求参数跟在URL的后面以？(问号前是域名与/接口名)隔开，多个参数之间以&符号拼接
        url = [NSURL URLWithString:[self urlConversionFromOriginalURL:[NSString stringWithFormat:@"%@?%@", urlString, paramsString]]];
    }else{
        //1. GET 请求，直接把请求参数跟在URL的后面以？(问号前是域名与/接口名)隔开，多个参数之间以&符号拼接
        url = [NSURL URLWithString:[self urlConversionFromOriginalURL:urlString]];
    }
    //2. 创建请求对象内部默认了已经包含了请求头和请求方法(GET）的对象
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:Request_timeoutInterval];
    
    /*   设置请求头  */
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"UTF_8" forHTTPHeaderField:@"charset"];
    NSString *token = [UserDefaulter selectValueFromKey:@"token"];
    XLsn0wLog(@"token = %@", token);
    if (token) {
        [request setValue:token forHTTPHeaderField:@"token"];
    }
 
    
    //4. 根据会话对象创建一个task任务(发送请求）
    [self dataTaskWithRequest:request style:style responType:type success:successBlock headerField:requestHeadBlock failure:faileBlock];
}

#pragma MARK-- POST

-(void)POST:(NSString *)urlString params:(NSDictionary *)params loadingViewStyle:(NativeNetworkingLoadingViewStyle)style responseType:(NativeNetworkingResponseObjectType)type success:(SuccessAction)successBlock requestHead:(HeaderFieldAction)requestHeadBlock failure:(FailureAction)faileBlock {
    //POST请求需要修改请求方法为POST，并把参数转换为二进制数据设置为请求体
    NSURL *url = [NSURL URLWithString:[self urlConversionFromOriginalURL:urlString]];
    //2.创建可变的请求对象
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:Request_timeoutInterval];
    /*   设置请求头  */
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"UTF_8" forHTTPHeaderField:@"charset"];
    NSString *token = [UserDefaulter selectValueFromKey:@"token"];
    XLsn0wLog(@"token = %@", token);
    if (token) {
        [request setValue:token forHTTPHeaderField:@"token"];
    }
    request.HTTPMethod =@"POST";
 
    if (params) {
        NSString *paramsString = [self nsdictionaryToNSStting:params];
        
        request.HTTPBody = [paramsString dataUsingEncoding:NSUTF8StringEncoding];
    }
    //6.根据会话对象创建一个Task(发送请求）
    
    [self dataTaskWithRequest:request style:style responType:type success:successBlock headerField:requestHeadBlock failure:faileBlock];
}


////根据会话对象创建一个Task(发送请求）

- (void)dataTaskWithRequest:(NSMutableURLRequest *)request style:(NativeNetworkingLoadingViewStyle)style responType:(NativeNetworkingResponseObjectType)responType success:(SuccessAction)respone headerField:(HeaderFieldAction)headerField failure:(FailureAction)fail{

    //3.创建会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    /*
         
              第一个参数：请求对象
         
              第二个参数：completionHandler回调（请求完成【成功|失败】的回调）
         
              data：响应体信息（期望的数据）
         
              response：响应头信息，主要是对服务器端的描述
         
              error：错误信息，如果请求失败，则error有值
         
              */
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *_Nullable data, NSURLResponse *_Nullable response, NSError * _Nullable error) {
        [self stopAnimation:style];
        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        XLsn0wLog(@"result = %@",result);
        // 解析服务器返回的数据(返回的数据为JSON格式，因此使用NSJNOSerialization进行反序列化)

        id dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        XLsn0wLog(@"response = %@",response);
        
        NSHTTPURLResponse* httpURLResponse =(NSHTTPURLResponse *)response;
        NSDictionary *allHeaderFields = httpURLResponse.allHeaderFields;
//        XLsn0wLog(@"Content-Type = %@", allHeaderFields[@"Content-Type"]);
        
        if (!error) {
            if (responType == NativeNetworkingResponseObjectTypeJSON) {//返回JSON
                respone(dict);
            }else{
                respone(data);//返回二进制
                
            }
        }else{
            fail(error);
            NSLog(@"网络请求失败");
        }

        if (response) {
            if (headerField != nil) {
                headerField(allHeaderFields);
            }
        }
    }];
    
    [self showAnimation:style];
    [dataTask resume];
    
}









#pragma MARK -- 菊花

// 添加菊花

- (void)showAnimation:(NativeNetworkingLoadingViewStyle)maskType {
    if (maskType !=NativeNetworkingLoadingViewStyleNone) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible =true;
            [[UIApplication sharedApplication].keyWindow addSubview:self.loadingView];
  
            self.loadingView.hidden =NO;
            [self.loadingView startAnimating];
            self.loadingView.userInteractionEnabled = (maskType ==NativeNetworkingLoadingViewStyleNotTouch ?YES : NO);
            self.maskCount++;
        });
    }
}

// 移除菊花

- (void)stopAnimation:(NativeNetworkingLoadingViewStyle)maskType {
    if (maskType !=NativeNetworkingLoadingViewStyleNone) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.maskCount--;
            if (self.maskCount <=0) {
                [UIApplication sharedApplication].networkActivityIndicatorVisible =false;
                [self.loadingView stopAnimating];
                self.loadingView.hidden =YES;
                [self.loadingView removeFromSuperview];
            }
        });
    }
}

#pragma MARK -- 把字典拼成字符串

- (NSString *)nsdictionaryToNSStting:(NSDictionary *)param {
    NSMutableString *string = [NSMutableString string];
    //便利字典把键值平起来
    [param enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key, id _Nonnull obj, BOOL *_Nonnull stop) {
        [string appendFormat:@"%@:", key];
        [string appendFormat:@"%@",  obj];
        [string appendFormat:@"%@",  @"&"];
    }];
    // 去掉最后一个&
    NSRange rangeLast = [string rangeOfString:@"&"options:NSBackwardsSearch];
    if (rangeLast.length !=0) {
        [string deleteCharactersInRange:rangeLast];
    }
    NSLog(@"string:%@",string);
    NSRange range =NSMakeRange(0, [string length]);
    [string replaceOccurrencesOfString:@":"withString:@"="options:NSCaseInsensitiveSearch range:range];

    
    return string;
    
}





// 如果URL有中文，转换成百分号

- (NSString *)urlConversionFromOriginalURL:(NSString *)originalURL {
    return [originalURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

#pragma mark NSURLSession Delegate

/* 收到身份验证 ssl */

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition,NSURLCredential * _Nullable))completionHandler {

    NSLog(@"didReceiveChallenge %@", challenge.protectionSpace);
    NSLog(@"调用了最外层");

    // 1.判断服务器返回的证书类型,是否是服务器信任
//    NSURLSessionAuthChallengeUseCredential = 0,
//    使用证书         NSURLSessionAuthChallengePerformDefaultHandling = 1,
//    忽略证书(默认的处理方式)         NSURLSessionAuthChallengeCancelAuthenticationChallenge = 2,
//    忽略书证,并取消这次请求         NSURLSessionAuthChallengeRejectProtectionSpace = 3,
//    拒绝当前这一次,下一次再询问
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {///调用了里面这一层是服务器信任的证书
        NSURLCredential *card = [[NSURLCredential alloc]initWithTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential , card);
    }
}

@end



