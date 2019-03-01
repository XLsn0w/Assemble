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

#import "BaseViewController.h"
#import "MainTabBarController.h"
#import<CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface BaseViewController ()<TZImagePickerControllerDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate, SFSafariViewControllerDelegate>

@property (nonatomic, assign, readwrite) float navHeight;
@property (nonatomic, assign, readwrite) float tabBarHeight;
@property (nonatomic, assign, readwrite) float statusBarHeight;

@end

@implementation BaseViewController

/// 入口
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configParams];
    [self customNavBackBtn];
}

//- (void)pushViewController:(Class*)viewControllerClass {
//    [viewControllerClass class] *vc = [[[viewControllerClass class] alloc] init];
//    [self.navigationController pushViewController:vc animated:true];
//}

- (void)GET:(NSString *)url
     params:(NSDictionary *)params
    success:(BaseViewControllerHTTPSuccess)success
    failure:(BaseViewControllerHTTPFailure)failure
     isShow:(BOOL)isShow {
    [HTTPSharedManager GET:url
                    params:params
                   success:^(id responseObject) {
                       if (responseObject) {
                           if (success) {
                               success(responseObject);
                           }
                       }
                   } failure:^(NSError *error) {
                       if (error) {
                           if (failure) {
                               failure(error);
                           }
                       }
                   } isShow:isShow];
}

- (void)POST:(NSString *)url
      params:(NSDictionary *)params
     success:(BaseViewControllerHTTPSuccess)success
     failure:(BaseViewControllerHTTPFailure)failure {
    [HTTPSharedManager POST:url
                Parameters:params
                   Success:^(id responseObject) {
                       if (responseObject) {
                           if (success) {
                               success(responseObject);
                           }
                       }
                   } Failure:^(NSError *error) {
                       if (error) {
                           if (failure) {
                               failure(error);
                           }
                       }
                   }];
}

- (void)configParams {
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = ViewBgColor;
    self.prevent = YES;
    self.cameraController = [[UIImagePickerController alloc] init];
    self.cameraController.delegate = self;
    self.cameraController.allowsEditing = false;
    _selectedPhotos = [NSMutableArray array];
    self.page = 1;
    self.recordPage = self.page;
}

- (void)fixViewOffset {
    self.navigationController.navigationBar.translucent = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)blackNavBackBtn {
    UIButton *navButton = [UIButton buttonWithType:UIButtonTypeCustom];
    navButton.frame = CGRectMake(0, 0, 40, 40);
    navButton.contentEdgeInsets =UIEdgeInsetsMake(0, -30,0, 0);
    [navButton setImage:[UIImage imageNamed:@"blackNav"] forState:UIControlStateNormal];
    [navButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:navButton];
}

- (void)restoreNavBar {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage xlsn0w_imageWithColor:AppThemeColor]
                                                 forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName :UIColor.whiteColor}];
}

- (void)resetWhiteNavBar {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage xlsn0w_imageWithColor:UIColor.whiteColor]
                                                 forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName :AppBlackTextColor,
                                                                      NSFontAttributeName:[UIFont systemFontOfSize:18]}];
}

- (void)customNavBackBtn {
    //XLsn0wLog(@"self.navigationController.viewControllers.count = %ld", self.navigationController.viewControllers.count);
    if (self.navigationController.viewControllers.count != 1) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav"]
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self
                                                                                action:@selector(backAction)];
    }
}

- (void)clipRoundCornersFromView:(UIView*)view {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(6, 6)];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    
    maskLayer.frame = view.bounds;
    
    maskLayer.path = maskPath.CGPath;
    
    view.layer.mask = maskLayer;
}

- (void)sendDeviceInfoAppVersion {
    [HTTPSharedManager POST:HTTPAPI(modelVersionURL)
                Parameters:@{@"versionNumber":[iOSDeviceInfo getLocalAppVersion],
                             @"deviceName":[iOSDeviceInfo deviceTypeDetail]}
                   Success:^(id responseObject) {
                       XLsn0wLog(@"保存设备和版本号接口成功---%@", responseObject);
                   } Failure:^(NSError *error) {
                    
                   }];
}

