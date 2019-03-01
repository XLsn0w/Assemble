
#import "BaseModel.h"

@implementation BaseModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

- (void)setValue:(id)value forKey:(NSString *)key {
    if ([value isKindOfClass:[NSNull class]]) {
        return;
    }
    [super setValue:value forKey:key];
}

//+ (NSDictionary *)modelCustomPropertyMapper {
//    return @{@"addressId":@"id"};
//}

@end
