//
//  UILabel+AddFontColor.m
//  Hoolink_IoT
//
//  Created by HL on 2018/6/12.
//  Copyright © 2018年 hoolink_IoT. All rights reserved.
//

#import "UILabel+HL.h"

@implementation UILabel (HL)

- (void)changeAttributedTitle:(NSString*)title
                    titleFont:(UIFont*)titleFont
                   titleColor:(UIColor*)titleColor
                     subtitle:(NSString*)subtitle
                 subtitleFont:(UIFont*)subtitleFont
                subtitleColor:(UIColor*)subtitleColor {
    NSString* price = title;
    NSString *text = [NSString stringWithFormat:@"%@%@", price, subtitle];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text];
    
    [attributedText addAttribute:NSFontAttributeName value:titleFont range:NSMakeRange(0, price.length)];
    [attributedText addAttribute:NSForegroundColorAttributeName value:titleColor range:NSMakeRange(0, price.length)];
    
    [attributedText addAttribute:NSFontAttributeName value:subtitleFont range:NSMakeRange(price.length, text.length - price.length)];
    [attributedText addAttribute:NSForegroundColorAttributeName value:subtitleColor range:NSMakeRange(price.length, text.length - price.length)];
    self.attributedText = attributedText;
}

- (void)addTextFont:(UIFont *)font textColor:(UIColor *)color {
    self.font = font;
    self.textColor = color;
}

- (void)addText:(NSString *)text {
    self.text = text;
}

- (void)addText:(NSString *)text textColor:(UIColor *)color {
    self.text = text;
    self.textColor = color;
}

- (void)addText:(NSString *)text font:(UIFont *)font {
    self.text = text;
    self.font = font;
}

- (void)addTextFont:(UIFont *)font textColor:(UIColor *)color text:(NSString *)text {
    self.font = font;
    self.textColor = color;
    self.text = text;
}

+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont *)font {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.text = title;
    label.font = font;
    label.numberOfLines = 0;
    [label sizeToFit];
    CGFloat height = label.frame.size.height;
    return height;
}

+ (CGFloat)getWidthWithTitle:(NSString *)title font:(UIFont *)font {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1000, 0)];
    label.text = title;
    label.font = font;
    [label sizeToFit];
    return label.frame.size.width;
}

///获取UILabel最大高度
+ (CGFloat)getMaxHeightFromConstWidth:(CGFloat)width
                        contentString:(NSString *)content
                             textFont:(UIFont *)font {
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSFontAttributeName] = font;
    CGSize labelSize = [content boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:attributes context:nil].size;
    CGFloat maxHeight = labelSize.height;
    return maxHeight;
}

+ (CGSize)layoutSizeFromConstWidth:(CGFloat)width
                     contentString:(NSString *)content
                          textFont:(UIFont *)font {
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSFontAttributeName] = font;
    CGSize labelSize = [content boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:attributes context:nil].size;
    return labelSize;
}

+ (CGFloat)getMaxWidthFromConstHeight:(CGFloat)height
                        contentString:(NSString *)content
                             textFont:(UIFont *)font {
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSFontAttributeName] = font;
    CGSize labelSize = [content boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:attributes context:nil].size;
    CGFloat maxWidth = labelSize.width;
    return maxWidth;
}


+(UILabel *)getLineSpaceLabelWithFrame:(CGRect)frame contentString:(NSString *)contentStr withFont:(UIFont *)font withLineSpace:(CGFloat)lineSpace textlengthSpace:(NSNumber *)textlengthSpace paragraphSpacing:(CGFloat)paragraphSpacing
{
    
    UILabel  *lab = [[UILabel alloc] init];
    lab.font = font;
    lab.textAlignment = NSTextAlignmentLeft;
    lab.numberOfLines = 0;
    NSDictionary *attributeDict  = [self setTextLineSpaceWithString:contentStr withFont:font withLineSpace:lineSpace  withTextlengthSpace:textlengthSpace paragraphSpacing:paragraphSpacing];
    
    CGSize size = [contentStr boundingRectWithSize:frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributeDict context:nil].size;
    CGFloat sizeHeight = size.height;
    
    lab.frame =  CGRectMake(frame.origin.x,frame.origin.y, frame.size.width, sizeHeight);
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:contentStr attributes:attributeDict];
    
    lab.attributedText = attributedString;
    return lab;
}

