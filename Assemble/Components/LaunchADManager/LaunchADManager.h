///启动时广告位

#import <UIKit/UIKit.h>

#define DDScreenW [UIScreen mainScreen].bounds.size.width
#define DDScreenH [UIScreen mainScreen].bounds.size.height
typedef void(^DDLaunchAdClickBlock)(void);

@interface LaunchADManager : UIView
@property (nonatomic, copy) DDLaunchAdClickBlock launchAdClickBlock;/**< 广告点击事件的回调 */
/**
 *  DHLaunchAdPageHUD
 *
 *  @param frame        位置大小
 *  @param duration     广告停留的时间
 *  @param imageUrl     显示广告的图片(这里可以使用本地图片也可以使用网络图片,使用时只传入URL即可,SDK会自动是识别png\jpg\gif的图片)
 *  @param hideSkip     是否隐藏跳过按钮(YES:隐藏; NO不隐藏)
 *  @param aDClickBlock 用户点击广告图片的回调Block
 *
 *  @return 对象
 */
+ (void)launchADWithFrame:(CGRect)frame aDduration:(NSInteger)duration aDImageUrl:(NSString *)imageUrl hideSkipButton:(BOOL)hideSkip launchAdClickBlock:(DDLaunchAdClickBlock)aDClickBlock;
@end
