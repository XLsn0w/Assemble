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

#import <Foundation/Foundation.h>
/// 处理HTTP网络请求  分担控制器工作

@interface BasePresenter<T>: NSObject { ///泛型
    __weak T _view; ///MVP中负责更新的视图
}

/**
 初始化函数

 @param view 要绑定的视图
 */
- (instancetype)initWithBindView:(T)view;

- (void)POST:(NSString *)url params:(NSDictionary*)params;

/**
 * 绑定视图
 * @param view 要绑定的视图
 */
- (void)bindView:(T)view;

/**
 解绑视图
 */
- (void)unbindView;

@end