- (void)checkVersion {
    [HTTPSharedManager GET:HTTPAPI(checkVersionURL)
                    params:@{@"userAppType":@(1)}
                   success:^(id responseObject) {
                       if (isNotNull(responseObject[@"data"])) {
                           if (isNotNull(responseObject[@"data"][@"isShowWindow"])) {
                               BOOL isShowWindow = [responseObject[@"data"][@"isShowWindow"] boolValue];
                               NSString* url = responseObject[@"data"][@"url"];
                               if (isShowWindow == true) {///显示
                                   
                                   if (isNotNull(responseObject[@"data"][@"version"])) {
                                       NSString* version = responseObject[@"data"][@"version"];
                                       
                                       if (isNotNull(responseObject[@"data"][@"title"])) {
                                           NSString* title = responseObject[@"data"][@"title"];
                                           
                                           if (isNotNull(responseObject[@"data"][@"description"])) {
                                               NSString* description = responseObject[@"data"][@"description"];
                                               [[XLsn0wCheckVersion shared] checkServerVersion:version updateMsg:description title:title isForce:YES url:url];
                                           }
                                       }
                                   }
                               }
                           }
                       }
                   } failure:^(NSError *error) {
                       
                   } isShow:YES];
}

- (void)call {
    UIWebView *callWebview = [[UIWebView alloc] init];
    [self.view addSubview:callWebview];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[[NSMutableString alloc] initWithFormat:@"tel:%@", @"4006379558"]]]];
}

- (BOOL)isUserLogined {
    BOOL isUserLogined = [UserDefaulter selectValueFromKey:@"isUserLogined"];
    return isUserLogined;
}

- (void)presentCodeLoginViewController {
    CodeLoginViewController *loginVC = [CodeLoginViewController new];
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (void)userLogout {
    [UserDefaulter deleteValueForKey:@"isUserLogined"];
    self.navigationController.tabBarController.selectedIndex = 0;
//    [self.navigationController.tabBarController setSelectedIndex:0];
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIViewController*)getVisibleViewControllerFromNavigationController:(BaseNavigationController*)nav {
    return nav.visibleViewController;
}

- (BaseNavigationController*)getNavigationControllerInTabBar {
    ///取到根控制器
    UIViewController* rootViewController = kAppWindow.rootViewController;
    
    ///取到TabBarController
    MainTabBarController *tabBarController = (MainTabBarController*)rootViewController;
    
    ///取到NavigationController
    BaseNavigationController * nav = (BaseNavigationController *)tabBarController.selectedViewController;
    
    return nav;
}

- (BaseNavigationController*)getNavigationControllerInLogin {
    ///取到根控制器
    UIViewController* rootViewController = kAppWindow.rootViewController;
    ///取到NavigationController
    BaseNavigationController * nav = (BaseNavigationController *)rootViewController;
    
    return nav;
}

- (void)pushAnyViewController:(NSString*)AnyVCName {
    ///取到根控制器
    UIViewController* rootViewController = kAppWindow.rootViewController;
    
    ///取到TabBarController
    MainTabBarController *tabBarController = (MainTabBarController*)rootViewController;
    
    ///取到NavigationController
    BaseNavigationController * nav = (BaseNavigationController *)tabBarController.selectedViewController;
    
    //取到nav控制器当前显示的控制器
    UIViewController * visibleVC = (UIViewController *)nav.visibleViewController;
    
    Class vcClass = NSClassFromString(AnyVCName);
    
    //如果是当前控制器是我的消息控制器的话，刷新数据即可
//    if([visibleVC isKindOfClass:[vcClass class]]) {
//        vcClass *vc = (vcClass *)visibleVC;
////        [vc reloadMessageData];
//        return;
//    }
//    // 否则，跳转到我的消息
//    [vcClass class] * messageVC = [[vcClass alloc] init];
//    [nav pushViewController:messageVC animated:YES];
}


- (float)navHeight {
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    CGRect rectNav = self.navigationController.navigationBar.frame;
    _navHeight = rectStatus.size.height + rectNav.size.height;
    return _navHeight;
}

- (float)tabBarHeight {
    UITabBarController *tabBarVC = [[UITabBarController alloc] init];
    if (self.navHeight>64) {
        _tabBarHeight = tabBarVC.tabBar.frame.size.height +34;
    }else {
        _tabBarHeight = tabBarVC.tabBar.frame.size.height;
    }
    return _tabBarHeight;
}

- (float)statusBarHeight {
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    _statusBarHeight = rectStatus.size.height;
    return _statusBarHeight;
}

/// 获取Nav
- (UINavigationController *)getNavigationController {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    if ([window.rootViewController isKindOfClass:[UINavigationController class]]) {
        
        return (UINavigationController *)window.rootViewController;
        
    } else if ([window.rootViewController isKindOfClass:[UITabBarController class]]) {
        
        UIViewController *selectedVC = [((UITabBarController *)window.rootViewController)selectedViewController];
        
        if ([selectedVC isKindOfClass:[UINavigationController class]]) {
            
            return (UINavigationController *)selectedVC;
        }
    }
    return nil;
}

- (void)pushPrivacyPolicyWithURLString:(NSString *)url vc:(BaseViewController *)vc {
    /// 跳转 隐私政策
    SFSafariViewController *safariController = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:url]];
    safariController.delegate = vc;///<SFSafariViewControllerDelegate>
    [vc presentViewController:safariController animated:YES completion:nil];
}

