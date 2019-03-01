//
//  UILabel+AddFontColor.h
//  Hoolink_IoT
//
//  Created by HL on 2018/6/12.
//  Copyright © 2018年 hoolink_IoT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (HL)

- (void)changeAttributedTitle:(NSString*)title
                    titleFont:(UIFont*)titleFont
                   titleColor:(UIColor*)titleColor
                     subtitle:(NSString*)subtitle
                 subtitleFont:(UIFont*)subtitleFont
                subtitleColor:(UIColor*)subtitleColor;

+ (CGFloat)getMaxHeightFromConstWidth:(CGFloat)width
                        contentString:(NSString *)content
                             textFont:(UIFont *)font
                            lineSpace:(CGFloat)lineSpace;

+ (CGFloat)getMaxHeightFromConstWidth:(CGFloat)width
                        contentString:(NSString *)content
                             textFont:(UIFont *)font
                            lineSpace:(CGFloat)lineSpace
                                 kern:(NSNumber *)kern;

- (void)addTextFont:(UIFont *)font textColor:(UIColor *)color;
- (void)addTextFont:(UIFont *)font textColor:(UIColor *)color text:(NSString *)text;
+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont*)font;
+ (CGFloat)getWidthWithTitle:(NSString *)title font:(UIFont *)font;

- (void)addText:(NSString *)text;
- (void)addText:(NSString *)text font:(UIFont *)font;
- (void)addText:(NSString *)text textColor:(UIColor *)color;
+ (CGFloat)getMaxHeightFromConstWidth:(CGFloat)width
                        contentString:(NSString *)content
                             textFont:(UIFont *)font;

+ (CGFloat)getMaxWidthFromConstHeight:(CGFloat)height
                        contentString:(NSString *)content
                             textFont:(UIFont *)font;

+ (CGSize)layoutSizeFromConstWidth:(CGFloat)width
                     contentString:(NSString *)content
                          textFont:(UIFont *)font;

/**
 一行代码设置label的高度自适应 和 行间距
 
 @param frame            label的frame (高度传入 0 或者其他)
 @param contentStr       文本内容
 @param font             字体
 @param lineSpace        行间距
 @param textlengthSpace  字间距
 @param paragraphSpacing 段间距
 
 @return 返回UILabel
 */
+(UILabel *)getLineSpaceLabelWithFrame:(CGRect )frame
                         contentString:(NSString*)contentStr
                              withFont:(UIFont*)font
                         withLineSpace:(CGFloat)lineSpace
                       textlengthSpace:(NSNumber* )textlengthSpace
                      paragraphSpacing:(CGFloat)paragraphSpacing;

@end
