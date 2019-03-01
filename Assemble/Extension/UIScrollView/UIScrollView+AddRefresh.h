
#import <UIKit/UIKit.h>

typedef void(^HeaderAction)(void);
typedef void(^FooterAction)(NSInteger pageIndex);


@interface UIScrollView (AddRefresh)
/**
 下拉刷新

 @param beginRefresh 是否自动刷新
 @param animation 是否需要动画
 @param headerAction 下拉刷新回调
 */
- (void)addHeaderRefresh:(BOOL)beginRefresh animation:(BOOL)animation headerAction:(HeaderAction)headerAction;

/**
 上啦加载

 @param automaticallyRefresh 是否自动加载
 @param footerAction  上拉加载回调
 */
- (void)addFooterRefresh:(BOOL)automaticallyRefresh footerAction:(void(^)(NSInteger pageIndex))footerAction;

@end