- (void)safariViewControllerDidFinish:(nonnull SFSafariViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)setNavgationView {
    
}


-(void)addNavigationItemWithTitle:(NSString *)title withImage:(NSString *)imgName buttonImageTitleType:(ButtonImgViewStyle)type buttontitleColor:(UIColor *)color{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:[[UIImage imageNamed:imgName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    btn.titleLabel.font = SYSTEMFONT(15);
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onNavRightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setImgViewStyle:type imageSize:CGSizeMake(20, 20) space:5.f];
    [btn sizeToFit];
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
}

-(void)onNavRightButtonClick:(UIButton *)sender {
    HLLog(@"onRightButtonClick");
}

-(BOOL)judgeNavigationLeftButtonBackOrButton {
    BOOL vcBool = false;
    NSMutableArray *vcArray = [NSMutableArray new];
    MainTabBarController *vc = (MainTabBarController *)[self getCurrentVC];
    for (int i = 0; i < vc.childViewControllers.count; i++) {
        UITabBarController *tvc = vc.childViewControllers[i];
        for (int j=0; j<tvc.childViewControllers.count; j++) {
            UIViewController *vv = tvc.childViewControllers[j];
            [vcArray addObject:vv];
        }
    }
    if (vcArray.count >4) {
        vcBool = NO;
    }else {
        vcBool = YES;
    }
    return vcBool;
}

- (UIViewController *)getCurrentVC {
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]){
        result = nextResponder;
    }else{
        result = window.rootViewController;
    }
    return result;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (_dataArray.count !=0) {
//        _noDataImageView.hidden = YES;
//        _noDataLabel.hidden = YES;
//        return _dataArray.count;
//    }else{
//        _noDataImageView.hidden = NO;
//        _noDataLabel.hidden = NO;
        return 0;
//    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return nil;
}

#pragma mark - 提示
-(void)promptMessage:(NSString *)contentStr {
    AlertHUD *progress = [AlertHUD showHUDAddedTo:self.view animated:YES];
    progress.mode = RQMBProgressHUDModeCustomView;
    progress.detailsLabelFont = [UIFont systemFontOfSize:15];
    progress.removeFromSuperViewOnHide = YES;
    progress.detailsLabelText = contentStr;
    [progress hide:YES afterDelay:1.5];
}

#pragma mark - 验证手机号
-(BOOL)verifyCellPhoneNumber:(NSString *)phoneNum {
    NSString *regex = @"^((13[0-9])|(17[0-9])|(147)|(15[0-9])|(18[0-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:phoneNum];
    return isMatch;
}

