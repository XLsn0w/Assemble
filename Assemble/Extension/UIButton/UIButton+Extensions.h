//
//  UIButton+Extensions.h
//  TimeForest
//
//  Created by TimeForest on 2018/10/10.
//  Copyright © 2018年 TimeForest. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    ButtonImgViewStyleTop,
    ButtonImgViewStyleLeft,
    ButtonImgViewStyleBottom,
    ButtonImgViewStyleRight,
} ButtonImgViewStyle;

typedef NS_ENUM(NSUInteger, ImagePositionType) {
    ImagePositionLeft,
    ImagePositionRight,
    ImagePositionTop,
    ImagePositionBottom
};

typedef void(^SGCountdownCompletionBlock)(void);

@interface UIButton (Extensions)

/**
 * 设置 按钮 图片所在的位置
 * style   图片位置类型（上、左、下、右）
 * size    图片的大小
 * space 图片跟文字间的间距
 */

- (void)setImgViewStyle:(ButtonImgViewStyle)style
              imageSize:(CGSize)size
                  space:(CGFloat)space;

- (void)setImagePosition:(ImagePositionType)position
                   space:(CGFloat)space;

/** 倒计时，s倒计,带有回调 */
- (void)countdownWithSec:(NSInteger)sec completion:(SGCountdownCompletionBlock)block;
/** 倒计时,秒字倒计，带有回调 */
- (void)countdownWithSecond:(NSInteger)second completion:(SGCountdownCompletionBlock)block;

@end

NS_ASSUME_NONNULL_END
