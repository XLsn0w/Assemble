
#import <UIKit/UIViewController.h>
#import <UIKit/UIScreen.h>
#import <UIKit/UIPageControl.h>
#import <UIKit/UIButton.h>
#import <UIKit/UICollectionViewFlowLayout.h>

@interface KSGuaidViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView* imageView;

@end

UIKIT_EXTERN NSString * const KSGuaidViewCellID;

@interface GuidePageViewController : UIViewController

@property (nonatomic, copy) dispatch_block_t willDismissHandler;

@end
