//
//  TZPhotoPickerController.m
//  TZImagePickerController
//
//  Created by 谭真 on 15/12/24.
//  Copyright © 2015年 谭真. All rights reserved.
//

#import "TZPhotoPickerController.h"
#import "TZImagePickerController.h"
#import "TZPhotoPreviewController.h"
#import "TZAssetCell.h"
#import "TZAssetModel.h"
#import "TZImageManager.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface TZPhotoPickerController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate> {
    NSMutableArray *_models;
    
    UIView *_bottomToolBar;
    UIButton *_previewButton;
    UIButton *_doneButton;
    UIImageView *_numberImageView;
    UILabel *_numberLabel;
    UIButton *_originalPhotoButton;
    UILabel *_originalPhotoLabel;
    UIView *_divideLine;
    
    BOOL _shouldScrollToBottom;
    BOOL _showTakePhotoBtn;
    
    CGFloat _offsetItemCount;
}
@property CGRect previousPreheatRect;
@property (nonatomic, assign) BOOL isSelectOriginalPhoto;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (strong, nonatomic) CLLocation *location;
@property (assign, nonatomic) BOOL useCachedImage;
@end

static CGSize AssetGridThumbnailSize;
static CGFloat itemMargin = 5;

@implementation TZPhotoPickerController

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        if (iOS7Later) {
            _imagePickerVc.navigationBar.barTintColor = [UIColor blackColor];
        }
        _imagePickerVc.navigationBar.tintColor = [UIColor blackColor];
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    HLLog(@"TZPhotoPickerController");
    self.isFirstAppear = YES;
    TZImagePickerController *tzImagePickerVc = (TZImagePickerController *)self.navigationController;
    _isSelectOriginalPhoto = tzImagePickerVc.isSelectOriginalPhoto;
    _shouldScrollToBottom = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = _model.name;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:tzImagePickerVc.cancelBtnTitleStr style:UIBarButtonItemStylePlain target:tzImagePickerVc action:@selector(cancelButtonClick)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeStatusBarOrientationNotification:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)fetchAssetModels {
    TZImagePickerController *tzImagePickerVc = (TZImagePickerController *)self.navigationController;
    if (_isFirstAppear && !_model.models.count) {
//        [tzImagePickerVc showProgressHUD];
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (!tzImagePickerVc.sortAscendingByModificationDate && self->_isFirstAppear && iOS8Later && self->_model.isCameraRoll) {
            
        } else {
            if (self->_showTakePhotoBtn || !iOS8Later || self->_isFirstAppear) {
                [[TZImageManager manager] getAssetsFromFetchResult:self->_model.result completion:^(NSArray<TZAssetModel *> *models) {
                    self->_models = [NSMutableArray arrayWithArray:models];
                    [self initSubviews];
                }];
            } else {
                self->_models = [NSMutableArray arrayWithArray:self->_model.models];
                [self initSubviews];
            }
        }
    });
}

- (void)initSubviews {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self checkSelectedModels];
        [self configCollectionView];
        self->_collectionView.hidden = YES;
        [self configBottomToolBar];
        
        [self scrollCollectionViewToBottom];
    });
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    TZImagePickerController *tzImagePickerVc = (TZImagePickerController *)self.navigationController;
    tzImagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (void)configCollectionView {
    _layout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.alwaysBounceHorizontal = NO;
    _collectionView.contentInset = UIEdgeInsetsMake(itemMargin, itemMargin, itemMargin, itemMargin);
    
    if (_showTakePhotoBtn) {
        _collectionView.contentSize = CGSizeMake(self.view.width, ((_model.count + self.columnNumber) / self.columnNumber) * self.view.width);
    } else {
        _collectionView.contentSize = CGSizeMake(self.view.width, ((_model.count + self.columnNumber - 1) / self.columnNumber) * self.view.width);
    }
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[TZAssetCell class] forCellWithReuseIdentifier:@"TZAssetCell"];
   
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // Determine the size of the thumbnails to request from the PHCachingImageManager
    CGFloat scale = 2.0;
    if ([UIScreen mainScreen].bounds.size.width > 600) {
        scale = 1.0;
    }
    CGSize cellSize = ((UICollectionViewFlowLayout *)_collectionView.collectionViewLayout).itemSize;
    AssetGridThumbnailSize = CGSizeMake(cellSize.width * scale, cellSize.height * scale);
    
    if (!_models) {
        [self fetchAssetModels];
    }
}

