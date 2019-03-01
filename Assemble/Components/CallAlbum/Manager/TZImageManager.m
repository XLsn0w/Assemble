//
//  TZImageManager.m
//  TZImagePickerController
//
//  Created by 谭真 on 16/1/4.
//  Copyright © 2016年 谭真. All rights reserved.
//

#import "TZImageManager.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "TZAssetModel.h"
#import "TZImagePickerController.h"

CGSize AssetGridThumbnailSize;
CGFloat TZScreenWidth;
CGFloat TZScreenScale;

@implementation TZImageManager

///单例
static TZImageManager *manager;
static dispatch_once_t onceToken;
+ (instancetype)manager {
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
        [manager configTZScreenWidth];
    });
    return manager;
}

+ (void)deallocManager {
    onceToken = 0;
    manager = nil;
}

- (void)setPhotoWidth:(CGFloat)photoWidth {
    _photoWidth = photoWidth;
    TZScreenWidth = photoWidth / 2;
}

- (void)setColumnNumber:(NSInteger)columnNumber {
    [self configTZScreenWidth];
    
    _columnNumber = columnNumber;
    CGFloat margin = 4;
    CGFloat itemWH = (TZScreenWidth - 2 * margin - 4) / columnNumber - margin;
    AssetGridThumbnailSize = CGSizeMake(itemWH * TZScreenScale, itemWH * TZScreenScale);
}

- (void)configTZScreenWidth {
    TZScreenWidth = [UIScreen mainScreen].bounds.size.width;
    // 测试发现，如果scale在plus真机上取到3.0，内存会增大特别多。故这里写死成2.0
    TZScreenScale = 2.0;
    if (TZScreenWidth > 700) {
        TZScreenScale = 1.5;
    }
}

/// Return YES if Authorized 返回YES如果得到了授权
- (BOOL)authorizationStatusAuthorized {
    NSInteger status = [self.class authorizationStatus];
    if (status == 0) {
        /**
         * 当某些情况下AuthorizationStatus == AuthorizationStatusNotDetermined时，无法弹出系统首次使用的授权alertView，系统应用设置里亦没有相册的设置，此时将无法使用，故作以下操作，弹出系统首次使用的授权alertView
         */
        [self requestAuthorizationWithCompletion:nil];
    }
    
    return status == 3;
}

+ (NSInteger)authorizationStatus {
    if (iOS8Later) {
        return [PHPhotoLibrary authorizationStatus];
    }
    return NO;
}

- (void)requestAuthorizationWithCompletion:(void (^)(void))completion {
    void (^callCompletionBlock)(void) = ^(){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion();
            }
        });
    };
    
    if (iOS8Later) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                callCompletionBlock();
            }];
        });
    }
}

#pragma mark - Get Album

/// Get Album 获得相册/相册数组
- (void)getCameraRollAlbumNeedFetchAssets:(BOOL)needFetchAssets completion:(void (^)(TZAlbumModel *model))completion {
    __block TZAlbumModel *model;
        PHFetchOptions *option = [[PHFetchOptions alloc] init];
        option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
        if (!self.sortAscendingByModificationDate) {
            option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:self.sortAscendingByModificationDate]];
        }
        PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
        for (PHAssetCollection *collection in smartAlbums) {
            // 有可能是PHCollectionList类的的对象，过滤掉
            if (![collection isKindOfClass:[PHAssetCollection class]]) continue;
            // 过滤空相册
            if (collection.estimatedAssetCount <= 0) continue;
            if ([self isCameraRollAlbum:collection]) {
                PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:option];
                model = [self modelWithResult:fetchResult name:collection.localizedTitle isCameraRoll:YES needFetchAssets:needFetchAssets];
                if (completion) completion(model);
                break;
            }
        }
}

