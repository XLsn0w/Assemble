
#import "User.h"

@implementation User

- (instancetype)initWithKey:(NSInteger)key
                       name:(NSString *)name
                     phone:(NSString *)phone
                      email:(NSString *)email
                    account:(NSString *)account
                     number:(NSInteger)number {
    if (self = [super init]) {
        _key = key;
        _name = name;
        _number = number;
        _phone = phone;
        _email = email;
        _account = account;
    }
    return self;
}

@end