- (void)configBottomToolBar {
    TZImagePickerController *tzImagePickerVc = (TZImagePickerController *)self.navigationController;
    _bottomToolBar = [[UIView alloc] initWithFrame:CGRectZero];
    CGFloat rgb = 253 / 255.0;
    _bottomToolBar.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1.0];
    
    _previewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_previewButton addTarget:self action:@selector(previewButtonClick) forControlEvents:UIControlEventTouchUpInside];
    _previewButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_previewButton setTitle:tzImagePickerVc.previewBtnTitleStr forState:UIControlStateNormal];
    [_previewButton setTitle:tzImagePickerVc.previewBtnTitleStr forState:UIControlStateDisabled];
    [_previewButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_previewButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    _previewButton.enabled = tzImagePickerVc.selectedModels.count;
    
    
    
    _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _doneButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_doneButton addTarget:self action:@selector(doneButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_doneButton setTitle:tzImagePickerVc.doneBtnTitleStr forState:UIControlStateNormal];
    [_doneButton setTitle:tzImagePickerVc.doneBtnTitleStr forState:UIControlStateDisabled];
    [_doneButton setTitleColor:tzImagePickerVc.oKButtonTitleColorNormal forState:UIControlStateNormal];
    [_doneButton setTitleColor:tzImagePickerVc.oKButtonTitleColorDisabled forState:UIControlStateDisabled];
    _doneButton.enabled = tzImagePickerVc.selectedModels.count || tzImagePickerVc.alwaysEnableDoneBtn;
    
    _numberImageView = [[UIImageView alloc] initWithImage:tzImagePickerVc.photoNumberIconImage];
    _numberImageView.hidden = tzImagePickerVc.selectedModels.count <= 0;
    _numberImageView.clipsToBounds = YES;
    _numberImageView.contentMode = UIViewContentModeScaleAspectFit;
    _numberImageView.backgroundColor = [UIColor clearColor];
    
    _numberLabel = [[UILabel alloc] init];
    _numberLabel.font = [UIFont systemFontOfSize:15];
    _numberLabel.textColor = [UIColor whiteColor];
    _numberLabel.textAlignment = NSTextAlignmentCenter;
    _numberLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)tzImagePickerVc.selectedModels.count];
    _numberLabel.hidden = tzImagePickerVc.selectedModels.count <= 0;
    _numberLabel.backgroundColor = [UIColor clearColor];
    
    _divideLine = [[UIView alloc] init];
    CGFloat rgb2 = 222 / 255.0;
    _divideLine.backgroundColor = [UIColor colorWithRed:rgb2 green:rgb2 blue:rgb2 alpha:1.0];
    
    [_bottomToolBar addSubview:_divideLine];
    [_bottomToolBar addSubview:_previewButton];
    [_bottomToolBar addSubview:_doneButton];
    [_bottomToolBar addSubview:_numberImageView];
    [_bottomToolBar addSubview:_numberLabel];
    [_bottomToolBar addSubview:_originalPhotoButton];
    [self.view addSubview:_bottomToolBar];
    [_originalPhotoButton addSubview:_originalPhotoLabel];
}