- (void)getAllAlbumsNeedFetchAssets:(BOOL)needFetchAssets completion:(void (^)(NSArray<TZAlbumModel *> *))completion{
    NSMutableArray *albumArr = [NSMutableArray array];
   
        PHFetchOptions *option = [[PHFetchOptions alloc] init];
        option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
        if (!self.sortAscendingByModificationDate) {
            option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:self.sortAscendingByModificationDate]];
        }
        // 我的照片流 1.6.10重新加入..
        PHFetchResult *myPhotoStreamAlbum = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumMyPhotoStream options:nil];
        PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
        PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
        PHFetchResult *syncedAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumSyncedAlbum options:nil];
        PHFetchResult *sharedAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumCloudShared options:nil];
        NSArray *allAlbums = @[myPhotoStreamAlbum,smartAlbums,topLevelUserCollections,syncedAlbums,sharedAlbums];
        for (PHFetchResult *fetchResult in allAlbums) {
            for (PHAssetCollection *collection in fetchResult) {
                // 有可能是PHCollectionList类的的对象，过滤掉
                if (![collection isKindOfClass:[PHAssetCollection class]]) continue;
                // 过滤空相册
                if (collection.estimatedAssetCount <= 0) continue;
                PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:option];
                if (fetchResult.count < 1) continue;
                
                if ([self.pickerDelegate respondsToSelector:@selector(isAlbumCanSelect:result:)]) {
                    if (![self.pickerDelegate isAlbumCanSelect:collection.localizedTitle result:fetchResult]) {
                        continue;
                    }
                }
                
                if (collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumAllHidden) continue;
                if (collection.assetCollectionSubtype == 1000000201) continue; //『最近删除』相册
                if ([self isCameraRollAlbum:collection]) {
                    [albumArr insertObject:[self modelWithResult:fetchResult name:collection.localizedTitle isCameraRoll:YES needFetchAssets:needFetchAssets] atIndex:0];
                } else {
                    [albumArr addObject:[self modelWithResult:fetchResult name:collection.localizedTitle isCameraRoll:NO needFetchAssets:needFetchAssets]];
                }
            }
        }
        if (completion && albumArr.count > 0) completion(albumArr);
    
}


#pragma mark - Get Assets
- (void)getAssetsFromFetchResult:(id)result completion:(void (^)(NSArray<TZAssetModel *> *))completion {
    NSMutableArray *photoArr = [NSMutableArray array];
    if ([result isKindOfClass:[PHFetchResult class]]) {
        PHFetchResult *fetchResult = (PHFetchResult *)result;
        [fetchResult enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            TZAssetModel *model = [self assetModelWithAsset:obj ];
            if (model) {
                [photoArr addObject:model];
            }
        }];
        if (completion) completion(photoArr);
    }
}

///  Get asset at index 获得下标为index的单个照片
///  if index beyond bounds, return nil in callback 如果索引越界, 在回调中返回 nil
- (void)getAssetFromFetchResult:(id)result atIndex:(NSInteger)index completion:(void (^)(TZAssetModel *))completion {
    if ([result isKindOfClass:[PHFetchResult class]]) {
        PHFetchResult *fetchResult = (PHFetchResult *)result;
        PHAsset *asset;
        @try {
            asset = fetchResult[index];
        }
        @catch (NSException* e) {
            if (completion) completion(nil);
            return;
        }
        TZAssetModel *model = [self assetModelWithAsset:asset];
        if (completion) completion(model);
    }
}

- (TZAssetModel *)assetModelWithAsset:(id)asset {
    BOOL canSelect = YES;
    if ([self.pickerDelegate respondsToSelector:@selector(isAssetCanSelect:)]) {
        canSelect = [self.pickerDelegate isAssetCanSelect:asset];
    }
    if (!canSelect) return nil;
    
    TZAssetModel *model;
    TZAssetModelMediaType type = [self getAssetType:asset];
    if ([asset isKindOfClass:[PHAsset class]]) {
        PHAsset *phAsset = (PHAsset *)asset;
        if (self.hideWhenCanNotSelect) {
            // 过滤掉尺寸不满足要求的图片
            if (![self isPhotoSelectableWithAsset:phAsset]) {
                return nil;
            }
        }
        model = [TZAssetModel modelWithAsset:asset type:type timeLength:@""];
    }
    return model;
}