/*
 
 *给UILabel设置行间距和字间距
 
 */

+(NSDictionary *)setTextLineSpaceWithString:(NSString*)str
                                   withFont:(UIFont*)font
                              withLineSpace:(CGFloat)lineSpace
                        withTextlengthSpace:(NSNumber *)textlengthSpace
                           paragraphSpacing:(CGFloat)paragraphSpacing {
    
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    
    paraStyle.alignment = NSTextAlignmentLeft;
    
    paraStyle.lineSpacing = lineSpace;
    
    paraStyle.hyphenationFactor = 1.0;
    
    paraStyle.firstLineHeadIndent = 0.0;
    
    paraStyle.paragraphSpacingBefore = 0.0;
    
    paraStyle.headIndent = 0;
    
    paraStyle.tailIndent = 0;
    
    NSDictionary *dic = @{NSFontAttributeName:font,
                          
                          NSParagraphStyleAttributeName:paraStyle,
                          
                          NSKernAttributeName:textlengthSpace
                          
                          };
    
    return dic;
    
}

+ (CGFloat)getMaxHeightFromConstWidth:(CGFloat)width
                        contentString:(NSString *)content
                             textFont:(UIFont *)font
                            lineSpace:(CGFloat)lineSpace {

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.lineSpacing = lineSpace;
    paragraphStyle.hyphenationFactor = 1.0;
    paragraphStyle.firstLineHeadIndent = 0.0;
    paragraphStyle.paragraphSpacingBefore = 0.0;
    paragraphStyle.headIndent = 0;
    paragraphStyle.tailIndent = 0;
    
    CGSize labelSize = [content boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle}
                                             context:nil].size;
    CGFloat maxHeight = labelSize.height;
    return maxHeight;
}

///获取UILabel最大高度
+ (CGFloat)getMaxHeightFromConstWidth:(CGFloat)width
                        contentString:(NSString *)content
                             textFont:(UIFont *)font
                            lineSpace:(CGFloat)lineSpace
                                 kern:(NSNumber *)kern {
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.lineSpacing = lineSpace;
    paragraphStyle.hyphenationFactor = 1.0;
    paragraphStyle.firstLineHeadIndent = 0.0;
    paragraphStyle.paragraphSpacingBefore = 0.0;
    paragraphStyle.headIndent = 0;
    paragraphStyle.tailIndent = 0;
    
    
    //   NSParagraphStyleAttributeName 段落的风格（设置首行，行间距，对齐方式什么的）看自己需要什么属性，写什么
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.lineSpacing = 10;// 字体的行间距
//    paragraphStyle.firstLineHeadIndent = 20.0f;//首行缩进
//    paragraphStyle.alignment = NSTextAlignmentJustified;//（两端对齐的）文本对齐方式：（左，中，右，两端对齐，自然）
//    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;//结尾部分的内容以……方式省略 ( "...wxyz" ,"abcd..." ,"ab...yz")
//    paragraphStyle.headIndent = 20;//整体缩进(首行除外)
//    paragraphStyle.tailIndent = 20;//
//    paragraphStyle.minimumLineHeight = 10;//最低行高
//    paragraphStyle.maximumLineHeight = 20;//最大行高
//    paragraphStyle.paragraphSpacing = 15;//段与段之间的间距
//    paragraphStyle.paragraphSpacingBefore = 22.0f;//段首行空白空间/* Distance between the bottom of the previous paragraph (or the end of its paragraphSpacing, if any) and the top of this paragraph. */
//    paragraphStyle.baseWritingDirection = NSWritingDirectionLeftToRight;//从左到右的书写方向（一共➡️三种）
//    paragraphStyle.lineHeightMultiple = 15;/* Natural line height is multiplied by this factor (if positive) before being constrained by minimum and maximum line height. */
//    paragraphStyle.hyphenationFactor = 1;//连字属性 在iOS，唯一支持的值分别为0和1
    
    
    
    
    attributes[NSFontAttributeName] = font;
    attributes[NSParagraphStyleAttributeName] = paragraphStyle;
    attributes[NSKernAttributeName] = kern;
    
    CGSize labelSize = [content boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle}
                                             context:nil].size;
    CGFloat maxHeight = labelSize.height;
    return maxHeight;
}

@end
