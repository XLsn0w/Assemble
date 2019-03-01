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

#import <UIKit/UIKit.h>
#import "HLUserInfos.h"
#import "WrapNetwordHelper.h"
#import "UIView+Others.h"

#import "AlertHUD.h"
#import "MJRefresh.h"
#import "TZImagePickerController.h"

typedef void(^BaseViewControllerHTTPSuccess)(id responseObject);
typedef void(^BaseViewControllerHTTPFailure)(NSError* error);

@protocol GetAssetsDelegate <NSObject>

- (void)getCameraImages:(NSMutableArray *)cameraImages dismissViewController:(UIViewController *)viewController;

@end

@interface BaseViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    AlertHUD *_progress;
    WrapNetwordHelper *_httpRequest;
    NSString *_istable;
}

- (void)backAction;

//@property (nonatomic, copy) BaseViewControllerHTTPSuccess requestSuccess;
//@property (nonatomic, copy) BaseViewControllerHTTPFailure requestFailure;

- (void)GET:(NSString *)url
     params:(NSDictionary *)params
    success:(BaseViewControllerHTTPSuccess)success
    failure:(BaseViewControllerHTTPFailure)failure
     isShow:(BOOL)isShow;

- (void)POST:(NSString *)url
      params:(NSDictionary *)params
     success:(BaseViewControllerHTTPSuccess)success
     failure:(BaseViewControllerHTTPFailure)failure;

@property (nonatomic, strong) BaseView* containerView;
@property (nonatomic, strong) NSMutableArray* cellDataArray;

@property (nonatomic, strong) HTTPPresenter *presenter;/// http请求

//导航栏的高度
@property (nonatomic, assign, readonly) float navHeight;
@property (nonatomic, assign, readonly) float tabBarHeight;
@property (nonatomic, assign, readonly) float statusBarHeight;
@property (nonatomic, strong)UIButton *navRightBtn;//导航右侧按钮

@property (nonatomic, assign) int page;//页码
@property (nonatomic, assign) int recordPage;
@property (nonatomic, assign) BOOL isNoMoreData;
@property (nonatomic, assign) BOOL prevent;//防止多次点击网络请求

@property (nonatomic, strong) HLUserInfos *userInfos;//单利储存用户先关信息


@property (nonatomic, strong) NSMutableArray *selectedPhotos;//储存相册Photos
//@property (nonatomic, strong) NSMutableArray *selectedAssets;//储存相册Assets

@property (nonatomic, strong) UIScrollView *refreshView;
@property (strong, nonatomic) UIImagePickerController *cameraController;

@property (nonatomic, weak) id<GetAssetsDelegate> assetsDelegate;

@property (nonatomic, strong) NSDictionary *params;///传参
@property (nonatomic, strong) NSDictionary *responseData;
@property (nonatomic ,strong) UIViewController *currentVC;//一个视图控制器上有多个视图控制器用到

- (void)customNavBackBtn;
- (UINavigationController *)getNavigationController;///获取当前活动的navigationcontroller
- (BaseNavigationController*)getNavigationControllerInTabBar;

- (void)userLogout;
- (void)initWithParams:(NSDictionary *)params;
- (void)resetWhiteNavBar;
- (void)restoreNavBar;
- (void)blackNavBackBtn;
- (void)sendDeviceInfoAppVersion;
- (void)call;
- (void)checkVersion;
- (void)clipRoundCornersFromView:(UIView*)view;
- (BOOL)isUserLogined;
- (void)presentCodeLoginViewController;

/**
 导航栏添加文本按钮
 titles 、 image 文本 图片名称
 ButtonImgViewStyle 图片显示的位置
 color 字体的颜色
 */
-(void)addNavigationItemWithTitle:(NSString *)title withImage:(NSString *)imgName buttonImageTitleType:(ButtonImgViewStyle)type buttontitleColor:(UIColor *)color;

//导航栏左、右按钮点击事件
//-(void)onNavLeftButtonClick:(UIButton *)sender;
-(void)onNavRightButtonClick:(UIButton *)sender;

//信息提示
-(void)promptMessage:(NSString *)contentStr;

//验证手机号
-(BOOL)verifyCellPhoneNumber:(NSString *)phoneNum;

- (UIViewController *)getCurrentVC;

//跳转到第三方的地图导航
-(void)doNavigationWithEndLocation:(NSArray *)endLocation;

//调用相册
-(void)hoolinkvisitPhotoGallery;
-(void)hoolinkdidFinishPickingPhotos:(NSArray<UIImage *> *)photos;

//字典转字符串
-(NSString *)convertToJsonData:(NSDictionary *)dict;

- (void)pushToCameraFrom:(UIViewController *)viewController;

/*
 一个试图控制器上有多个试图控制器的方法
 currenVC         创建一个UIViewController *currenVC
 oldController
 newController
 */
-(void)replaceController:(UIViewController *)oldController newController:(UIViewController *)newController;


- (void)pushPrivacyPolicyWithURLString:(NSString *)url vc:(UIViewController *)vc;

@end