- (TZAssetModelMediaType)getAssetType:(id)asset {
    TZAssetModelMediaType type = TZAssetModelMediaTypePhoto;
    return type;
}

- (NSString *)getNewTimeFromDurationSecond:(NSInteger)duration {
    NSString *newTime;
    if (duration < 10) {
        newTime = [NSString stringWithFormat:@"0:0%ld",(long)duration];
    } else if (duration < 60) {
        newTime = [NSString stringWithFormat:@"0:%ld",(long)duration];
    } else {
        NSInteger min = duration / 60;
        NSInteger sec = duration - (min * 60);
        if (sec < 10) {
            newTime = [NSString stringWithFormat:@"%ld:0%zd",(long)min,sec];
        } else {
            newTime = [NSString stringWithFormat:@"%ld:%zd",(long)min,sec];
        }
    }
    return newTime;
}

//获得一组照片的大小
- (void)getPhotosBytesWithArray:(NSArray *)photos completion:(void (^)(NSString *totalBytes))completion {
    if (!photos || !photos.count) {
        if (completion) completion(@"0B");
        return;
    }
    __block NSInteger dataLength = 0;
    __block NSInteger assetCount = 0;
    for (NSInteger i = 0; i < photos.count; i++) {
        TZAssetModel *model = photos[i];
        if ([model.asset isKindOfClass:[PHAsset class]]) {
            PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
            options.resizeMode = PHImageRequestOptionsResizeModeFast;
            options.networkAccessAllowed = YES;
            [[PHImageManager defaultManager] requestImageDataForAsset:model.asset options:options resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
                assetCount ++;
                if (assetCount >= photos.count) {
                    NSString *bytes = [self getBytesFromDataLength:dataLength];
                    if (completion) completion(bytes);
                }
            }];
        }
    }
}

- (NSString *)getBytesFromDataLength:(NSInteger)dataLength {
    NSString *bytes;
    if (dataLength >= 0.1 * (1024 * 1024)) {
        bytes = [NSString stringWithFormat:@"%0.1fM",dataLength/1024/1024.0];
    } else if (dataLength >= 1024) {
        bytes = [NSString stringWithFormat:@"%0.0fK",dataLength/1024.0];
    } else {
        bytes = [NSString stringWithFormat:@"%ldB",(long)dataLength];
    }
    return bytes;
}

#pragma mark - Get Photo

/// Get photo 获得照片本身
- (int32_t)getPhotoWithAsset:(id)asset completion:(void (^)(UIImage *, NSDictionary *, BOOL isDegraded))completion {
    CGFloat fullScreenWidth = TZScreenWidth;
    if (fullScreenWidth > _photoPreviewMaxWidth) {
        fullScreenWidth = _photoPreviewMaxWidth;
    }
    return [self getPhotoWithAsset:asset photoWidth:fullScreenWidth completion:completion progressHandler:nil networkAccessAllowed:YES];
}

- (int32_t)getPhotoWithAsset:(id)asset photoWidth:(CGFloat)photoWidth completion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion {
    return [self getPhotoWithAsset:asset photoWidth:photoWidth completion:completion progressHandler:nil networkAccessAllowed:YES];
}

- (int32_t)getPhotoWithAsset:(id)asset completion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion progressHandler:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler networkAccessAllowed:(BOOL)networkAccessAllowed {
    CGFloat fullScreenWidth = TZScreenWidth;
    if (fullScreenWidth > _photoPreviewMaxWidth) {
        fullScreenWidth = _photoPreviewMaxWidth;
    }
    return [self getPhotoWithAsset:asset photoWidth:fullScreenWidth completion:completion progressHandler:progressHandler networkAccessAllowed:networkAccessAllowed];
}

- (int32_t)requestImageDataForAsset:(id)asset completion:(void (^)(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info))completion progressHandler:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler {
    if ([asset isKindOfClass:[PHAsset class]]) {
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.progressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (progressHandler) {
                    progressHandler(progress, error, stop, info);
                }
            });
        };
        options.networkAccessAllowed = YES;
        options.resizeMode = PHImageRequestOptionsResizeModeFast;
        int32_t imageRequestID = [[PHImageManager defaultManager] requestImageDataForAsset:asset options:options resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
            if (completion) completion(imageData,dataUTI,orientation,info);
        }];
        return imageRequestID;
    }
    return 0;
}

