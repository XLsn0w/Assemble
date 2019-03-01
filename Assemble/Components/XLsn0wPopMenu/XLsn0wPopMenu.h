#import <UIKit/UIKit.h>

@class PopMenuModel;

typedef void(^XLsn0wPopMenuBlock)(NSInteger selectedIndex, PopMenuModel *model);
typedef void(^XLsn0wPopMenuShowBlock)(BOOL isSelectRow);

@interface XLsn0wPopMenu : UIView

@property (nonatomic, copy) void(^hideHandle)(void);
@property (nonatomic, copy) XLsn0wPopMenuBlock action;
@property (nonatomic, copy) XLsn0wPopMenuShowBlock hideAction;
/**
 *  类方法展示
 *
 *  @param dataArray  PopMenuModel类型元素
 *  @param width  宽度
 *  @param point  三角的顶角坐标（基于window）
 *  @param action 点击回调
 */
+ (void)popWithDataArray:(NSArray<PopMenuModel *> *)dataArray
                width:(CGFloat)width
     triangleLocation:(CGPoint)point
               action:(XLsn0wPopMenuBlock)action;

- (instancetype)initWithItems:(NSArray *)array
                        width:(CGFloat)width
             triangleLocation:(CGPoint)point
                       action:(XLsn0wPopMenuBlock)action;

- (void)show;
- (void)hide;

@end
