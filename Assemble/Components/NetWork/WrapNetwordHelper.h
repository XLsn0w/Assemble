//
//  WrapNetwordHelper.h
//  Hoolink_IoT
//
//  Created by hoolink on 2018/5/18.
//  Copyright © 2018年 hoolink_IoT. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WrapNetwordHelper;

@protocol WrapNetwordHelperDelegate <NSObject>

//请求成功
-(void)networkRequestFinished:(WrapNetwordHelper *)request;

//请求失败
- (void)networkRequestFailed:(WrapNetwordHelper *)request;

@end

@interface WrapNetwordHelper : NSObject
//收集下载数据
@property (nonatomic, readonly) NSMutableData *respondsData;
//请求地址
@property (nonatomic, copy) NSString *requestString;

@property (nonatomic, weak) id <WrapNetwordHelperDelegate>delegate;

//请求对象的类型标识
@property (nonatomic,copy) NSString *requestType;

@property (nonatomic,strong)NSString *requestErrorStatus;
@property (nonatomic,strong)NSString *requestStatusCode;

@property (nonatomic, strong) NSDictionary *errorDict;

//get请求方法
+ (WrapNetwordHelper *)requestWithString:(NSString *)requestString andTarget:(id<WrapNetwordHelperDelegate>)delegate andRequestType:(NSString *)requestType;

// post请求
+ (WrapNetwordHelper *)requestWithString:(NSString *)requestString andBody:(NSDictionary *)bodyDict andTarget:(id<WrapNetwordHelperDelegate>)delegate andRequestType:(NSString *)requestType;

/*
 上传图片
 requestString: 请求地址
 fileArr: 上传图片data数组
 parameterDict: 其他非文件参数
 requestType: 请求类型
 */
+ (WrapNetwordHelper *)uploadWithUrl:(NSString *)requestString andFile:(NSArray *)fileArr andParameter:(NSDictionary *)parameterDict andTarget:(id<WrapNetwordHelperDelegate>)delegate andRequestType:(NSString *)requestType;
@end