- (int32_t)getPhotoWithAsset:(id)asset photoWidth:(CGFloat)photoWidth completion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion progressHandler:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler networkAccessAllowed:(BOOL)networkAccessAllowed {
    if ([asset isKindOfClass:[PHAsset class]]) {
        CGSize imageSize;
        if (photoWidth < TZScreenWidth && photoWidth < _photoPreviewMaxWidth) {
            imageSize = AssetGridThumbnailSize;
        } else {
            PHAsset *phAsset = (PHAsset *)asset;
            CGFloat aspectRatio = phAsset.pixelWidth / (CGFloat)phAsset.pixelHeight;
            CGFloat pixelWidth = photoWidth * TZScreenScale * 1.5;
            // 超宽图片
            if (aspectRatio > 1.8) {
                pixelWidth = pixelWidth * aspectRatio;
            }
            // 超高图片
            if (aspectRatio < 0.2) {
                pixelWidth = pixelWidth * 0.5;
            }
            CGFloat pixelHeight = pixelWidth / aspectRatio;
            imageSize = CGSizeMake(pixelWidth, pixelHeight);
        }
        __block UIImage *image;
        // 修复获取图片时出现的瞬间内存过高问题
        PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
        option.resizeMode = PHImageRequestOptionsResizeModeFast;
        int32_t imageRequestID = [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:imageSize contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage *result, NSDictionary *info) {
            if (result) {
                image = result;
            }
            BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
            if (downloadFinined && result) {
                result = [self fixOrientation:result];
                if (completion) completion(result,info,[[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
            }
            // Download image from iCloud / 从iCloud下载图片
            if ([info objectForKey:PHImageResultIsInCloudKey] && !result && networkAccessAllowed) {
                PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
                options.progressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (progressHandler) {
                            progressHandler(progress, error, stop, info);
                        }
                    });
                };
                options.networkAccessAllowed = YES;
                options.resizeMode = PHImageRequestOptionsResizeModeFast;
                [[PHImageManager defaultManager] requestImageDataForAsset:asset options:options resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
                    UIImage *resultImage = [UIImage imageWithData:imageData scale:0.1];
                    resultImage = [self scaleImage:resultImage toSize:imageSize];
                    if (!resultImage) {
                        resultImage = image;
                    }
                    resultImage = [self fixOrientation:resultImage];
                    if (completion) completion(resultImage,info,NO);
                }];
            }
        }];
        return imageRequestID;
    }
    return 0;
}

/// Get postImage / 获取封面图
- (void)getPostImageWithAlbumModel:(TZAlbumModel *)model completion:(void (^)(UIImage *))completion {
    if (iOS8Later) {
        id asset = [model.result lastObject];
        if (!self.sortAscendingByModificationDate) {
            asset = [model.result firstObject];
        }
        [[TZImageManager manager] getPhotoWithAsset:asset photoWidth:80 completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
            if (completion) completion(photo);
        }];
    }
}

/// Get Original Photo / 获取原图
- (void)getOriginalPhotoWithAsset:(id)asset completion:(void (^)(UIImage *photo,NSDictionary *info))completion {
    [self getOriginalPhotoWithAsset:asset newCompletion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
        if (completion) {
            completion(photo,info);
        }
    }];
}

- (void)getOriginalPhotoWithAsset:(id)asset newCompletion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion {
    if ([asset isKindOfClass:[PHAsset class]]) {
        PHImageRequestOptions *option = [[PHImageRequestOptions alloc]init];
        option.networkAccessAllowed = YES;
        option.resizeMode = PHImageRequestOptionsResizeModeFast;
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFit options:option resultHandler:^(UIImage *result, NSDictionary *info) {
            BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
            if (downloadFinined && result) {
                result = [self fixOrientation:result];
                BOOL isDegraded = [[info objectForKey:PHImageResultIsDegradedKey] boolValue];
                if (completion) completion(result,info,isDegraded);
            }
        }];
    }
}

