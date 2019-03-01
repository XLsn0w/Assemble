
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RouterError : NSObject

+ (instancetype)shared;
- (UIViewController *)getErrorController;

@end