#pragma mark - Layout

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    TZImagePickerController *tzImagePickerVc = (TZImagePickerController *)self.navigationController;
    
    CGFloat top = 0;
    CGFloat collectionViewHeight = 0;
    CGFloat naviBarHeight = self.navigationController.navigationBar.height;
    BOOL isStatusBarHidden = [UIApplication sharedApplication].isStatusBarHidden;
    CGFloat toolBarHeight = [TZCommonTools tz_isIPhoneX] ? 50 + (83 - 49) : 50;
    if (self.navigationController.navigationBar.isTranslucent) {
        top = naviBarHeight;
        if (iOS7Later && !isStatusBarHidden) top += [TZCommonTools tz_statusBarHeight];
        collectionViewHeight =  self.view.height - toolBarHeight - top;
    } else {
        collectionViewHeight = self.view.height - toolBarHeight;
    }
    _collectionView.frame = CGRectMake(0, top, self.view.width, collectionViewHeight);
    CGFloat itemWH = (self.view.width - (self.columnNumber + 1) * itemMargin) / self.columnNumber;
    _layout.itemSize = CGSizeMake(itemWH, itemWH);
    _layout.minimumInteritemSpacing = itemMargin;
    _layout.minimumLineSpacing = itemMargin;
    [_collectionView setCollectionViewLayout:_layout];
    if (_offsetItemCount > 0) {
        CGFloat offsetY = _offsetItemCount * (_layout.itemSize.height + _layout.minimumLineSpacing);
        [_collectionView setContentOffset:CGPointMake(0, offsetY)];
    }
    
    CGFloat toolBarTop = 0;
    if (!self.navigationController.navigationBar.isHidden) {
        toolBarTop = self.view.height - toolBarHeight;
    } else {
        CGFloat navigationHeight = naviBarHeight;
        if (iOS7Later) navigationHeight += [TZCommonTools tz_statusBarHeight];
        toolBarTop = self.view.height - toolBarHeight - navigationHeight;
    }
    _bottomToolBar.frame = CGRectMake(0, toolBarTop, self.view.width, toolBarHeight);
    CGFloat previewWidth = [tzImagePickerVc.previewBtnTitleStr tz_calculateSizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].width + 2;
    _previewButton.frame = CGRectMake(10, 3, previewWidth, 44);
    _previewButton.width =  previewWidth;
    
    [_doneButton sizeToFit];
    _doneButton.frame = CGRectMake(self.view.width - _doneButton.width - 12, 0, _doneButton.width, 50);
    _numberImageView.frame = CGRectMake(_doneButton.left - 24 - 5, 13, 24, 24);
    _numberLabel.frame = _numberImageView.frame;
    _divideLine.frame = CGRectMake(0, 0, self.view.width, 1);
    
    [TZImageManager manager].columnNumber = [TZImageManager manager].columnNumber;
    [self.collectionView reloadData];
}

#pragma mark - Notification

- (void)didChangeStatusBarOrientationNotification:(NSNotification *)noti {
    _offsetItemCount = _collectionView.contentOffset.y / (_layout.itemSize.height + _layout.minimumLineSpacing);
}

#pragma mark - Click Event
- (void)navLeftBarButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)previewButtonClick {
    TZPhotoPreviewController *photoPreviewVc = [[TZPhotoPreviewController alloc] init];
    [self pushPhotoPrevireViewController:photoPreviewVc];
}

- (void)originalPhotoButtonClick {
    _originalPhotoButton.selected = !_originalPhotoButton.isSelected;
    _isSelectOriginalPhoto = _originalPhotoButton.isSelected;
    _originalPhotoLabel.hidden = !_originalPhotoButton.isSelected;
}