-(void)doNavigationWithEndLocation:(NSArray *)endLocation {
    NSMutableArray *maps = [NSMutableArray array];
    //苹果原生地图-苹果原生地图方法和其他不一样
    NSMutableDictionary *iosMapDic = [NSMutableDictionary dictionary];
    iosMapDic[@"title"] = @"苹果地图";
    [maps addObject:iosMapDic];
    //百度地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        NSMutableDictionary *baiduMapDic = [NSMutableDictionary dictionary];
        baiduMapDic[@"title"] = @"百度地图";
        NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%@,%@|name=北京&mode=driving&coord_type=gcj02",endLocation[0],endLocation[1]] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        baiduMapDic[@"url"] = urlString;
        [maps addObject:baiduMapDic];
    }
    //高德地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        NSMutableDictionary *gaodeMapDic = [NSMutableDictionary dictionary];
        gaodeMapDic[@"title"] = @"高德地图";
        NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%@&lon=%@&dev=0&style=2",@"导航功能",@"nav123456",endLocation[0],endLocation[1]] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        gaodeMapDic[@"url"] = urlString;
        [maps addObject:gaodeMapDic];
    }
    //谷歌地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
        NSMutableDictionary *googleMapDic = [NSMutableDictionary dictionary];
        googleMapDic[@"title"] = @"谷歌地图";
        NSString *urlString = [[NSString stringWithFormat:@"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%@,%@&directionsmode=driving",@"导航测试",@"nav123456",endLocation[0], endLocation[1]] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        googleMapDic[@"url"] = urlString;
        [maps addObject:googleMapDic];
    }
    //腾讯地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://"]]) {
        NSMutableDictionary *qqMapDic = [NSMutableDictionary dictionary];
        qqMapDic[@"title"] = @"腾讯地图";
        NSString *urlString = [[NSString stringWithFormat:@"qqmap://map/routeplan?from=我的位置&type=drive&tocoord=%@,%@&to=终点&coord_type=1&policy=0",endLocation[0], endLocation[1]] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        qqMapDic[@"url"] = urlString;
        [maps addObject:qqMapDic];
    }
    //选择
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"选择地图" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    NSInteger index = maps.count;
    for (int i = 0; i < index; i++) {
        NSString * title = maps[i][@"title"];
        if (i == 0) {
            UIAlertAction * action = [UIAlertAction actionWithTitle:title style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                [self navAppleMapnavAppleMapWithArray:endLocation];
            }];
            [alert addAction:action];
            continue;
        }
        UIAlertAction * action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *urlString = maps[i][@"url"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        }];
        [alert addAction:action];
    }
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}
//苹果地图
- (void)navAppleMapnavAppleMapWithArray:(NSArray*) array {
    float lat = [NSString stringWithFormat:@"%@", array[0]].floatValue;
    float lon = [NSString stringWithFormat:@"%@", array[1]].floatValue;
    CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(lat, lon);
    MKMapItem *currentLoc = [MKMapItem mapItemForCurrentLocation];
    MKMapItem *toLocation = [[MKMapItem alloc]initWithPlacemark:[[MKPlacemark alloc]initWithCoordinate:loc addressDictionary:nil] ];
    NSArray *items = @[currentLoc,toLocation];
    NSDictionary *dic = @{
                          MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving,
                          MKLaunchOptionsMapTypeKey : @(MKMapTypeStandard),
                          MKLaunchOptionsShowsTrafficKey : @(YES)
                          };
    [MKMapItem openMapsWithItems:items launchOptions:dic];
}

#pragma mark - 调用相册
-(void)hoolinkvisitPhotoGallery {
    __weak __typeof(self)weakSelf = self;
    [[self class] requestPhotosLibraryAuthorization:^(BOOL ownAuthorization) {
        if (ownAuthorization) {
            NSInteger count = 8-weakSelf.selectedPhotos.count;
            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:count delegate:self];
            imagePickerVc.showPhotoCannotSelectLayer = YES;
            imagePickerVc.showSelectedIndex = YES;
            imagePickerVc.naviTitleColor = FontColor;
            imagePickerVc.barItemTextColor = FontColor;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf presentViewController:imagePickerVc animated:YES completion:nil];
            });
        }else {
            [weakSelf pushAlertWithTitle:@"" message:@"请在iPhone”设置-隐私-照片“选项中，允许Hoolink_IoT访问你的手机相册" buttons:@[@"确定"] animated:YES action:^(NSInteger index) {
            }];
        }
    }];
}
/**
 获取相册权限
 @param handler 获取权限结果
 */
