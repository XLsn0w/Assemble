//
//  TZImagePickerController.m
//  TZImagePickerController
//
//  Created by 谭真 on 15/12/24.
//  Copyright © 2015年 谭真. All rights reserved.
//  version 2.1.5 - 2018.06.03

#import "TZImagePickerController.h"
#import "TZPhotoPickerController.h"
#import "TZPhotoPreviewController.h"
#import "TZAssetModel.h"
#import "TZAssetCell.h"
#import "TZImageManager.h"
#import <sys/utsname.h>

@interface TZImagePickerController () {
    NSTimer *_timer;
    UILabel *_tipLabel;
    UIButton *_settingBtn;
    BOOL _pushPhotoPickerVc;
    BOOL _didPushPhotoPickerVc;
    
    UIView *_HUDContainer;
    UIActivityIndicatorView *_HUDIndicatorView;
    
    UIStatusBarStyle _originStatusBarStyle;
}
/// Default is 4, Use in photos collectionView in TZPhotoPickerController
/// 默认4列, TZPhotoPickerController中的照片collectionView
@property (nonatomic, assign) NSInteger columnNumber;
@end

@implementation TZImagePickerController

- (instancetype)init {
    self = [super init];
    if (self) {
        self = [self initWithMaxImagesCount:9 delegate:nil];
    }
    return self;
}

//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)viewDidLoad {
    [super viewDidLoad];
    self.needShowStatusBar = ![UIApplication sharedApplication].statusBarHidden;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationBar.translucent = YES;
    [TZImageManager manager].shouldFixOrientation = NO;
    
    // Default appearance, you can reset these after this method
    // 默认的外观，你可以在这个方法后重置
    self.oKButtonTitleColorNormal   = TabBarTitleColor;
    self.oKButtonTitleColorDisabled = [UIColor colorWithRed:(83/255.0) green:(179/255.0) blue:(17/255.0) alpha:0.5];
    
    if (iOS7Later) {
        self.navigationBar.barTintColor = [UIColor blackColor];
        self.navigationBar.barTintColor  = [UIColor blackColor];
        self.automaticallyAdjustsScrollViewInsets = NO;
        if (self.needShowStatusBar) [UIApplication sharedApplication].statusBarHidden = NO;
    }
}

- (void)setNaviBgColor:(UIColor *)naviBgColor {
    _naviBgColor = naviBgColor;
    if (iOS7Later) {
        self.navigationBar.barTintColor = naviBgColor;
    }
}

- (void)setNaviTitleColor:(UIColor *)naviTitleColor {
    _naviTitleColor = naviTitleColor;
    [self configNaviTitleAppearance];
}

- (void)setNaviTitleFont:(UIFont *)naviTitleFont {
    _naviTitleFont = naviTitleFont;
    [self configNaviTitleAppearance];
}

- (void)configNaviTitleAppearance {
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    if (self.naviTitleColor) {
        textAttrs[NSForegroundColorAttributeName] = self.naviTitleColor;
    }
    if (self.naviTitleFont) {
        textAttrs[NSFontAttributeName] = self.naviTitleFont;
    }
    self.navigationBar.titleTextAttributes = textAttrs;
}

- (void)setBarItemTextFont:(UIFont *)barItemTextFont {
    _barItemTextFont = barItemTextFont;
    [self configBarButtonItemAppearance];
}

- (void)setBarItemTextColor:(UIColor *)barItemTextColor {
    _barItemTextColor = barItemTextColor;
    [self configBarButtonItemAppearance];
}

