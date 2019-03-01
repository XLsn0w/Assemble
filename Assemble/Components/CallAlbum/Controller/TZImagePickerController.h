//
//  TZImagePickerController.h
//  TZImagePickerController
//
//  Created by 谭真 on 15/12/24.
//  Copyright © 2015年 谭真. All rights reserved.
//  version 2.1.5 - 2018.06.03


#import <UIKit/UIKit.h>
#import "TZAssetModel.h"
#import "TZImageManager.h"

@class TZAlbumCell, TZAssetCell;

@protocol TZImagePickerControllerDelegate;

@interface TZImagePickerController : UINavigationController

#pragma mark -
/// Use this init method / 用这个初始化方法
- (instancetype)initWithMaxImagesCount:(NSInteger)maxImagesCount delegate:(id<TZImagePickerControllerDelegate>)delegate;

#pragma mark -
/// Default is 9 / 默认最大可选9张图片
@property (nonatomic, assign) NSInteger maxImagesCount;

/// 最小照片必选张数,默认是0
@property (nonatomic, assign) NSInteger minImagesCount;

/// 让完成按钮一直可以点击，无须最少选择一张图片
@property (nonatomic, assign) BOOL alwaysEnableDoneBtn;

/// 对照片排序，按修改时间升序，默认是YES。如果设置为NO,最新的照片会显示在最前面，内部的拍照按钮会排在第一个
@property (nonatomic, assign) BOOL sortAscendingByModificationDate;

// 导出图片的宽度，默认828像素宽
@property (nonatomic, assign) CGFloat photoWidth;

/// Default is 600px / 默认600像素宽
@property (nonatomic, assign) CGFloat photoPreviewMaxWidth;

/// 默认为NO，如果设置为YES，会显示照片的选中序号
@property (assign, nonatomic) BOOL showSelectedIndex;


// 默认是NO，如果设置为YES，当照片选择张数达到maxImagesCount时，其它照片会显示颜色为cannotSelectLayerColor的浮层
@property (assign, nonatomic) BOOL showPhotoCannotSelectLayer;


@property (strong, nonatomic) UIColor *cannotSelectLayerColor;


// 用户选中过的图片数组
@property (nonatomic, strong) NSMutableArray *selectedAssets;
@property (nonatomic, strong) NSMutableArray<TZAssetModel *> *selectedModels;
@property (nonatomic, strong) NSMutableArray *selectedAssetIds;
- (void)addSelectedModel:(TZAssetModel *)model;
- (void)removeSelectedModel:(TZAssetModel *)model;


// 最小可选中的图片宽度，默认是0，小于这个宽度的图片不可选中
@property (nonatomic, assign) NSInteger minPhotoWidthSelectable;
@property (nonatomic, assign) NSInteger minPhotoHeightSelectable;




#pragma mark -
- (id)showAlertWithTitle:(NSString *)title;
- (void)hideAlertView:(id)alertView;

@property (nonatomic, assign) BOOL isSelectOriginalPhoto;
@property (assign, nonatomic) BOOL needShowStatusBar;

#pragma mark -

@property (nonatomic, strong) UIImage *photoSelImage;
@property (nonatomic, strong) UIImage *photoNumberIconImage;

#pragma mark -
/// Appearance / 外观颜色 + 按钮文字
@property (nonatomic, strong) UIColor *oKButtonTitleColorNormal;
@property (nonatomic, strong) UIColor *oKButtonTitleColorDisabled;
@property (nonatomic, strong) UIColor *naviBgColor;
@property (nonatomic, strong) UIColor *naviTitleColor;
@property (nonatomic, strong) UIFont *naviTitleFont;
@property (nonatomic, strong) UIColor *barItemTextColor;
@property (nonatomic, strong) UIFont *barItemTextFont;

@property (nonatomic, copy) NSString *doneBtnTitleStr;
@property (nonatomic, copy) NSString *cancelBtnTitleStr;
@property (nonatomic, copy) NSString *previewBtnTitleStr;



/// icon主题色，默认是微信的绿色，值是r:31 g:185 b:34。目前仅支持showSelectedIndex为YES时的图片选中icon
@property (strong, nonatomic) UIColor *iconThemeColor;

#pragma mark -
- (void)cancelButtonClick;

// 如果isSelectOriginalPhoto为YES，表明用户选择了原图
// 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
@property (nonatomic, copy) void (^didFinishPickingPhotosHandle)(NSArray<UIImage *> *photos,NSArray *assets,BOOL isSelectOriginalPhoto);
@property (nonatomic, copy) void (^didFinishPickingPhotosWithInfosHandle)(NSArray<UIImage *> *photos,NSArray *assets,BOOL isSelectOriginalPhoto,NSArray<NSDictionary *> *infos);
@property (nonatomic, copy) void (^imagePickerControllerDidCancelHandle)(void);

@property (nonatomic, weak) id<TZImagePickerControllerDelegate> pickerDelegate;

@end

@protocol TZImagePickerControllerDelegate <NSObject>
@optional

// 如果isSelectOriginalPhoto为YES，表明用户选择了原图
// 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto;
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos;

- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker;

// 决定相册显示与否 albumName:相册名字 result:相册原始数据
- (BOOL)isAlbumCanSelect:(NSString *)albumName result:(id)result;

// 决定照片显示与否
- (BOOL)isAssetCanSelect:(id)asset;
@end


@interface TZAlbumPickerController : UIViewController
@property (nonatomic, assign) NSInteger columnNumber;
@property (assign, nonatomic) BOOL isFirstAppear;
- (void)configTableView;
@end




@interface NSString (TzExtension)
- (BOOL)tz_containsString:(NSString *)string;
- (CGSize)tz_calculateSizeWithAttributes:(NSDictionary *)attributes maxSize:(CGSize)maxSize;
@end


@interface TZCommonTools : NSObject
+ (BOOL)tz_isIPhoneX;
+ (CGFloat)tz_statusBarHeight;
// 获得Info.plist数据字典
+ (NSDictionary *)tz_getInfoDictionary;
@end


@interface TZImagePickerConfig : NSObject
+ (instancetype)sharedInstance;
@property (copy, nonatomic) NSString *preferredLanguage;
@property (assign, nonatomic) BOOL showSelectedIndex;
@property (assign, nonatomic) BOOL showPhotoCannotSelectLayer;
@end
