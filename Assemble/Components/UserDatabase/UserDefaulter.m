
#import "UserDefaulter.h"

@implementation UserDefaulter

/*
    NSUserDefaults 轻量级存储数据
 */
// NSUserDefaults 存
+ (void)insertValue:(id)value key:(NSString *)key {
    // 定义 轻量级存储 同步数据
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    // 存储数据 同步数据
    [defaults setObject:value forKey:key];
    [defaults synchronize];
}
// NSUserDefaults 取
+ (id)selectValueFromKey:(NSString *)key {
    // 定义 轻量级存储 同步数据
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    // 判断 key 是否存在
    BOOL isKey = [self getBoolValueForConfigurationKey:key];
    if (isKey) {
        // 用 Key 取出 Vlaue 同步数据
        return [defaults objectForKey:key];
    } else {
        // 不存在返回空 防止出现 null
        return nil;
    }
}
// NSUserDefaults 删
+ (void)removeValueFromKey:(NSString *)key {
    // 定义 轻量级存储 同步数据
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    // 判断 key 是否存在
    BOOL isKey = [self getBoolValueForConfigurationKey:key];
    if (isKey) {
        // 删除 key 同步数据
        [defaults removeObjectForKey:key];
        [defaults synchronize];
    }
}

+ (void)deleteValueForKey:(NSString *)key {
    [UserDefaulter removeValueFromKey:key];
}

// NSUserDefaults 判断轻量级中 是否存在 Key
+ (BOOL)getBoolValueForConfigurationKey:(NSString *)_key{
    BOOL isKey = false;
    // 定义 轻量级存储 同步数据
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    // 判断 key 是否存在
    if ([defaults objectForKey:_key]) {
        isKey = true;
    }
    return isKey;
}

@end
