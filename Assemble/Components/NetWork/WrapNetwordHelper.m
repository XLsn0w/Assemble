//
//  WrapNetwordHelper.m
//  Hoolink_IoT
//
//  Created by hoolink on 2018/5/18.
//  Copyright © 2018年 hoolink_IoT. All rights reserved.
//

#import "WrapNetwordHelper.h"
#import "AFNetworking.h"
#import "HLUserInfos.h"
#import <UIKit/UIKit.h>

#define URLSTRING(requestString) [requestString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]

@implementation WrapNetwordHelper

-(id)init {
    self = [super init];
    if (self) {
        _respondsData = [NSMutableData new];
    }
    return self;
}

-(void)afGetrequestWithString:(NSString *)requestString {
    @WeakObj(self);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setTimeoutInterval:30.0];//设置请求超时
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:URLSTRING(requestString) parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [_respondsData appendData:responseObject ];
        if ([_delegate respondsToSelector:@selector(networkRequestFinished:)]) {
            [_delegate networkRequestFinished:selfWeak];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([_delegate respondsToSelector:@selector(networkRequestFailed:)]) {
            [_delegate networkRequestFailed:selfWeak];
        }
    }];
}

//get请求方法
+ (WrapNetwordHelper *)requestWithString:(NSString *)requestString andTarget:(id<WrapNetwordHelperDelegate>)delegate andRequestType:(NSString *)requestType {
    HLLog(@"网址===%@",requestString);
    WrapNetwordHelper *request = [[WrapNetwordHelper alloc] init];
    request.delegate = delegate;
    request.requestType = requestType;
    request.requestString = requestString;
    [request afGetrequestWithString:requestString];
    return request;
}

// post请求
+ (WrapNetwordHelper *)requestWithString:(NSString *)requestString andBody:(NSDictionary *)bodyDict andTarget:(id<WrapNetwordHelperDelegate>)delegate andRequestType:(NSString *)requestType {
    HLLog(@"网址===%@",requestString);
    WrapNetwordHelper *request = [[WrapNetwordHelper alloc] init];
    request.delegate = delegate;
    request.requestType = requestType;
    request.requestString = requestString;
    [request afrequestWithString:requestString andBody:bodyDict];
    return request;
}
-(void)afrequestWithString:(NSString *)requestString andBody:(NSDictionary *)bodyDict {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"X-Mobile"];
    [manager.requestSerializer setValue:@"UTF_8" forHTTPHeaderField:@"charset"];
    @WeakObj(self);
    if (![requestString isEqualToString:@"HL_Login_Url"]) {
        [manager.requestSerializer setValue:[HLUserInfos shareUserInfos].user_token forHTTPHeaderField:@"X-Token"];
    }
    HLLog(@"[HLUserInfos shareUserInfos].user_token ========%@",[HLUserInfos shareUserInfos].user_token);
    [manager.requestSerializer setTimeoutInterval:30.0];//设置请求超时
    [manager POST:URLSTRING(requestString) parameters:bodyDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [_respondsData appendData:responseObject];
        if ([_delegate respondsToSelector:@selector(networkRequestFinished:)]) {
            [_delegate networkRequestFinished:selfWeak];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        HLLog(@"%@",error);
//        NSData *data = error.userInfo[@"com.alamofire.serialization.response.error.response"];
        HLLog(@"%@",error.userInfo[@"com.alamofire.serialization.response.error.response"]);
        NSHTTPURLResponse *response = error.userInfo[@"com.alamofire.serialization.response.error.response"];
        HLLog(@"==%ld",(long)response.statusCode);
        selfWeak.requestStatusCode = [NSString stringWithFormat:@"%ld",(long)response.statusCode];
//        if (data.length !=0) {
//            id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//            HLLog(@"error.userInfo === %@",result);
//            if ([result isKindOfClass:[NSDictionary class]]) {
//                NSDictionary *resultD = result[@"result"];
//                self.errorDict = resultD;
//                self.requestErrorStatus = [NSString stringWithFormat:@"%@",resultD[@"status"]?resultD[@"status"]:@""];
//            }
//        }
        if ([_delegate respondsToSelector:@selector(networkRequestFailed:)]) {
            [_delegate networkRequestFailed:selfWeak];
        }
    }];
}

// 上传图片
+ (WrapNetwordHelper *)uploadWithUrl:(NSString *)requestString andFile:(NSArray *)fileArr andParameter:(NSDictionary *)parameterDict andTarget:(id<WrapNetwordHelperDelegate>)delegate andRequestType:(NSString *)requestType{
    HLLog(@"上传图片网址===%@",requestString);
    WrapNetwordHelper *request = [[WrapNetwordHelper alloc] init];
    request.requestString = requestString;
    request.delegate = delegate;
    request.requestType = requestType;
    [request afuploadWithUrl:requestString andFile:fileArr andParameter:parameterDict];
    return request;
}
-(void)afuploadWithUrl:(NSString *)requestString andFile:(NSArray *)fileArr andParameter:(NSDictionary *)parameterDict {
    @WeakObj(self);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"image/jpeg",nil];
    manager.requestSerializer= [AFHTTPRequestSerializer serializer];
    manager.responseSerializer= [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setTimeoutInterval:30.0];//设置请求超时
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"X-Mobile"];
    [manager.requestSerializer setValue:[HLUserInfos shareUserInfos].user_token forHTTPHeaderField:@"X-Token"];
    [manager POST:URLSTRING(requestString) parameters:parameterDict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i<fileArr.count; i++) {
            NSData *data = fileArr[i];
            [formData appendPartWithFileData:data name:@"partFile" fileName:[NSString stringWithFormat:@"hoolink%d.jpeg",i] mimeType:@"image/jpeg"];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [_respondsData appendData:responseObject ];
        if ([_delegate respondsToSelector:@selector(networkRequestFinished:)]) {
            [_delegate networkRequestFinished:selfWeak];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([_delegate respondsToSelector:@selector(networkRequestFailed:)]) {
            [_delegate networkRequestFailed:selfWeak];
        }
    }];
}
@end
