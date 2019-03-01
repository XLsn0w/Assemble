
#import "QiniuUpload.h"
#import "QiniuSDK.h"

#define image_prefix_domain_name   @"http://img.timewoods.com/" ///七牛官网 内容管理-外链默认域名 图片地址的前半部分，拼起来就是完整地址 。

@implementation QiniuUpload

-(void)downloadImage:(NSString*)path {

    
    NSURL * url = [NSURL URLWithString:path];
    
    NSURLSession * session = [NSURLSession sharedSession];
    
    NSURLSessionDownloadTask * downloadTask = [session downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //location 下载到沙盒的地址
        NSLog(@"下载完成%@",location);
        
        NSLog(@"response = %@",response);
        
        //得到了JSON文件 解析就好了。
//        id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
//
//        NSLog(@"%@", result);
        
        //response.suggestedFilename 响应信息中的资源文件名
        NSString * cachesPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];
        
        NSLog(@"缓存地址%@",cachesPath);
        
        //获取文件管理器
        NSFileManager * mgr = [NSFileManager defaultManager];
        //将临时文件移动到缓存目录下
        //[NSURL fileURLWithPath:cachesPath] 将本地路径转化为URL类型
        //URL如果地址不正确，生成的url对象为空
        
        [mgr moveItemAtURL:location toURL:[NSURL fileURLWithPath:cachesPath] error:NULL];
        
    }];
    
    [downloadTask resume];
}

+ (void)uploadImage:(UIImage*)image {
    [HTTPSharedManager GET:QiniuTokenURL
                Parameters:@{}
                   Success:^(id responseObject) {
                       NSString *token = responseObject[@"data"];
                       QNConfiguration *config = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
                           builder.zone = [QNFixedZone zone0];
                       }];
                       QNUploadManager *upManager = [[QNUploadManager alloc] initWithConfiguration:config];
                       NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
                       [upManager putData:imageData key:[QiniuUpload keyQiniuImageName] token:token
                                 complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                                     XLsn0wLog(@"info= %@", info);
                                     XLsn0wLog(@"resp= %@", resp);
                                     XLsn0wLog(@"key= %@", key);
                                 } option:nil];
                   } Failure:^(NSError *error) {
                       
                   }];
}

- (NSString*)token {
    [HTTPSharedManager GET:QiniuTokenURL
                Parameters:@{}
                   Success:^(id responseObject) {
                       
                       
                   } Failure:^(NSError *error) {
                       
                   }];
    return @"";
}

-(NSString *)UIImageToBase64Str:(UIImage *) image {
    NSData *data = UIImageJPEGRepresentation(image, 1.0f);
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return encodedImageStr;
}

//字符串转图片
-(UIImage *)Base64StrToUIImage:(NSString *)_encodedImageStr {
    NSData *_decodedImageData = [[NSData alloc] initWithBase64Encoding:_encodedImageStr];
    UIImage *_decodedImage = [UIImage imageWithData:_decodedImageData];
    return _decodedImage;
}

+ (NSString *)marshal{
    
    NSInteger _expire = 0;
    time_t deadline;
    time(&deadline);//返回当前系统时间
    //@property (nonatomic , assign) int expires; 怎么定义随你...
    deadline += (_expire > 0) ? _expire : 3600; // +3600秒,即默认token保存1小时.
    NSNumber *deadlineNumber = [NSNumber numberWithLongLong:deadline];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setObject:@"修改成七牛存储空间的名字" forKey:@"scope"];//根据
    [dic setObject:deadlineNumber forKey:@"deadline"];
    NSString *json = [QiniuUpload convertToJsonData:dic ];
    
    return json;
}

