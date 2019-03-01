
#import "Router.h"
#import "RouterError.h"

///去除警告⚠️
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

@implementation Router

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    static Router* router;
    dispatch_once(&onceToken,^{
        router = [[self alloc] init];
    });
    return router;
}

- (UIViewController *)getViewController:(NSString *)vcName {
    Class class = NSClassFromString(vcName);
    UIViewController *vc = [[class alloc] init];
    return vc;
}

- (UIViewController *)getViewController:(NSString *)vcName params:(NSDictionary *)params {
    UIViewController *vc = [self getViewController:vcName];
    if(vc != nil){
        vc = [self controller:vc withParam:params andVCname:vcName];
    }else{
        NSLog(@"未找到此类:%@", vcName);
        //EXCEPTION  Push a Normal Error VC
        vc = [[RouterError shared] getErrorController];
    }
    return vc;
}

/**
 此方法用来初始化参数（控制器初始化方法默认为 initViewControllerParam。初始化方法你可以自定义，前提是VC必须实现它。要想灵活一点，也可以加一个参数actionName,当做参数传入。不过这样你就需要修改此方法了)。
 @param controller 获取到的实例VC
 @param params 实例化参数
 @param vcName 控制器名字
 @return 初始化之后的VC
 */
-(UIViewController *)controller:(UIViewController *)controller withParam:(NSDictionary *)params andVCname:(NSString *)vcName {
    
    NSString *selString = @"initWithParams:";
    SEL selector = NSSelectorFromString(selString);
    if(![controller respondsToSelector:selector]){  //如果没定义初始化参数方法，直接返回，没必要在往下做设置参数的方法
        XLsn0wLog(@"目标类:%@未定义:%@方法",controller, selString);
        return controller;
    }
    //在初始化参数里面添加一个key信息，方便控制器中查验路由信息
    NSString *key = @"key";
    if(!params){
        params = [NSMutableDictionary dictionary];
        [params setValue:vcName forKey:key];///key
        
        SuppressPerformSelectorLeakWarning([controller performSelector:selector withObject:params]);
    }else{
        
        [params setValue:vcName forKey:key];
    }
    
    SuppressPerformSelectorLeakWarning([controller performSelector:selector withObject:params]);
    return controller;
}

@end
