

#import <Foundation/NSObject.h>
#import <UIKit/UIWindow.h>

#ifndef GuidePager
#define GuidePager [GuidePageManager manager]
#endif

#if DEBUG
#define KSLog(...) NSLog(__VA_ARGS__)
#else
#define KSLog(...)
#endif

@interface GuidePageManager : NSObject

@property (nonatomic, strong, readonly) UIWindow* window;

@property (nonatomic, strong ) NSArray<UIImage*>* images;

/**
 *Default is NO.
 */
@property (nonatomic, assign) BOOL shouldDismissWhenDragging;

@property (nonatomic, strong) UIImage* dismissButtonImage;

@property (nonatomic, assign) CGPoint dismissButtonCenter;

@property (nonatomic, strong) UIColor* pageIndicatorTintColor;

@property (nonatomic, strong) UIColor* currentPageIndicatorTintColor;

/**
 Default UIInterfaceOrientationMaskPortrait
 */
@property (nonatomic, assign) UIInterfaceOrientationMask supportedInterfaceOrientation;

+ (instancetype)manager;

- (void)begin;

@end
