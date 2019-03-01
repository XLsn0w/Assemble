
#import "RouterError.h"
#import "Router.h"

@implementation RouterError

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    static RouterError * routerError;
    dispatch_once(&onceToken,^{
        routerError = [[RouterError alloc] init];
    });
    return routerError;
}

#pragma mark  自定义错误页面 此页面一定确保能够找到，否则会进入死循环
-(UIViewController *)getErrorController{
    UIViewController *errorController = [[Router shared] getViewController:@"RouterErrorViewController" params:@{}];
    return errorController;
}
@end
