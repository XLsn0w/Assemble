//
//  HLScaleImageView.m
//  Hoolink_IoT
//
//  Created by hoolink on 2018/5/27.
//  Copyright © 2018年 hoolink_IoT. All rights reserved.
//

#import "HLScaleImageView.h"
#define IMAGE_URL_STRING(requestString) [requestString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]
@interface HLScaleImageView ()<UIScrollViewDelegate>
{
    float offset;
}
@property (nonatomic, strong)UIScrollView *scrollView;

@property (nonatomic, strong)UIImageView *imageView;

@property (nonatomic, strong)UIPageControl *pageControl;

@property (nonatomic, copy) NSString *string;
@end

@implementation HLScaleImageView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.85];
        offset = 0.0;
        self.string = @"onetime";
        [self addSubview:self.scrollView];
        [self addSubview:self.pageControl];
        [self toolsClickEvent:self.scrollView];
    }
    return self;
}

-(UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = CGRectMake(0, 0, self.width, self.height);
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.backgroundColor = [UIColor clearColor];
    }
    return _scrollView;
}

-(UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.frame = CGRectMake(0, self.height - 45, self.width, 30);
        _pageControl.currentPage = 0;
        _pageControl.numberOfPages = 4;
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        _pageControl.enabled = NO;
    }
    return _pageControl;
}

-(void)slideImageView:(int)totalPages withHomePage:(int)homePage withImageURL:(NSArray *)imageURL {
    self.pageControl.numberOfPages = totalPages;
    self.pageControl.currentPage = homePage;
    CGPoint scrollViewSetSiz = CGPointMake(SCREEN_WIDTH * homePage, 0);
    for (int i = 0; i<totalPages; i++) {
        UIScrollView *scrollViewImage = [[UIScrollView alloc] init];
        scrollViewImage.frame = CGRectMake(SCREEN_WIDTH *i, 0, self.scrollView.width, self.scrollView.height);
        [self.scrollView addSubview:scrollViewImage];
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(0, 0, scrollViewImage.width, scrollViewImage.height);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [imageView sd_setImageWithURL:[NSURL URLWithString:IMAGE_URL_STRING(imageURL[i])] placeholderImage:[UIImage imageNamed:@"hl_placeholder"]];
//            imageView.image = [UIImage imageNamed:@"RQMyOder_ZHWT"];
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                NSString *strUrl = [imageURL[i] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//                NSData * imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:strUrl]];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    if (imageData) {
//                        imageView.image = [UIImage imageWithData:imageData];
//                    }
//                });
//            });
        
        scrollViewImage.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
        scrollViewImage.delegate = self;
        scrollViewImage.maximumZoomScale = 1.7;
        scrollViewImage.minimumZoomScale = 0.8;
        scrollViewImage.showsVerticalScrollIndicator = NO;
        scrollViewImage.showsHorizontalScrollIndicator = NO;
        [scrollViewImage addSubview:imageView];
    }
    self.scrollView.contentSize =CGSizeMake(SCREEN_WIDTH * totalPages, 200);
    [self.scrollView setContentOffset:scrollViewSetSiz animated:NO];
}

-(void)localImageView:(int)totalPages withHomePage:(int)homePage withArrayImage:(NSArray *)arrayImage {
    self.pageControl.numberOfPages = totalPages;
    self.pageControl.currentPage = homePage;
    CGPoint scrollViewSetSiz = CGPointMake(SCREEN_WIDTH * homePage, 0);
    for (int i = 0; i<totalPages; i++) {
        UIScrollView *scrollViewImage = [[UIScrollView alloc] init];
        scrollViewImage.frame = CGRectMake(SCREEN_WIDTH *i, 0, self.scrollView.width, self.scrollView.height);
        [self.scrollView addSubview:scrollViewImage];
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(0, 0, scrollViewImage.width, scrollViewImage.height);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = arrayImage[i];
        scrollViewImage.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
        scrollViewImage.delegate = self;
        scrollViewImage.maximumZoomScale = 1.7;
        scrollViewImage.minimumZoomScale = 0.8;
        scrollViewImage.showsVerticalScrollIndicator = NO;
        scrollViewImage.showsHorizontalScrollIndicator = NO;
        [scrollViewImage addSubview:imageView];
    }
    self.scrollView.contentSize =CGSizeMake(SCREEN_WIDTH * totalPages, 200);
    [self.scrollView setContentOffset:scrollViewSetSiz animated:NO];
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    for (UIView *vie1 in scrollView.subviews) {
        return vie1;
    }
    return nil;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale{
    if(scrollView != self.scrollView) {
        scrollView.contentSize = CGSizeMake(view.right , view.bottom);
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    CGFloat x = 0.0;
    if (scrollView == self.scrollView){
        x = scrollView.contentOffset.x;
        CGPoint offsetx=scrollView.contentOffset;
        NSInteger currentPage=offsetx.x /_scrollView.bounds.size.width;
        self.pageControl.currentPage=currentPage;
        if (x==offset){
            //ToDo:
        }else {
            offset = x;
            for (UIScrollView *s in scrollView.subviews){
                if ([s isKindOfClass:[UIScrollView class]]){
                    [s setZoomScale:1.0];
                }
            }
        }
    }else {
        
    }
}

-(void)toolsClickEvent:(UIView *)view {
    view.userInteractionEnabled = YES;
    UITapGestureRecognizer *singTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onToolsClick)];
    [view addGestureRecognizer:singTap];
}

-(void)onToolsClick {
    if ([_delegate respondsToSelector:@selector(removeEnlargeImageImageView)]) {
        [_delegate removeEnlargeImageImageView];
    }
}



-(void)dealloc {
}


@end
