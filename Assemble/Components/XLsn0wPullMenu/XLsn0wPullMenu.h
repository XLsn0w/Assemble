
#import <UIKit/UIKit.h>

@class XLsn0wPullMenu;

@protocol XLsn0wPullMenuDelegate <NSObject>

@optional

- (void)dropdownMenuWillShow:(XLsn0wPullMenu *)menu;    // 当下拉菜单将要显示时调用
- (void)dropdownMenuDidShow:(XLsn0wPullMenu *)menu;     // 当下拉菜单已经显示时调用
- (void)dropdownMenuWillHidden:(XLsn0wPullMenu *)menu;  // 当下拉菜单将要收起时调用
- (void)dropdownMenuDidHidden:(XLsn0wPullMenu *)menu;   // 当下拉菜单已经收起时调用

- (void)dropdownMenu:(XLsn0wPullMenu *)menu selectedCellNumber:(NSInteger)number selectedCellText:(NSString *)text isAdd:(BOOL)isAdd; // 当选择某个选项时调用

@end




@interface XLsn0wPullMenu : UIView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIButton * mainBtn;  // 主按钮 可以自定义样式 可在.m文件中修改默认的一些属性

@property (nonatomic, assign) id <XLsn0wPullMenuDelegate>delegate;


- (void)setMenuTitles:(NSArray *)titlesArr rowHeight:(CGFloat)rowHeight;  // 设置下拉菜单控件样式

- (void)show; // 显示下拉菜单
- (void)hide; // 隐藏下拉菜单

@end
