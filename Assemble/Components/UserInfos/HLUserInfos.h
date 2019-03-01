//
//  HLUserInfos.h
//  Hoolink_IoT
//
//  Created by hoolink on 2018/5/24.
//  Copyright © 2018年 hoolink_IoT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HLUserInfos : NSObject
@property (nonatomic, copy) NSString *user_token;
@property (nonatomic, copy) NSString *user_usrId;

@property (nonatomic, copy) NSString *user_oder_wait_num;
@property (nonatomic, copy) NSString *user_oder_already_num;

+(instancetype)shareUserInfos;
//销毁
+ (void)destroyInstance;
@end