- (void)doneButtonClick {
    TZImagePickerController *tzImagePickerVc = (TZImagePickerController *)self.navigationController;
    //判断是否满足最小必选张数的限制
    if (tzImagePickerVc.minImagesCount && tzImagePickerVc.selectedModels.count < tzImagePickerVc.minImagesCount) {
        NSString *title = [NSString stringWithFormat:@"最少只能选择%ld张照片", (long)tzImagePickerVc.minImagesCount];
        [tzImagePickerVc showAlertWithTitle:title];
        return;
    }
    NSMutableArray *assets = [NSMutableArray array];
    NSMutableArray *photos;
    NSMutableArray *infoArr;
        photos = [NSMutableArray array];
        infoArr = [NSMutableArray array];
        for (NSInteger i = 0; i < tzImagePickerVc.selectedModels.count; i++) { [photos addObject:@1];[assets addObject:@1];[infoArr addObject:@1]; }
        
        __block BOOL havenotShowAlert = YES;
        [TZImageManager manager].shouldFixOrientation = YES;
        __block id alertView;
        for (NSInteger i = 0; i < tzImagePickerVc.selectedModels.count; i++) {
            TZAssetModel *model = tzImagePickerVc.selectedModels[i];
            [[TZImageManager manager] getPhotoWithAsset:model.asset completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
                if (isDegraded) return;
                if (photo) {
                    photo = [[TZImageManager manager] scaleImage:photo toSize:CGSizeMake(tzImagePickerVc.photoWidth, (int)(tzImagePickerVc.photoWidth * photo.size.height / photo.size.width))];
                    [photos replaceObjectAtIndex:i withObject:photo];
                }
                if (info)  [infoArr replaceObjectAtIndex:i withObject:info];
                [assets replaceObjectAtIndex:i withObject:model.asset];
                
                for (id item in photos) { if ([item isKindOfClass:[NSNumber class]]) return; }
                
                if (havenotShowAlert) {
                    [tzImagePickerVc hideAlertView:alertView];
                    [self didGetAllPhotos:photos assets:assets infoArr:infoArr];
                }
            } progressHandler:^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
                // 如果图片正在从iCloud同步中,提醒用户
                if (progress < 1 && havenotShowAlert && !alertView) {
                    alertView = [tzImagePickerVc showAlertWithTitle:@"Synchronizing photos from iCloud"];
                    havenotShowAlert = NO;
                    return;
                }
                if (progress >= 1) {
                    havenotShowAlert = YES;
                }
            } networkAccessAllowed:YES];
        }
    
    if (tzImagePickerVc.selectedModels.count <= 0 ) {
        [self didGetAllPhotos:photos assets:assets infoArr:infoArr];
    }
}

- (void)didGetAllPhotos:(NSArray *)photos assets:(NSArray *)assets infoArr:(NSArray *)infoArr {
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        [self callDelegateMethodWithPhotos:photos assets:assets infoArr:infoArr];
    }];
}

- (void)callDelegateMethodWithPhotos:(NSArray *)photos assets:(NSArray *)assets infoArr:(NSArray *)infoArr {
    TZImagePickerController *tzImagePickerVc = (TZImagePickerController *)self.navigationController;
   
    
    if ([tzImagePickerVc.pickerDelegate respondsToSelector:@selector(imagePickerController:didFinishPickingPhotos:sourceAssets:isSelectOriginalPhoto:)]) {
        [tzImagePickerVc.pickerDelegate imagePickerController:tzImagePickerVc didFinishPickingPhotos:photos sourceAssets:assets isSelectOriginalPhoto:_isSelectOriginalPhoto];
    }
    if ([tzImagePickerVc.pickerDelegate respondsToSelector:@selector(imagePickerController:didFinishPickingPhotos:sourceAssets:isSelectOriginalPhoto:infos:)]) {
        [tzImagePickerVc.pickerDelegate imagePickerController:tzImagePickerVc didFinishPickingPhotos:photos sourceAssets:assets isSelectOriginalPhoto:_isSelectOriginalPhoto infos:infoArr];
    }
    if (tzImagePickerVc.didFinishPickingPhotosHandle) {
        tzImagePickerVc.didFinishPickingPhotosHandle(photos,assets,_isSelectOriginalPhoto);
    }
    if (tzImagePickerVc.didFinishPickingPhotosWithInfosHandle) {
        tzImagePickerVc.didFinishPickingPhotosWithInfosHandle(photos,assets,_isSelectOriginalPhoto,infoArr);
    }
}