+ (void)uploadImages:(NSArray *)imageArray
             success:(UploadSuccessBlock)success
             failure:(UploadFailureBlock)failure {
    
    [HTTPSharedManager GET:HTTPAPI(QiniuTokenURL)
                Parameters:@{}
                   Success:^(id responseObject) {
                       NSString *token = responseObject[@"data"];
                       NSMutableArray *imageAddArray   = [NSMutableArray array];
                       
                       //主要是把图片或者文件转成nsdata类型就可以了
                       QNConfiguration *config = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
                           builder.zone = [QNFixedZone zone0];
                       }];
                       QNUploadManager *upManager = [[QNUploadManager alloc] initWithConfiguration:config];
                       QNUploadOption *uploadOption = [[QNUploadOption alloc] initWithMime:nil
                                                                           progressHandler:^(NSString *key, float percent) {
                                                                               NSLog(@"上传进度 %.2f", percent);
                                                                           }
                                                                                    params:nil
                                                                                  checkCrc:NO
                                                                        cancellationSignal:nil];
                       
                       [imageArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                           NSLog(@"imageArray_idx = %ld",idx);
                           NSData *data;
                           if (UIImagePNGRepresentation(obj) == nil){
                               data = UIImageJPEGRepresentation(obj, 1);
                           } else {
                               data = UIImagePNGRepresentation(obj);
                           }
                           
                           [upManager putData:data
                                          key:[QiniuUpload keyQiniuImageName]
                                        token:token
                                     complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                                         XLsn0wLog(@"七牛图片名称 = %@", [NSString stringWithFormat:@"%@%@", image_prefix_domain_name, resp[@"key"]]);
                                         XLsn0wLog(@"七牛返回信息 = %@", info);
                                         if (info.isOK) {
                                             [imageAddArray addObject:[NSString stringWithFormat:@"%@%@", image_prefix_domain_name, resp[@"key"]]];
                                         }else{
                                             [imageAddArray addObject:[NSString stringWithFormat:@"%ld",idx]];
                                             
                                         }
                                         if (imageAddArray.count == imageArray.count) {
                                             if (imageAddArray.count == 1) {
                                                 if (success) {
                                                     success([imageAddArray componentsJoinedByString:@""]);
                                                 }
                                             } else {
                                                 if (success) {
                                                     success([imageAddArray componentsJoinedByString:@";"]);
                                                 }
                                             }
                                         }
                                     } option:uploadOption];
                           
                       }];
                       
                   } Failure:^(NSError *error) {
                       
                   }];
}

+ (NSString *)keyQiniuImageName {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *now = [formatter stringFromDate:[NSDate date]];
    NSString *number = [QiniuUpload generateTradeNO];
    //当前时间
    NSInteger interval = (NSInteger)[[NSDate date]timeIntervalSince1970];
    NSString *name = [NSString stringWithFormat:@"iOS_%@_%ld%@.png", now, interval, number];
    return name;
}

+ (NSString *)qnVideoFilePatName{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *now = [formatter stringFromDate:[NSDate date]];
    NSString *number = [QiniuUpload generateTradeNO];
    //当前时间
    NSInteger interval = (NSInteger)[[NSDate date]timeIntervalSince1970];
    NSString *name = [NSString stringWithFormat:@"Video/%@/%ld%@.mp4",now,interval,number];
    //    NSString *name = [NSString stringWithFormat:@"Video/%ld%@%@.mp4",interval,number,now];
    
    NSLog(@"%@",name);
    
    return name;
}

+ (NSString *)qnAmrFilePatName{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *now = [formatter stringFromDate:[NSDate date]];
    NSString *number = [QiniuUpload generateTradeNO];
    //当前时间
    NSInteger interval = (NSInteger)[[NSDate date]timeIntervalSince1970];
    NSString *name = [NSString stringWithFormat:@"Voice/%@/%ld%@.amr",now,interval,number];
    
    return name;
}

+(NSString *)convertToJsonData:(NSDictionary *)dict{
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
}

+ (NSString *)generateTradeNO {
    static int kNumber = 8;
    NSString *sourceStr = @"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++) {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    NSLog(@"%@",resultStr);
    return resultStr;
    
}

@end
