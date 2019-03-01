
#import "GuidePageViewController.h"
#import "GuidePageManager.h"

@implementation KSGuaidViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.imageView = [[UIImageView alloc] init];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.userInteractionEnabled = YES;
        self.imageView.clipsToBounds = YES;
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.frame = self.contentView.bounds;
}

@end

NSString * const KSGuaidViewCellID = @"KSGuaidViewCellID";


@interface GuidePageViewController ()<
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIPageControl* pageControl;
@property (nonatomic, strong) UICollectionView* collectionView;

@property (nonatomic, strong) UIButton* dismissButton;

@end

@implementation GuidePageViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self setupSubviews];
}

- (void)setupSubviews{
    
    self.view.backgroundColor = [UIColor clearColor];
    
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.bounces = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.backgroundColor = self.view.backgroundColor;
    if (@available(*,iOS 11)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self.collectionView registerClass:[KSGuaidViewCell class] forCellWithReuseIdentifier:KSGuaidViewCellID];
    
    [self.view addSubview:self.collectionView];
    
    self.pageControl = [[UIPageControl alloc] init];
    self.pageControl.userInteractionEnabled = NO;
    self.pageControl.hidesForSinglePage = YES;
    self.pageControl.numberOfPages = GuidePager.images.count;
    self.pageControl.pageIndicatorTintColor = GuidePager.pageIndicatorTintColor;
    self.pageControl.currentPageIndicatorTintColor = GuidePager.currentPageIndicatorTintColor;
    [self.view addSubview:self.pageControl];
    
    if (GuidePager.shouldDismissWhenDragging == NO) {
        
        self.dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.dismissButton.hidden = YES;
//        [self.dismissButton setImage:GuidePager.dismissButtonImage forState:UIControlStateNormal];
        [self.dismissButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self.dismissButton sizeToFit];
        [self.view addSubview:self.dismissButton];
        
    }
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    self.collectionView.frame = self.view.bounds;
    
    CGSize size = [self.pageControl sizeForNumberOfPages:self.pageControl.numberOfPages];
    
    self.pageControl.frame = CGRectMake((CGRectGetWidth(self.view.frame) - size.width) / 2,
                                        CGRectGetHeight(self.view.frame) - size.height,
                                        size.width, size.height);
    
//    self.dismissButton.center = GuidePager.dismissButtonCenter;
    [self.dismissButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(40);
        if (@available(iOS 11.0, *)) {
            // 版本适配
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-40);
        } else {
            make.bottom.mas_equalTo(self.view.mas_bottom).offset(-40);
        }
    }];
    [self.dismissButton setTitle:@"立即体验" forState:(UIControlStateNormal)];
    [self.dismissButton xlsn0w_addCornerRadius:10];
    self.dismissButton.backgroundColor = AppThemeColor;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (GuidePager.shouldDismissWhenDragging) {
        
        return GuidePager.images.count + 1;
        
    }
    
    return GuidePager.images.count;
    
}

- (__kindof UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    KSGuaidViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:KSGuaidViewCellID forIndexPath:indexPath];
    
    if (indexPath.row >= GuidePager.images.count) {
        
        cell.imageView.image = nil;
        
    }else{
       
        cell.imageView.image = GuidePager.images[indexPath.row];
        
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return collectionView.bounds.size;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsZero;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    long current = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);

    self.pageControl.currentPage = lroundf(current);

    if (GuidePager.shouldDismissWhenDragging == NO) {
        
        self.dismissButton.hidden = GuidePager.images.count != current + 1;
    }
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return GuidePager.supportedInterfaceOrientation;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (GuidePager.shouldDismissWhenDragging == YES) {
        int current = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
        if (current == GuidePager.images.count) {
            [self dismiss];
        }
    }
}

/// MARK:- 隐藏
- (void)dismiss{
    if (self.willDismissHandler) {
        self.willDismissHandler();
    }
}

- (BOOL)prefersHomeIndicatorAutoHidden{
    return YES;
}

- (void)dealloc{
    KSLog(@"[DEBUG] delloc:%@",self);
}

@end


