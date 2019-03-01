//                     _0_
//                   _oo0oo_
//                  o8888888o
//                  88" . "88
//                  (| -_- |)
//                  0\  =  /0
//                ___/`---'\___
//              .' \\|     |// '.
//             / \\|||  :  |||// \
//            / _||||| -:- |||||- \
//           |   | \\\  -  /// |   |
//           | \_|  ''\---/''  |_/ |
//           \  .-\__  '-'  ___/-. /
//         ___'. .'  /--.--\  `. .'___
//      ."" '<  `.___\_<|>_/___.' >' "".
//     | | :  `- \`.;`\ _ /`;.`/ - ` : | |
//     \  \ `_.   \_ __\ /__ _/   .-` /  /
// NO---`-.____`.___ \_____/___.-`___.-'---BUG
//                   `=---='

#import "BasePresenter.h"

@implementation BasePresenter

/**
 初始化 绑定视图 函数
 必须实现
 */
- (instancetype)initWithBindView:(id)view {
    if (self = [super init]) {
        _view = view;
    }
    return self;
}

- (void)POST:(NSString *)url params:(NSDictionary*)params {
    
}

/**
 * 绑定视图
 * @param view 要绑定的视图
 */
- (void)bindView:(id)view {
    _view = view;
}


/**
 解绑视图
 */
- (void)unbindView {
    _view = nil;
}
@end
