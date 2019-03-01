
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Size)

+ (CGSize)sizeWithText:(NSString *)text
                  font:(UIFont *)font
               maxSize:(CGSize)maxSize;

- (CGSize)sizeWithFont:(UIFont *)font
               maxSize:(CGSize)maxSize;

@end