+ (void)requestPhotosLibraryAuthorization:(void(^)(BOOL ownAuthorization))handler {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (handler) {
            BOOL boolean = false;
            if (status == PHAuthorizationStatusAuthorized) {
                boolean = true;
            }
            handler(boolean);
        }
    }];
}

- (void)requestCameraAuthorization:(void(^)(BOOL isAllow))handler {

   __block BOOL isAllow = true;
    // 1、 获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        // 判断授权状态
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusRestricted) {
            HLLog(@"因为系统原因, 无法访问相机");
            isAllow = false;
            return;
        } else if (authStatus == AVAuthorizationStatusDenied) { // 用户拒绝当前应用访问相机
            isAllow = false;
            return;
        } else if (authStatus == AVAuthorizationStatusAuthorized) { // 用户允许当前应用访问相机

            isAllow = true;
            
        } else if (authStatus == AVAuthorizationStatusNotDetermined) { // 用户还没有做出选择
            // 弹框请求用户授权
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (!granted) {
                    // 用户不接受
                    isAllow = false;
                }
            }];
        }
         handler(isAllow);
    } else {
        [self pushAlertWithTitle:@"" message:@"未检测到您的摄像头, 请在真机上测试" buttons:@[@"确定"] animated:YES action:^(NSInteger index) {
        }];
    }
    
}

#pragma mark - TZImagePickerControllerDelegate

-(void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    [self.selectedPhotos addObjectsFromArray:photos];
    [self hoolinkdidFinishPickingPhotos:photos];
}

-(void)hoolinkdidFinishPickingPhotos:(NSArray<UIImage *> *)photos {

}

-(NSString *)convertToJsonData:(NSDictionary *)dict {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        HLLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
    
}

#pragma mark - UIImagePickerController

- (void)pushToCameraFrom:(UIViewController *)viewController {
    [self requestCameraAuthorization:^(BOOL isAllow) {
        if (isAllow == true) {
            HLLog(@"isAllow == true");
            if (@available(iOS 11.0, *)) {
                [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentAutomatic];
            }
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                self.cameraController.sourceType = UIImagePickerControllerSourceTypeCamera;
                [viewController presentViewController:self.cameraController animated:YES completion:NULL];
            }
        } else {
            [self pushAlertWithTitle:@"" message:@"请在iPhone”设置-隐私-照片“选项中，允许Hoolink_IoT访问你的手机相册" buttons:@[@"确定"] animated:YES action:^(NSInteger index) {
            }];
        }
    }];
}

// 拍照图片成功调用此方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    if (@available(iOS 11.0, *)) {
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    UIImage *photograph = info[@"UIImagePickerControllerOriginalImage"];
    NSMutableArray *cameraImages = [NSMutableArray array];
    [cameraImages addObject:photograph];
    [self.selectedPhotos addObjectsFromArray:cameraImages];
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {///当image从相机中获取的时候存入相册中
        UIImageWriteToSavedPhotosAlbum(photograph, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }
    if (_assetsDelegate && [_assetsDelegate respondsToSelector:@selector(getCameraImages:dismissViewController:)]) {
        return [_assetsDelegate getCameraImages:cameraImages dismissViewController:self];
    }
}

- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo {
    if (error) {
        HLLog(@"存入相册失败");
    }else{
        HLLog(@"存入相册成功");
    }
}

// 取消图片选择调用此方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 以控制添加多个控制器
-(void)replaceController:(UIViewController *)oldController newController:(UIViewController *)newController {
    [self addChildViewController:newController];
    [self transitionFromViewController:oldController toViewController:newController duration:0.0f options:UIViewAnimationOptionTransitionNone animations:nil completion:^(BOOL finished) {
        [newController didMoveToParentViewController:self];
        [oldController willMoveToParentViewController:nil];
        [oldController removeFromParentViewController];
        self.currentVC = newController;
    }];
    
}


- (void)initWithParams:(NSDictionary *)params {
    ///子类获取传递参数
}

@end