#pragma mark - UICollectionViewDataSource && Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_showTakePhotoBtn) {
        return _models.count + 1;
    }
    return _models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TZImagePickerController *tzImagePickerVc = (TZImagePickerController *)self.navigationController;
    TZAssetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZAssetCell" forIndexPath:indexPath];
    cell.photoDefImage = [UIImage imageNamed:@"photo_def_photoPickerVc"];
    cell.photoSelImage = tzImagePickerVc.photoSelImage;
    cell.useCachedImage = self.useCachedImage;
    TZAssetModel *model;
    if (tzImagePickerVc.sortAscendingByModificationDate || !_showTakePhotoBtn) {
        model = _models[indexPath.item];
    } else {
        model = _models[indexPath.item - 1];
    }
    cell.model = model;
    if (model.isSelected && tzImagePickerVc.showSelectedIndex) {
        NSString *assetId = [[TZImageManager manager] getAssetIdentifier:model.asset];
        cell.index = [tzImagePickerVc.selectedAssetIds indexOfObject:assetId] + 1;
    }
    cell.showSelectBtn = YES;
    cell.allowPreview = YES;
    
    if (tzImagePickerVc.selectedModels.count >= tzImagePickerVc.maxImagesCount && tzImagePickerVc.showPhotoCannotSelectLayer && !model.isSelected) {
        cell.cannotSelectLayerButton.backgroundColor = tzImagePickerVc.cannotSelectLayerColor;
        cell.cannotSelectLayerButton.hidden = NO;
    } else {
        cell.cannotSelectLayerButton.hidden = YES;
    }
    
    __weak typeof(cell) weakCell = cell;
    __weak typeof(self) weakSelf = self;
    __weak typeof(_numberImageView.layer) weakLayer = _numberImageView.layer;
    cell.didSelectPhotoBlock = ^(BOOL isSelected) {
        __strong typeof(weakCell) strongCell = weakCell;
        __strong typeof(weakSelf) strongSelf = weakSelf;
        __strong typeof(weakLayer) strongLayer = weakLayer;
        TZImagePickerController *tzImagePickerVc = (TZImagePickerController *)strongSelf.navigationController;
        if (isSelected) {
            strongCell.selectPhotoButton.selected = NO;
            model.isSelected = NO;
            NSArray *selectedModels = [NSArray arrayWithArray:tzImagePickerVc.selectedModels];
            for (TZAssetModel *model_item in selectedModels) {
                if ([[[TZImageManager manager] getAssetIdentifier:model.asset] isEqualToString:[[TZImageManager manager] getAssetIdentifier:model_item.asset]]) {
                    [tzImagePickerVc removeSelectedModel:model_item];
                    break;
                }
            }
            [strongSelf refreshBottomToolBarStatus];
            if (tzImagePickerVc.showSelectedIndex || tzImagePickerVc.showPhotoCannotSelectLayer) {
                [strongSelf setUseCachedImageAndReloadData];
            }
            [UIView showOscillatoryAnimationWithLayer:strongLayer type:TZOscillatoryAnimationToSmaller];
        } else {
            // 2. select:check if over the maxImagesCount / 选择照片,检查是否超过了最大个数的限制
            if (tzImagePickerVc.selectedModels.count < tzImagePickerVc.maxImagesCount) {
                strongCell.selectPhotoButton.selected = YES;
                model.isSelected = YES;
                if (tzImagePickerVc.showSelectedIndex || tzImagePickerVc.showPhotoCannotSelectLayer) {
                    model.needOscillatoryAnimation = YES;
                    [strongSelf setUseCachedImageAndReloadData];
                }
                [tzImagePickerVc addSelectedModel:model];
                [strongSelf refreshBottomToolBarStatus];
                [UIView showOscillatoryAnimationWithLayer:strongLayer type:TZOscillatoryAnimationToSmaller];
            } else {
                NSString *title = [NSString stringWithFormat:@"最多只能选择%ld张照片", (long)tzImagePickerVc.maxImagesCount];
                [tzImagePickerVc showAlertWithTitle:title];
            }
        }
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    TZImagePickerController *tzImagePickerVc = (TZImagePickerController *)self.navigationController;
    NSInteger index = indexPath.item;
    if (!tzImagePickerVc.sortAscendingByModificationDate && _showTakePhotoBtn) {
        index = indexPath.item - 1;
    }
    TZPhotoPreviewController *photoPreviewVc = [[TZPhotoPreviewController alloc] init];
    photoPreviewVc.currentIndex = index;
    photoPreviewVc.models = _models;
    [self pushPhotoPrevireViewController:photoPreviewVc];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (iOS8Later) {
         [self updateCachedAssets];
    }
}

