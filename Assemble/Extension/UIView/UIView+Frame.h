
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    TZOscillatoryAnimationToBigger,
    TZOscillatoryAnimationToSmaller,
} TZOscillatoryAnimationType;

@interface UIView (Frame)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGSize size;
//获取当前view所在的contronller
-(UIViewController *)viewController;

+ (void)showOscillatoryAnimationWithLayer:(CALayer *)layer type:(TZOscillatoryAnimationType)type;

//放大不收回两者结合使用
+ (void)showOnlyBigOscillatoryAnimationWithLayer:(CALayer *)layer;
+ (void)showOnlyRestoreOscillatoryAnimationWithLayer:(CALayer *)layer;

- (void)addShadow;
- (void)addShadowForRadius:(CGFloat)radius
             shadowOpacity:(CGFloat)shadowOpacity
              shadowOffset:(CGSize)shadowOffset
               shadowColor:(UIColor*)shadowColor;

@end
