//
//  KeywordsColor.m
//  KeywordsColorDemo
//
//  Created by liuyingjie on 2017/8/14.
//  Copyright © 2017年 liuyingjie. All rights reserved.
//

#import "AttributedColorString.h"

@implementation AttributedColorString

- (void)changeTitle:(NSString*)title
          titleFont:(UIFont*)titleFont
         titleColor:(UIColor*)titleColor
       subtitleFont:(UIFont*)subtitleFont
      subtitleColor:(UIColor*)subtitleColor
           subtitle:(NSString*)subtitle
              label:(UILabel*)label {
    NSString* price = title;
    NSString *text = [NSString stringWithFormat:@"%@%@", price, subtitle];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text];
    
    [attributedText addAttribute:NSFontAttributeName value:titleFont range:NSMakeRange(0, price.length)];
    [attributedText addAttribute:NSForegroundColorAttributeName value:titleColor range:NSMakeRange(0, price.length)];
    
    [attributedText addAttribute:NSFontAttributeName value:subtitleFont range:NSMakeRange(price.length, text.length - price.length)];
    [attributedText addAttribute:NSForegroundColorAttributeName value:subtitleColor range:NSMakeRange(price.length, text.length - price.length)];
    label.attributedText = attributedText;
}

#pragma mark - 富文本操作

/**
 *  单纯改变一句话中的某些字的颜色
 *
 *  @param color    需要改变成的颜色
 *  @param totalStr 总的字符串
 *  @param subArray 需要改变颜色的文字数组
 *
 *  @return 生成的富文本
 */
+ (NSMutableAttributedString *)ls_changeCorlorWithColor:(UIColor *)color TotalString:(NSString *)totalStr SubStringArray:(NSArray *)subArray {
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:totalStr];
    for (NSString *rangeStr in subArray) {
        
        NSMutableArray *array = [self ls_getRangeWithTotalString:totalStr SubString:rangeStr];
        
        for (NSNumber *rangeNum in array) {
            
            NSRange range = [rangeNum rangeValue];
            [attributedStr addAttribute:NSForegroundColorAttributeName value:color range:range];
        }
    }
    
    return attributedStr;
}

#pragma mark - 获取某个子字符串在某个总字符串中位置数组
/**
 *  获取某个字符串中子字符串的位置数组
 *
 *  @param totalString 总的字符串
 *  @param subString   子字符串
 *
 *  @return 位置数组
 */
+ (NSMutableArray *)ls_getRangeWithTotalString:(NSString *)totalString SubString:(NSString *)subString {
    
    NSMutableArray *arrayRanges = [NSMutableArray array];
    
    if (subString == nil && [subString isEqualToString:@""]) {
        return nil;
    }
    
    NSRange rang = [totalString rangeOfString:subString];
    
    if (rang.location != NSNotFound && rang.length != 0) {
        
        [arrayRanges addObject:[NSNumber valueWithRange:rang]];
        
        NSRange   rang1 = {0,0};
        NSInteger location = 0;
        NSInteger   length = 0;
        
        for (int i = 0;; i++) {
            
            if (0 == i) {
                
                location = rang.location + rang.length;
                length = totalString.length - rang.location - rang.length;
                rang1 = NSMakeRange(location, length);
            } else {
                
                location = rang1.location + rang1.length;
                length = totalString.length - rang1.location - rang1.length;
                rang1 = NSMakeRange(location, length);
            }
            
            rang1 = [totalString rangeOfString:subString options:NSCaseInsensitiveSearch range:rang1];
            
            if (rang1.location == NSNotFound && rang1.length == 0) {
                
                break;
            } else {
                
                [arrayRanges addObject:[NSNumber valueWithRange:rang1]];
            }
        }
        
        return arrayRanges;
    }
    
    return nil;
}


@end