#pragma mark - Private Method

- (void)setUseCachedImageAndReloadData {
    self.useCachedImage = YES;
    [self.collectionView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.useCachedImage = NO;
    });
}


- (void)refreshBottomToolBarStatus {
    TZImagePickerController *tzImagePickerVc = (TZImagePickerController *)self.navigationController;
    
    _previewButton.enabled = tzImagePickerVc.selectedModels.count > 0;
    _doneButton.enabled = tzImagePickerVc.selectedModels.count > 0 || tzImagePickerVc.alwaysEnableDoneBtn;
    
    _numberImageView.hidden = tzImagePickerVc.selectedModels.count <= 0;
    _numberLabel.hidden = tzImagePickerVc.selectedModels.count <= 0;
    _numberLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)tzImagePickerVc.selectedModels.count];
    
    _originalPhotoButton.enabled = tzImagePickerVc.selectedModels.count > 0;
    _originalPhotoButton.selected = (_isSelectOriginalPhoto && _originalPhotoButton.enabled);
    _originalPhotoLabel.hidden = (!_originalPhotoButton.isSelected);
}

- (void)pushPhotoPrevireViewController:(TZPhotoPreviewController *)photoPreviewVc {
    __weak typeof(self) weakSelf = self;
    photoPreviewVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    [photoPreviewVc setBackButtonClickBlock:^(BOOL isSelectOriginalPhoto) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.isSelectOriginalPhoto = isSelectOriginalPhoto;
        [strongSelf.collectionView reloadData];
        [strongSelf refreshBottomToolBarStatus];
    }];
    [photoPreviewVc setDoneButtonClickBlock:^(BOOL isSelectOriginalPhoto) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.isSelectOriginalPhoto = isSelectOriginalPhoto;
        [strongSelf doneButtonClick];
    }];
    [photoPreviewVc setDoneButtonClickBlockCropMode:^(UIImage *cropedImage, id asset) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf didGetAllPhotos:@[cropedImage] assets:@[asset] infoArr:nil];
    }];
    [self.navigationController pushViewController:photoPreviewVc animated:YES];
}

- (void)scrollCollectionViewToBottom {
    TZImagePickerController *tzImagePickerVc = (TZImagePickerController *)self.navigationController;
    if (_shouldScrollToBottom && _models.count > 0) {
        NSInteger item = 0;
        if (tzImagePickerVc.sortAscendingByModificationDate) {
            item = _models.count - 1;
            if (_showTakePhotoBtn) {
                item += 1;
            }
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self->_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
            self->_shouldScrollToBottom = NO;
            self->_collectionView.hidden = NO;
        });
    } else {
        _collectionView.hidden = NO;
    }
}

