
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define TFRouter [Router shared]

@interface Router : NSObject

+ (instancetype)shared;

/**
 返回一个初始化参数之后的控制器
 @param vcName 控制器名字
 @param params 初始化参数 字典格式
 @return 控制器实例
 */
- (UIViewController *)getViewController:(NSString *)vcName
                                 params:(NSDictionary *)params;

- (UIViewController *)getViewController:(NSString *)vcName;///无需参数

@end

/*
 一键使用
 [self.navigationController pushViewController:[[Router shared] getViewController:@"vcName" params:@{}] animated:true];
*/