- (void)configBarButtonItemAppearance {
    UIBarButtonItem *barItem;
    if (iOS9Later) {
        barItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
        NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
        textAttrs[NSForegroundColorAttributeName] = self.barItemTextColor;
        textAttrs[NSFontAttributeName] = self.barItemTextFont;
        [barItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _originStatusBarStyle = [UIApplication sharedApplication].statusBarStyle;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = _originStatusBarStyle;
}

- (instancetype)initWithMaxImagesCount:(NSInteger)maxImagesCount delegate:(id<TZImagePickerControllerDelegate>)delegate {
    return [self initWithMaxImagesCount:maxImagesCount columnNumber:4 delegate:delegate pushPhotoPickerVc:YES];
}



- (instancetype)initWithMaxImagesCount:(NSInteger)maxImagesCount columnNumber:(NSInteger)columnNumber delegate:(id<TZImagePickerControllerDelegate>)delegate pushPhotoPickerVc:(BOOL)pushPhotoPickerVc {
    _pushPhotoPickerVc = pushPhotoPickerVc;
    TZAlbumPickerController *albumPickerVc = [[TZAlbumPickerController alloc] init];
    albumPickerVc.isFirstAppear = YES;
    albumPickerVc.columnNumber = columnNumber;
    self = [super initWithRootViewController:albumPickerVc];
    if (self) {
        self.maxImagesCount = maxImagesCount > 0 ? maxImagesCount : 9; // Default is 9 / 默认最大可选9张图片
        self.pickerDelegate = delegate;
        self.selectedAssets = [NSMutableArray array];
        self.sortAscendingByModificationDate = YES;
//        self.autoDismiss = YES;
        self.columnNumber = columnNumber;
        [self configDefaultSetting];
//        _timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(observeAuthrizationStatusChange) userInfo:nil repeats:NO];
        [self pushPhotoPickerVc];
    }
    return self;
}

- (void)configDefaultSetting {
    self.photoWidth = 828.0;
    self.photoPreviewMaxWidth = 600;
    self.naviTitleColor = [UIColor whiteColor];
    self.naviTitleFont = [UIFont systemFontOfSize:17];
    self.barItemTextFont = [UIFont systemFontOfSize:15];
    self.barItemTextColor = [UIColor whiteColor];
//    self.allowPreview = YES;
    self.cannotSelectLayerColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    self.iconThemeColor = TabBarTitleColor;
    [self configDefaultBtnTitle];
}

- (void)configDefaultImageName {
    self.photoNumberIconImage = [self createImageWithColor:nil size:CGSizeMake(48, 48) radius:24];

}


- (void)setIconThemeColor:(UIColor *)iconThemeColor {
    _iconThemeColor = iconThemeColor;
    [self configDefaultImageName];
}

- (void)configDefaultBtnTitle {
    self.doneBtnTitleStr = @"确定";
    self.cancelBtnTitleStr = @"取消";
    self.previewBtnTitleStr = @"预览";
}

- (void)setShowSelectedIndex:(BOOL)showSelectedIndex {
    _showSelectedIndex = showSelectedIndex;
    if (showSelectedIndex) {
        self.photoSelImage = [self createImageWithColor:nil size:CGSizeMake(48, 48) radius:24];
    }
    [TZImagePickerConfig sharedInstance].showSelectedIndex = showSelectedIndex;
}

- (void)setShowPhotoCannotSelectLayer:(BOOL)showPhotoCannotSelectLayer {
    _showPhotoCannotSelectLayer = showPhotoCannotSelectLayer;
    [TZImagePickerConfig sharedInstance].showPhotoCannotSelectLayer = showPhotoCannotSelectLayer;
}

- (void)pushPhotoPickerVc {
    _didPushPhotoPickerVc = NO;
    // 1.6.8 判断是否需要push到照片选择页，如果_pushPhotoPickerVc为NO,则不push
    if (!_didPushPhotoPickerVc && _pushPhotoPickerVc) {
        TZPhotoPickerController *photoPickerVc = [[TZPhotoPickerController alloc] init];
        photoPickerVc.isFirstAppear = YES;
        photoPickerVc.columnNumber = self.columnNumber;
        [[TZImageManager manager] getCameraRollAlbumNeedFetchAssets:NO completion:^(TZAlbumModel *model) {
            photoPickerVc.model = model;
            [self pushViewController:photoPickerVc animated:YES];
            self->_didPushPhotoPickerVc = YES;
        }];
    }
}

///本工程Since iOS 9.0
- (id)showAlertWithTitle:(NSString *)title {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
    return alertController;
}

- (void)hideAlertView:(id)alertView {
    if ([alertView isKindOfClass:[UIAlertController class]]) {
        UIAlertController *alertC = alertView;
        [alertC dismissViewControllerAnimated:YES completion:nil];
    }
    alertView = nil;
}


- (void)setMaxImagesCount:(NSInteger)maxImagesCount {
    _maxImagesCount = maxImagesCount;
}


- (void)setPickerDelegate:(id<TZImagePickerControllerDelegate>)pickerDelegate {
    _pickerDelegate = pickerDelegate;
    [TZImageManager manager].pickerDelegate = pickerDelegate;
}

- (void)setColumnNumber:(NSInteger)columnNumber {
    _columnNumber = columnNumber;
    if (columnNumber <= 2) {
        _columnNumber = 2;
    } else if (columnNumber >= 6) {
        _columnNumber = 6;
    }
    
    TZAlbumPickerController *albumPickerVc = [self.childViewControllers firstObject];
    albumPickerVc.columnNumber = _columnNumber;
    [TZImageManager manager].columnNumber = _columnNumber;
}

- (void)setMinPhotoWidthSelectable:(NSInteger)minPhotoWidthSelectable {
    _minPhotoWidthSelectable = minPhotoWidthSelectable;
    [TZImageManager manager].minPhotoWidthSelectable = minPhotoWidthSelectable;
}

- (void)setMinPhotoHeightSelectable:(NSInteger)minPhotoHeightSelectable {
    _minPhotoHeightSelectable = minPhotoHeightSelectable;
    [TZImageManager manager].minPhotoHeightSelectable = minPhotoHeightSelectable;
}

- (void)setPhotoPreviewMaxWidth:(CGFloat)photoPreviewMaxWidth {
    _photoPreviewMaxWidth = photoPreviewMaxWidth;
    if (photoPreviewMaxWidth > 800) {
        _photoPreviewMaxWidth = 800;
    } else if (photoPreviewMaxWidth < 500) {
        _photoPreviewMaxWidth = 500;
    }
    [TZImageManager manager].photoPreviewMaxWidth = _photoPreviewMaxWidth;
}

- (void)setPhotoWidth:(CGFloat)photoWidth {
    _photoWidth = photoWidth;
    [TZImageManager manager].photoWidth = photoWidth;
}

- (void)setSelectedAssets:(NSMutableArray *)selectedAssets {
    _selectedAssets = selectedAssets;
    _selectedModels = [NSMutableArray array];
    _selectedAssetIds = [NSMutableArray array];
    for (id asset in selectedAssets) {
        TZAssetModel *model = [TZAssetModel modelWithAsset:asset type:[[TZImageManager manager] getAssetType:asset]];
        model.isSelected = YES;
        [self addSelectedModel:model];
    }
}

- (void)setSortAscendingByModificationDate:(BOOL)sortAscendingByModificationDate {
    _sortAscendingByModificationDate = sortAscendingByModificationDate;
    [TZImageManager manager].sortAscendingByModificationDate = sortAscendingByModificationDate;
}

- (void)settingBtnClick {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (iOS7Later) {
        viewController.automaticallyAdjustsScrollViewInsets = NO;
    }
    [super pushViewController:viewController animated:animated];
}

- (void)dealloc {
    // HLLog(@"%@ dealloc",NSStringFromClass(self.class));
}

- (void)addSelectedModel:(TZAssetModel *)model {
    [_selectedModels addObject:model];
    NSString *assetId = [[TZImageManager manager] getAssetIdentifier:model.asset];
    [_selectedAssetIds addObject:assetId];
}

- (void)removeSelectedModel:(TZAssetModel *)model {
    [_selectedModels removeObject:model];
    NSString *assetId = [[TZImageManager manager] getAssetIdentifier:model.asset];
    [_selectedAssetIds removeObject:assetId];
}

- (UIImage *)createImageWithColor:(UIColor *)color size:(CGSize)size radius:(CGFloat)radius {
    if (!color) {
        color = self.iconThemeColor;
    }
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius];
    CGContextAddPath(context, path.CGPath);
    CGContextFillPath(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


#pragma mark - Layout

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    _HUDContainer.frame = CGRectMake((self.view.width - 120) / 2, (self.view.height - 90) / 2, 120, 90);
    _HUDIndicatorView.frame = CGRectMake(45, 15, 30, 30);
   
}

#pragma mark - Public

- (void)cancelButtonClick {
    [self dismissViewControllerAnimated:YES completion:^{
        [self callDelegateMethod];
    }];
}

- (void)callDelegateMethod {
    if ([self.pickerDelegate respondsToSelector:@selector(tz_imagePickerControllerDidCancel:)]) {
        [self.pickerDelegate tz_imagePickerControllerDidCancel:self];
    }
    if (self.imagePickerControllerDidCancelHandle) {
        self.imagePickerControllerDidCancelHandle();
    }
}

@end


@interface TZAlbumPickerController ()<UITableViewDataSource,UITableViewDelegate> {
    UITableView *_tableView;
}
@property (nonatomic, strong) NSMutableArray *albumArr;
@end

@implementation TZAlbumPickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isFirstAppear = YES;
    self.title = @"相册";
    self.view.backgroundColor = [UIColor whiteColor];
    
    TZImagePickerController *imagePickerVc = (TZImagePickerController *)self.navigationController;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:imagePickerVc.cancelBtnTitleStr style:UIBarButtonItemStylePlain target:imagePickerVc action:@selector(cancelButtonClick)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = @"相册";
    [self configTableView];
}

- (void)configTableView {
    if (![[TZImageManager manager] authorizationStatusAuthorized]) {
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        TZImagePickerController *imagePickerVc = (TZImagePickerController *)self.navigationController;
        [[TZImageManager manager] getAllAlbumsNeedFetchAssets:!self.isFirstAppear completion:^(NSArray<TZAlbumModel *> *models) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self->_albumArr = [NSMutableArray arrayWithArray:models];
                for (TZAlbumModel *albumModel in self->_albumArr) {
                    albumModel.selectedModels = imagePickerVc.selectedModels;
                }
                if (self.isFirstAppear) {
                    self.isFirstAppear = NO;
                    [self configTableView];
                }
                
                if (!self->_tableView) {
                    self->_tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
                    self->_tableView.rowHeight = 70;
                    self->_tableView.tableFooterView = [[UIView alloc] init];
                    self->_tableView.dataSource = self;
                    self->_tableView.delegate = self;
                    [self->_tableView registerClass:[TZAlbumCell class] forCellReuseIdentifier:@"TZAlbumCell"];
                    [self.view addSubview:self->_tableView];
                } else {
                    [self->_tableView reloadData];
                }
            });
        }];
    });
}