- (void)checkSelectedModels {
    NSMutableArray *selectedAssets = [NSMutableArray array];
    TZImagePickerController *tzImagePickerVc = (TZImagePickerController *)self.navigationController;
    for (TZAssetModel *model in tzImagePickerVc.selectedModels) {
        [selectedAssets addObject:model.asset];
    }
    for (TZAssetModel *model in _models) {
        model.isSelected = NO;
        if ([[TZImageManager manager] isAssetsArray:selectedAssets containAsset:model.asset]) {
            model.isSelected = YES;
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc {
    // HLLog(@"%@ dealloc",NSStringFromClass(self.class));
}

#pragma mark - Asset Caching

- (void)resetCachedAssets {
    [[TZImageManager manager].cachingImageManager stopCachingImagesForAllAssets];
    self.previousPreheatRect = CGRectZero;
}

- (void)updateCachedAssets {
    BOOL isViewVisible = [self isViewLoaded] && [[self view] window] != nil;
    if (!isViewVisible) { return; }

    // The preheat window is twice the height of the visible rect.
    CGRect preheatRect = _collectionView.bounds;
    preheatRect = CGRectInset(preheatRect, 0.0f, -0.5f * CGRectGetHeight(preheatRect));

    CGFloat delta = ABS(CGRectGetMidY(preheatRect) - CGRectGetMidY(self.previousPreheatRect));
    if (delta > CGRectGetHeight(_collectionView.bounds) / 3.0f) {

        // Compute the assets to start caching and to stop caching.
        NSMutableArray *addedIndexPaths = [NSMutableArray array];
        NSMutableArray *removedIndexPaths = [NSMutableArray array];

        [self computeDifferenceBetweenRect:self.previousPreheatRect andRect:preheatRect removedHandler:^(CGRect removedRect) {
            NSArray *indexPaths = [self aapl_indexPathsForElementsInRect:removedRect];
            [removedIndexPaths addObjectsFromArray:indexPaths];
        } addedHandler:^(CGRect addedRect) {
            NSArray *indexPaths = [self aapl_indexPathsForElementsInRect:addedRect];
            [addedIndexPaths addObjectsFromArray:indexPaths];
        }];

        NSArray *assetsToStartCaching = [self assetsAtIndexPaths:addedIndexPaths];
        NSArray *assetsToStopCaching = [self assetsAtIndexPaths:removedIndexPaths];

        [[TZImageManager manager].cachingImageManager startCachingImagesForAssets:assetsToStartCaching
                                                                       targetSize:AssetGridThumbnailSize
                                                                      contentMode:PHImageContentModeAspectFill
                                                                          options:nil];
        [[TZImageManager manager].cachingImageManager stopCachingImagesForAssets:assetsToStopCaching
                                                                      targetSize:AssetGridThumbnailSize
                                                                     contentMode:PHImageContentModeAspectFill
                                                                         options:nil];

        // Store the preheat rect to compare against in the future.
        self.previousPreheatRect = preheatRect;
    }
}

- (void)computeDifferenceBetweenRect:(CGRect)oldRect andRect:(CGRect)newRect removedHandler:(void (^)(CGRect removedRect))removedHandler addedHandler:(void (^)(CGRect addedRect))addedHandler {
    if (CGRectIntersectsRect(newRect, oldRect)) {
        CGFloat oldMaxY = CGRectGetMaxY(oldRect);
        CGFloat oldMinY = CGRectGetMinY(oldRect);
        CGFloat newMaxY = CGRectGetMaxY(newRect);
        CGFloat newMinY = CGRectGetMinY(newRect);

        if (newMaxY > oldMaxY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, oldMaxY, newRect.size.width, (newMaxY - oldMaxY));
            addedHandler(rectToAdd);
        }

        if (oldMinY > newMinY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, newMinY, newRect.size.width, (oldMinY - newMinY));
            addedHandler(rectToAdd);
        }

        if (newMaxY < oldMaxY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, newMaxY, newRect.size.width, (oldMaxY - newMaxY));
            removedHandler(rectToRemove);
        }

        if (oldMinY < newMinY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, oldMinY, newRect.size.width, (newMinY - oldMinY));
            removedHandler(rectToRemove);
        }
    } else {
        addedHandler(newRect);
        removedHandler(oldRect);
    }
}

- (NSArray *)assetsAtIndexPaths:(NSArray *)indexPaths {
    if (indexPaths.count == 0) { return nil; }

    NSMutableArray *assets = [NSMutableArray arrayWithCapacity:indexPaths.count];
    for (NSIndexPath *indexPath in indexPaths) {
        if (indexPath.item < _models.count) {
            TZAssetModel *model = _models[indexPath.item];
            [assets addObject:model.asset];
        }
    }

    return assets;
}

- (NSArray *)aapl_indexPathsForElementsInRect:(CGRect)rect {
    NSArray *allLayoutAttributes = [_collectionView.collectionViewLayout layoutAttributesForElementsInRect:rect];
    if (allLayoutAttributes.count == 0) { return nil; }
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:allLayoutAttributes.count];
    for (UICollectionViewLayoutAttributes *layoutAttributes in allLayoutAttributes) {
        NSIndexPath *indexPath = layoutAttributes.indexPath;
        [indexPaths addObject:indexPath];
    }
    return indexPaths;
}
#pragma clang diagnostic pop

@end

