//
//  BaseView.h
//  TimeForest
//
//  Created by TimeForest on 2018/9/28.
//  Copyright © 2018年 TimeForest. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BaseViewRefreshDelegate <NSObject>

@optional
- (void)addHeaderRefresh;
- (void)addFooterRefreshFromIndex:(NSInteger)index;

@end

@interface BaseView : UIView

@property (nonatomic, weak, nullable) id <BaseViewRefreshDelegate> delegate;

@property (nonatomic, assign) float topHeight;

- (UINavigationController*)currentNav;

- (void)loadDataFromModelArray:(NSMutableArray*)modelArray;
- (void)loadDataFromModel:(id)model;
- (void)loadDataFromDictionary:(NSDictionary*)dictionary;
- (void)loadDataFromArray:(NSArray*)array;
- (void)loadDataFromString:(NSString*)string;
- (void)showErrorView;
- (void)call;

- (UIViewController *)getCurrentVCWithCurrentView:(UIView *)currentView;

- (void)drawSubviews;
- (void)clipRoundCornersFromView:(UIView*)view;

@end

NS_ASSUME_NONNULL_END
