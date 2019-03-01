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

@protocol HTTPViewProtocol <NSObject>

- (void)HTTPSuccess:(NSDictionary*)JSONDictionary
                url:(NSString *)url
             params:(NSDictionary *)params;

- (void)HTTPFailureShowNullDataView;

@end