- (void)dealloc {
     HLLog(@"%@ dealloc",NSStringFromClass(self.class));
}

#pragma mark - Layout

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat top = 0;
    CGFloat tableViewHeight = 0;
    CGFloat naviBarHeight = self.navigationController.navigationBar.height;
    BOOL isStatusBarHidden = [UIApplication sharedApplication].isStatusBarHidden;
    if (self.navigationController.navigationBar.isTranslucent) {
        top = naviBarHeight;
        if (iOS7Later && !isStatusBarHidden) top += [TZCommonTools tz_statusBarHeight];
        tableViewHeight = self.view.height - top;
    } else {
        tableViewHeight = self.view.height;
    }
    _tableView.frame = CGRectMake(0, top, self.view.width, tableViewHeight);
}

#pragma mark - UITableViewDataSource && Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _albumArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TZAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TZAlbumCell"];
    TZImagePickerController *imagePickerVc = (TZImagePickerController *)self.navigationController;

    cell.selectedCountButton.backgroundColor = imagePickerVc.iconThemeColor;
    cell.model = _albumArr[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TZPhotoPickerController *photoPickerVc = [[TZPhotoPickerController alloc] init];
    photoPickerVc.columnNumber = self.columnNumber;
    TZAlbumModel *model = _albumArr[indexPath.row];
    photoPickerVc.model = model;
    [self.navigationController pushViewController:photoPickerVc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma clang diagnostic pop

@end



@implementation NSString (TzExtension)

- (BOOL)tz_containsString:(NSString *)string {
    if (iOS8Later) {
        return [self containsString:string];
    } else {
        NSRange range = [self rangeOfString:string];
        return range.location != NSNotFound;
    }
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (CGSize)tz_calculateSizeWithAttributes:(NSDictionary *)attributes maxSize:(CGSize)maxSize {
    CGSize size;
    if (iOS7Later) {
        size = [self boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
    } else {
        size = [self sizeWithFont:attributes[NSFontAttributeName] constrainedToSize:maxSize];
    }
    return size;
}
#pragma clang diagnostic pop

@end


@implementation TZCommonTools

+ (BOOL)tz_isIPhoneX {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    if ([platform isEqualToString:@"i386"] || [platform isEqualToString:@"x86_64"]) {
        // 模拟器下采用屏幕的高度来判断
        return (CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(375, 812)) ||
                CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(812, 375)));
    }
    // iPhone10,6是美版iPhoneX 感谢hegelsu指出：https://github.com/banchichen/TZImagePickerController/issues/635
    BOOL isIPhoneX = [platform isEqualToString:@"iPhone10,3"] || [platform isEqualToString:@"iPhone10,6"];
    return isIPhoneX;
}

+ (CGFloat)tz_statusBarHeight {
    return [self tz_isIPhoneX] ? 44 : 20;
}

// 获得Info.plist数据字典
+ (NSDictionary *)tz_getInfoDictionary {
    NSDictionary *infoDict = [NSBundle mainBundle].localizedInfoDictionary;
    if (!infoDict || !infoDict.count) {
        infoDict = [NSBundle mainBundle].infoDictionary;
    }
    if (!infoDict || !infoDict.count) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
        infoDict = [NSDictionary dictionaryWithContentsOfFile:path];
    }
    return infoDict ? infoDict : @{};
}
@end


@implementation TZImagePickerConfig

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static TZImagePickerConfig *config = nil;
    dispatch_once(&onceToken, ^{
        if (config == nil) {
            config = [[TZImagePickerConfig alloc] init];
            config.preferredLanguage = nil;
//            config.gifPreviewMaxImagesCount = 200;
        }
    });
    return config;
}

@end
