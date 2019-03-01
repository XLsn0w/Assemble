
#import <Foundation/Foundation.h>

@interface UserDefaulter : NSObject

+ (void)insertValue:(id)value key:(NSString *)key;///存储对象
+ (id)selectValueFromKey:(NSString *)key;///取出对象
+ (void)deleteValueForKey:(NSString *)key;///删除对象

@end
