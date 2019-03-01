
#import <UIKit/UIKit.h>

typedef void(^BaseTableViewNullButtonAction)(void);

@interface BaseTableView : UITableView <UIGestureRecognizerDelegate>

@property (nonatomic, copy) BaseTableViewNullButtonAction nullButtonAction;

//无数据时的高度,默认20(因为我们有可能会加footerView和headerView,这个时候无数据的高度就不为0了)
//row 的高度一般不会小于30,所以选了个折中的高度20；如果无数据时的高度大于20,可以在初始化后重新设置这个高度
@property (nonatomic, assign) CGFloat      nullHeight;
@property (nonatomic, strong) UIImageView* nullImageView;
@property (nonatomic, strong) UILabel*     nullLabel;
@property (nonatomic, strong) UIButton*    nullButton;

@property (nonatomic, assign) BOOL isNull;
@property (nonatomic, assign) BOOL isShowNullButton;

@end

