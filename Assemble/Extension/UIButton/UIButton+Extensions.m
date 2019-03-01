
//
//  UIButton+Extensions.m
//  TimeForest
//
//  Created by TimeForest on 2018/10/10.
//  Copyright © 2018年 TimeForest. All rights reserved.
//

#import "UIButton+Extensions.h"
#import <objc/runtime.h>

static const char Btn_ImgViewStyle_Key;
static const char Btn_ImgSize_key;
static const char Btn_ImgSpace_key;


@implementation UIButton (Extensions)

- (void)setImgViewStyle:(ButtonImgViewStyle)style imageSize:(CGSize)size space:(CGFloat)space
{
    objc_setAssociatedObject(self, &Btn_ImgViewStyle_Key, @(style), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &Btn_ImgSpace_key, @(space), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &Btn_ImgSize_key, NSStringFromCGSize(size), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

+ (void)load
{
    Method method1 = class_getInstanceMethod([self class], @selector(layoutSubviews));
    Method method2 = class_getInstanceMethod([self class], @selector(layoutSubviews1));
    method_exchangeImplementations(method1, method2);
}

- (void)layoutSubviews1 {
    [self layoutSubviews1];
    NSNumber *typeNum = objc_getAssociatedObject(self, &Btn_ImgViewStyle_Key);
    if (typeNum) {
        NSNumber *spaceNum = objc_getAssociatedObject(self, &Btn_ImgSpace_key);
        NSString *imgSizeStr = objc_getAssociatedObject(self, &Btn_ImgSize_key);
        CGSize imgSize = self.currentImage ? CGSizeFromString(imgSizeStr) : CGSizeZero;
        CGSize labelSize = self.currentTitle.length ? [self.currentTitle sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}] : CGSizeZero;
        CGFloat space = (labelSize.width && self.currentImage) ? spaceNum.floatValue : 0;
        CGFloat width = self.frame.size.width;
        CGFloat height = self.frame.size.height;
        CGFloat imgX = 0.0, imgY = 0.0, labelX = 0.0, labelY = 0.0;
        switch (typeNum.integerValue) {
            case ButtonImgViewStyleLeft: {
                imgX = (width - imgSize.width - labelSize.width - space)/2.0;
                imgY = (height - imgSize.height)/2.0;
                labelX = imgX + imgSize.width + space;
                labelY = (height - labelSize.height)/2.0;
                self.imageView.contentMode = UIViewContentModeRight;
                break;
            }
            case ButtonImgViewStyleTop: {
                imgX = (width - imgSize.width)/2.0;
                imgY = (height - imgSize.height - space - labelSize.height)/2.0;
                labelX = (width - labelSize.width)/2;
                labelY = imgY + imgSize.height + space;
                self.imageView.contentMode = UIViewContentModeBottom;
                break;
            }
            case ButtonImgViewStyleRight: {
                labelX = (width - imgSize.width - labelSize.width - space)/2.0;
                labelY = (height - labelSize.height)/2.0;
                imgX = labelX + labelSize.width + space;
                imgY = (height - imgSize.height)/2.0;
                self.imageView.contentMode = UIViewContentModeLeft;
                break;
            }
            case ButtonImgViewStyleBottom: {
                labelX = (width - labelSize.width)/2.0;
                labelY = (height - labelSize.height - imgSize.height -space)/2.0;
                imgX = (width - imgSize.width)/2.0;
                imgY = labelY + labelSize.height + space;
                self.imageView.contentMode = UIViewContentModeTop;
                break;
            }
            default:
                break;
        }
        self.imageView.frame = CGRectMake(imgX, imgY, imgSize.width, imgSize.height);
        self.titleLabel.frame = CGRectMake(labelX, labelY, labelSize.width, labelSize.height);
    }
}

- (void)setImagePosition:(ImagePositionType)position
                   space:(CGFloat)space {
    
    CGFloat imageWidth  = self.imageView.image.size.width;
    CGFloat imageHeight = self.imageView.image.size.height;
    CGFloat titleWidth  = self.titleLabel.frame.size.width;
    CGFloat titleHeight = self.titleLabel.frame.size.height;
    
    if(position == ImagePositionLeft){
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0)];
        [self setImageEdgeInsets:UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0)];
    } else if(position == ImagePositionRight){
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -(imageWidth+space/2.0), 0, imageWidth+space/2.0)];
        [self setImageEdgeInsets:UIEdgeInsetsMake(0, titleWidth+space/2.0, 0, -(titleWidth+space/2.0))];
    } else if(position == ImagePositionTop){
        [self setTitleEdgeInsets:UIEdgeInsetsMake(imageHeight/2.0+space/2.0, -imageWidth/2.0, -imageHeight/2.0-space/2.0, imageWidth/2.0)];
        [self setImageEdgeInsets:UIEdgeInsetsMake(-titleHeight/2.0-space/2.0  , titleWidth/2.0, titleHeight/2.0+space/2.0, -titleWidth/2.0)];
    } else if(position == ImagePositionBottom){
        [self setTitleEdgeInsets:UIEdgeInsetsMake(-imageHeight/2.0-space/2.0, -imageWidth/2.0, imageHeight/2.0+space/2.0, imageWidth/2.0)];
        [self setImageEdgeInsets:UIEdgeInsetsMake(titleHeight/2.0+space/2.0  , titleWidth/2.0, -titleHeight/2.0-space/2.0, -titleWidth/2.0)];
    }
}

/** 倒计时，s倒计,带有回调 */
- (void)countdownWithSec:(NSInteger)sec completion:(SGCountdownCompletionBlock)block {
    __block NSInteger tempSecond = sec;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timer, ^{
        if (tempSecond <= 1) {
            dispatch_source_cancel(timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.enabled = YES;
                block();
            });
        } else {
            tempSecond--;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.enabled = NO;
                [self setTitle:[NSString stringWithFormat:@"%lds", (long)tempSecond] forState:UIControlStateNormal];
            });
        }
    });
    dispatch_resume(timer);
}

/** 倒计时,秒字倒计，带有回调 */
- (void)countdownWithSecond:(NSInteger)second completion:(SGCountdownCompletionBlock)block {
    __block NSInteger tempSecond = second;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timer, ^{
        if (tempSecond <= 1) {
            dispatch_source_cancel(timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.enabled = YES;
                block();
            });
        } else {
            tempSecond--;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.enabled = NO;
                [self setTitle:[NSString stringWithFormat:@"%ld秒", (long)tempSecond] forState:UIControlStateNormal];
            });
        }
    });
    dispatch_resume(timer);
}


@end