- (void)getOriginalPhotoDataWithAsset:(id)asset completion:(void (^)(NSData *data,NSDictionary *info,BOOL isDegraded))completion {
    if ([asset isKindOfClass:[PHAsset class]]) {
        PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
        option.networkAccessAllowed = YES;
        if ([[asset valueForKey:@"filename"] hasSuffix:@"GIF"]) {
            // if version isn't PHImageRequestOptionsVersionOriginal, the gif may cann't play
            option.version = PHImageRequestOptionsVersionOriginal;
        }
        option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        [[PHImageManager defaultManager] requestImageDataForAsset:asset options:option resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
            BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
            if (downloadFinined && imageData) {
                if (completion) completion(imageData,info,NO);
            }
        }];
    }
}

/// Judge is a assets array contain the asset 判断一个assets数组是否包含这个asset
- (BOOL)isAssetsArray:(NSArray *)assets containAsset:(id)asset {
    if (iOS8Later) {
        return [assets containsObject:asset];
    }
    return [assets containsObject:asset];
}

- (BOOL)isCameraRollAlbum:(id)metadata {
    if ([metadata isKindOfClass:[PHAssetCollection class]]) {
        NSString *versionStr = [[UIDevice currentDevice].systemVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
        if (versionStr.length <= 1) {
            versionStr = [versionStr stringByAppendingString:@"00"];
        } else if (versionStr.length <= 2) {
            versionStr = [versionStr stringByAppendingString:@"0"];
        }
        CGFloat version = versionStr.floatValue;
        // 目前已知8.0.0 ~ 8.0.2系统，拍照后的图片会保存在最近添加中
        if (version >= 800 && version <= 802) {
            return ((PHAssetCollection *)metadata).assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumRecentlyAdded;
        } else {
            return ((PHAssetCollection *)metadata).assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary;
        }
    }
    
    return NO;
}

- (NSString *)getAssetIdentifier:(id)asset {
    if (iOS8Later) {
        PHAsset *phAsset = (PHAsset *)asset;
        return phAsset.localIdentifier;
    }
    PHAsset *phAsset = (PHAsset *)asset;
    return phAsset.localIdentifier;
}

/// 检查照片大小是否满足最小要求
- (BOOL)isPhotoSelectableWithAsset:(id)asset {
    CGSize photoSize = [self photoSizeWithAsset:asset];
    if (self.minPhotoWidthSelectable > photoSize.width || self.minPhotoHeightSelectable > photoSize.height) {
        return NO;
    }
    return YES;
}

- (CGSize)photoSizeWithAsset:(id)asset {
    if (iOS8Later) {
        PHAsset *phAsset = (PHAsset *)asset;
        return CGSizeMake(phAsset.pixelWidth, phAsset.pixelHeight);
    }
    PHAsset *phAsset = (PHAsset *)asset;
    return CGSizeMake(phAsset.pixelWidth, phAsset.pixelHeight);
}

#pragma mark - Private Method

- (TZAlbumModel *)modelWithResult:(id)result name:(NSString *)name isCameraRoll:(BOOL)isCameraRoll needFetchAssets:(BOOL)needFetchAssets {
    TZAlbumModel *model = [[TZAlbumModel alloc] init];
    [model setResult:result needFetchAssets:needFetchAssets];
    model.name = name;
    model.isCameraRoll = isCameraRoll;
    if ([result isKindOfClass:[PHFetchResult class]]) {
        PHFetchResult *fetchResult = (PHFetchResult *)result;
        model.count = fetchResult.count;
    }
    return model;
}

/// 缩放图片至新尺寸
- (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size {
    if (image.size.width > size.width) {
        UIGraphicsBeginImageContext(size);
        [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage;
    } else {
        return image;
    }
}


/// 修正图片转向
- (UIImage *)fixOrientation:(UIImage *)aImage {
    if (!self.shouldFixOrientation) return aImage;
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

#pragma clang diagnostic pop

@end


