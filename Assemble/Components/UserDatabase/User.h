
#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, assign) NSInteger key;///数据库主键

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *account;
@property (nonatomic, assign) NSInteger number;
@property (nonatomic, assign) NSInteger userId;

//自定义初始化方法
- (instancetype)initWithKey:(NSInteger)key
                       name:(NSString *)name
                      phone:(NSString *)phone
                      email:(NSString *)email
                    account:(NSString *)account
                     number:(NSInteger)number;



@end
