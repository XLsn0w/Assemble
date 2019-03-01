//
//  WsqflyNetSession.h
//  TimeForest
//
//  Created by TimeForest on 2018/11/12.
//  Copyright © 2018 TimeForest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define NativeNetwork [NativeNetworking shared]

typedef void(^HeaderFieldAction)(id response);
typedef void(^SuccessAction)(id responseObject);
typedef void(^FailureAction)(NSError * error);

typedef NS_ENUM(NSUInteger, NativeNetworkingLoadingViewStyle) {
    NativeNetworkingLoadingViewStyleNone     = 0, // 没有菊花
    NativeNetworkingLoadingViewStyleCanTouch = 1, // 有菊花并点击屏幕有效
    NativeNetworkingLoadingViewStyleNotTouch = 2  // 有菊花单点击屏幕没有效果
};

typedef NS_ENUM(NSUInteger, NativeNetworkingResponseObjectType) {
    NativeNetworkingResponseObjectTypeService = 0, // 返回后台是什么就是什么DATA
    NativeNetworkingResponseObjectTypeJSON = 1    // 返会序列化后的JSON数据
};

@interface NativeNetworking : NSObject


+ (instancetype)shared;


- (void)GET:(NSString *)urlString
     params:(NSDictionary *)params
    success:(SuccessAction)success
    failure:(FailureAction)failure;


- (void)POST:(NSString *)urlString
      params:(NSDictionary *)params
     success:(SuccessAction)success
     failure:(FailureAction)failure;




/*XLsn0w*
 // 1.NSThread
 [self performSelectorOnMainThread:@selector(updateUI) withObject:nil waitUntilDone:NO];
 
 - (void)updateUI {
 // UI更新代码
 self.alert.text = @"Thanks!";
 }
 
 // 2.NSOperationQueue
 [[NSOperationQueue mainQueue] addOperationWithBlock:^{
 // UI更新代码
 self.alert.text = @"Thanks!";
 }];
 
 // 3.GCD
 dispatch_async(dispatch_get_main_queue(), ^{
 // UI更新代码
 self.alert.text = @"Thanks!";
 });

 */


/**GET短数据请求
 
  * urlString          网址
 
  * param              参数
 
  * state              显示菊花的类型
 
  * backData           返回的数据是NSDATA还是JSON
 
  * successBlock       成功数据的block
 
  * faileBlock         失败的block
 
  * requestHeadBlock   请求头的数据的block
 
  */

- (void)GET:(NSString *)urlString
      params:(NSDictionary *)params
loadingViewStyle:(NativeNetworkingLoadingViewStyle)style
responseType:(NativeNetworkingResponseObjectType)type
    success:(SuccessAction)successBlock
requestHead:(HeaderFieldAction)requestHeadBlock
      faile:(FailureAction)faileBlock;





/**POST短数据请求
 
  * urlString           网址
 
  * param               参数
 
  * state               显示菊花的类型
 
  * backData            返回的数据是NSDATA还是JSON
 
  * successBlock        成功数据的block
 
  * faileBlock          失败的block
 
  * requestHeadBlock    请求头的数据的block
 
  */



-(void)POST:(NSString *)urlString
     params:(NSDictionary *)params
loadingViewStyle:(NativeNetworkingLoadingViewStyle)style
responseType:(NativeNetworkingResponseObjectType)type
    success:(SuccessAction)successBlock
requestHead:(HeaderFieldAction)requestHeadBlock
      failure:(FailureAction)faileBlock;




@end
