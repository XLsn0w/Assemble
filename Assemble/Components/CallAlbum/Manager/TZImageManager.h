//
//  TZImageManager.h
//  TZImagePickerController
//
//  Created by 谭真 on 16/1/4.
//  Copyright © 2016年 谭真. All rights reserved.
//  图片资源获取管理类

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "TZAssetModel.h"

@class TZAlbumModel, TZAssetModel;

@protocol TZImagePickerControllerDelegate;

@interface TZImageManager : NSObject

@property (nonatomic, strong) PHCachingImageManager *cachingImageManager;

+ (instancetype)manager;
+ (void)deallocManager;

@property (weak, nonatomic) id<TZImagePickerControllerDelegate> pickerDelegate;

@property (nonatomic, assign) BOOL shouldFixOrientation;

/// Default is 600px / 默认600像素宽
@property (nonatomic, assign) CGFloat photoPreviewMaxWidth;
/// The pixel width of output image, Default is 828px / 导出图片的宽度，默认828像素宽
@property (nonatomic, assign) CGFloat photoWidth;

/// Default is 4, Use in photos collectionView in TZPhotoPickerController
/// 默认4列, TZPhotoPickerController中的照片collectionView
@property (nonatomic, assign) NSInteger columnNumber;

/// Sort photos ascending by modificationDate，Default is YES
/// 对照片排序，按修改时间升序，默认是YES。如果设置为NO,最新的照片会显示在最前面，内部的拍照按钮会排在第一个
@property (nonatomic, assign) BOOL sortAscendingByModificationDate;

/// Minimum selectable photo width, Default is 0
/// 最小可选中的图片宽度，默认是0，小于这个宽度的图片不可选中
@property (nonatomic, assign) NSInteger minPhotoWidthSelectable;
@property (nonatomic, assign) NSInteger minPhotoHeightSelectable;
@property (nonatomic, assign) BOOL hideWhenCanNotSelect;

/// Return YES if Authorized 返回YES如果得到了授权
- (BOOL)authorizationStatusAuthorized;
+ (NSInteger)authorizationStatus;
- (void)requestAuthorizationWithCompletion:(void (^)(void))completion;

/// Get Album 获得相册/相册数组
- (void)getCameraRollAlbumNeedFetchAssets:(BOOL)needFetchAssets completion:(void (^)(TZAlbumModel *model))completion;
- (void)getAllAlbumsNeedFetchAssets:(BOOL)needFetchAssets completion:(void (^)(NSArray<TZAlbumModel *> *models))completion;

/// Get Assets 获得Asset数组
- (void)getAssetsFromFetchResult:(id)result completion:(void (^)(NSArray<TZAssetModel *> *models))completion;

/// Get photo 获得照片
- (void)getPostImageWithAlbumModel:(TZAlbumModel *)model completion:(void (^)(UIImage *postImage))completion;

- (int32_t)getPhotoWithAsset:(id)asset completion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion;
- (int32_t)getPhotoWithAsset:(id)asset photoWidth:(CGFloat)photoWidth completion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion;
- (int32_t)getPhotoWithAsset:(id)asset completion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion progressHandler:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler networkAccessAllowed:(BOOL)networkAccessAllowed;
- (int32_t)getPhotoWithAsset:(id)asset photoWidth:(CGFloat)photoWidth completion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion progressHandler:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler networkAccessAllowed:(BOOL)networkAccessAllowed;
- (int32_t)requestImageDataForAsset:(id)asset completion:(void (^)(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info))completion progressHandler:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler;


/// 如下两个方法completion一般会调多次，一般会先返回缩略图，再返回原图(详见方法内部使用的系统API的说明)，如果info[PHImageResultIsDegradedKey] 为 YES，则表明当前返回的是缩略图，否则是原图。
- (void)getOriginalPhotoWithAsset:(id)asset completion:(void (^)(UIImage *photo,NSDictionary *info))completion;
- (void)getOriginalPhotoWithAsset:(id)asset newCompletion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion;
// 该方法中，completion只会走一次
- (void)getOriginalPhotoDataWithAsset:(id)asset completion:(void (^)(NSData *data,NSDictionary *info,BOOL isDegraded))completion;


/// Get photo bytes 获得一组照片的大小
- (void)getPhotosBytesWithArray:(NSArray *)photos completion:(void (^)(NSString *totalBytes))completion;

/// 判断一个assets数组是否包含这个asset
- (BOOL)isAssetsArray:(NSArray *)assets containAsset:(id)asset;

- (NSString *)getAssetIdentifier:(id)asset;
- (BOOL)isCameraRollAlbum:(id)metadata;

/// 检查照片大小是否满足最小要求
- (BOOL)isPhotoSelectableWithAsset:(id)asset;
- (CGSize)photoSizeWithAsset:(id)asset;

/// 获取asset的资源类型
- (TZAssetModelMediaType)getAssetType:(id)asset;
/// 缩放图片至新尺寸
- (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size;

@end


