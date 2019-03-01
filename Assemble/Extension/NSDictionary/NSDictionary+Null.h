//
//  NSDictionary+Null.h
//  Hoolink_IoT
//
//  Created by HL on 2018/6/29.
//  Copyright © 2018年 hoolink_IoT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Null)

/*
 *把服务器返回的 替换为“”
 *json表示获取到的带有NULL对象的json数据
 *NSDictionary *newDict = [NSDictionary changeType:json];
 */
+(id)changeType:(id)myObj;

@end
