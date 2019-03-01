//
//  KeywordsColor.h
//  KeywordsColorDemo
//
//  Created by liuyingjie on 2017/8/14.
//  Copyright © 2017年 liuyingjie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface AttributedColorString : NSObject

- (void)changeTitle:(NSString*)title
          titleFont:(UIFont*)titleFont
         titleColor:(UIColor*)titleColor
       subtitleFont:(UIFont*)subtitleFont
      subtitleColor:(UIColor*)subtitleColor
           subtitle:(NSString*)subtitle
              label:(UILabel*)label;

/**
 *  单纯改变一句话中的某些字的颜色（一种颜色）
 *
 *  @param color    需要改变成的颜色
 *  @param totalStr 总的字符串
 *  @param subArray 需要改变颜色的文字数组(要是有相同的 只取第一个)
 *
 *  @return 生成的富文本
 */
+ (NSMutableAttributedString *)ls_changeCorlorWithColor:(UIColor *)color TotalString:(NSString *)totalStr SubStringArray:(NSArray *)subArray;

@end
