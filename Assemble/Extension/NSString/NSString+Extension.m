
#import "NSString+Extension.h"

@implementation NSString (Extension)

- (CGSize)hl_sizeWithFont:(UIFont *)font
                maxHeight:(CGFloat)maxHeight {
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(MAXFLOAT, maxHeight);
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (CGSize)hl_sizeWithFont:(UIFont *)font
                 maxWidth:(CGFloat)maxWidth {
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxWidth, MAXFLOAT);
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

//字典转字符串
+ (NSString*)getStringFromDictionary:(NSDictionary *)dictionary {
    NSError *nilError = nil;
    NSData  *dictionaryData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&nilError];
    return [[NSString alloc] initWithData:dictionaryData encoding:NSUTF8StringEncoding];
}

- (NSAttributedString *)attributedTextFromFont:(UIFont *)font lineSpacing:(CGFloat)lineSpacing {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.lineSpacing = lineSpacing;
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:self attributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle}];
    return attributedText;
}

- (float)autoTextWidthForFontSize:(float)fontSize
                       textHeight:(float)textHeight {
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
    CGSize size = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, textHeight)
                                       options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                    attributes:attribute
                                       context:nil].size;
    return size.width;
}

@end
