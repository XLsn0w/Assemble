
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Extension)

- (CGSize)hl_sizeWithFont:(UIFont *)font
                maxHeight:(CGFloat)maxHeight;

- (CGSize)hl_sizeWithFont:(UIFont *)font
                 maxWidth:(CGFloat)maxWidth;

+ (NSString*)getStringFromDictionary:(NSDictionary *)dictionary;

- (NSAttributedString *)attributedTextFromFont:(UIFont *)font lineSpacing:(CGFloat)lineSpacing;


- (float)autoTextWidthForFontSize:(float)fontSize
                       textHeight:(float)textHeight;

@end
