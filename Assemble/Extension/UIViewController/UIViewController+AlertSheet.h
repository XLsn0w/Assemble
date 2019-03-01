///系统版本号
#define kSystemVersion ([[UIDevice currentDevice].systemVersion floatValue])
#define kSystemVersion_iOS8_Later (kSystemVersion >= 8.0)

#import <UIKit/UIKit.h>
#define NO_USE -1000

typedef void(^click)(NSInteger index);
typedef void(^configuration)(UITextField *field, NSInteger index);
typedef void(^clickHaveField)(NSArray<UITextField *> *fields, NSInteger index);

@interface UIViewController (AlertSheet)

#ifdef kSystemVersion_iOS8_Later

#else

<UIAlertViewDelegate, UIActionSheetDelegate>

#endif

- (void)pushAlertWithTitle:(NSString *)title
                   message:(NSString *)message
                   buttons:(NSArray<NSString *> *)buttons
                  animated:(BOOL)animated
                    action:(click)click;

- (void)pushAlertWithTitle:(NSString *)title
                   message:(NSString *)message
                   buttons:(NSArray<NSString *> *)buttons
           textFieldCount:(NSInteger )count
             configuration:(configuration )configuration
                  animated:(BOOL )animated
                    action:(clickHaveField )click;

- (void)pushSheetWithTitle:(NSString *)title
                   message:(NSString *)message
                  subtitle:(NSString *)subtitle
            subtitleAction:(click)subtitleAction
                   buttons:(NSArray<NSString *> *)buttons
                  animated:(BOOL)animated
                    action:(click)click;

@end
