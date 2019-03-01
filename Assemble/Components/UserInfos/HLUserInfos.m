//
//  HLUserInfos.m
//  Hoolink_IoT
//
//  Created by hoolink on 2018/5/24.
//  Copyright © 2018年 hoolink_IoT. All rights reserved.
//

#import "HLUserInfos.h"

@implementation HLUserInfos
static HLUserInfos *_instance;
static dispatch_once_t onceToken;
+(instancetype)allocWithZone:(struct _NSZone *)zone {
    dispatch_once(&onceToken, ^{
        if (_instance == nil) {
            _instance = [super allocWithZone:zone];
            _instance.user_usrId = @"";
            _instance.user_token = @"";
            _instance.user_oder_wait_num = @"0";
            _instance.user_oder_already_num= @"0";
        }
    });
    return _instance;
}

+(instancetype)shareUserInfos {
    return [[self alloc]init];
}

-(id)copyWithZone:(NSZone *)zone {
    return _instance;
}
-(id)mutableCopyWithZone:(NSZone *)zone
{
    return _instance;
}

+ (void)destroyInstance {
    _instance = nil;
    onceToken = 0;
}
@end
