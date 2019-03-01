//
//  UserPlist.h
//  TimeForest
//
//  Created by TimeForest on 2018/10/24.
//  Copyright © 2018 TimeForest. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define UserSharedPlist [UserPlist shared]

@interface UserPlist : NSObject

+ (instancetype)shared;
- (void)createUserPlist;
- (void)insertUserId:(NSNumber*)userId
                name:(NSString *)name
                 sex:(NSString *)sex
            username:(NSString *)username
        headportrait:(NSString *)headportrait;
- (id)selectValueForKey:(NSString *)key;

- (NSNumber*)userId;

- (NSString*)name;

- (NSString*)sex;

- (NSString*)birthday;

- (NSString*)username;

- (NSString*)headportrait;



@end

NS_ASSUME_NONNULL_END
