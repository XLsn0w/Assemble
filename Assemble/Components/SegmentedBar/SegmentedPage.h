//
//  FSPageContentView.h
//  Huim
//
//  Created by huim on 2017/4/28.
//  Copyright © 2017年 huim. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SegmentedPage;

@protocol PageContentViewDelegate <NSObject>

@optional

/**
 FSPageContentView开始滑动

 @param contentView FSPageContentView
 */
- (void)ContentViewWillBeginDragging:(SegmentedPage *)contentView;

/**
 FSPageContentView滑动调用

 @param contentView FSPageContentView
 @param startIndex 开始滑动页面索引
 @param endIndex 结束滑动页面索引
 @param progress 滑动进度
 */
- (void)ContentViewDidScroll:(SegmentedPage *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex progress:(CGFloat)progress;

/**
 FSPageContentView结束滑动

 @param contentView FSPageContentView
 @param startIndex 开始滑动索引
 @param endIndex 结束滑动索引
 */
- (void)ContenViewDidEndDecelerating:(SegmentedPage *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex;

/**
 scrollViewDidEndDragging

 @param contentView FSPageContentView
 */
- (void)ContenViewDidEndDragging:(SegmentedPage *)contentView;

@end

@interface SegmentedPage : UIView

/**
 对象方法创建FSPageContentView

 @param frame frame
 @param childVCs 子VC数组
 @param parentVC 父视图VC
 @param delegate delegate
 @return FSPageContentView
 */
- (instancetype)initWithFrame:(CGRect)frame childVCs:(NSArray *)childVCs parentVC:(UIViewController *)parentVC delegate:(id<PageContentViewDelegate>)delegate;

@property (nonatomic, weak) id<PageContentViewDelegate>delegate;

/**
 设置contentView当前展示的页面索引，默认为0
 */
@property (nonatomic, assign) NSInteger contentViewCurrentIndex;
@property (nonatomic, assign) NSInteger selectedIndex;

/**
 设置contentView能否左右滑动，默认YES
 */
@property (nonatomic, assign) BOOL contentViewCanScroll;

@end
