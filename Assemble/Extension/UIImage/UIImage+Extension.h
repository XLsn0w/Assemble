
#import <UIKit/UIKit.h>

@interface UIImage (Extension)
/*
*  返回一张自由拉伸的图片
*/
+ (UIImage *)resizedImageWithName:(NSString *)name;

//颜色转换成图片
+ (UIImage *)xlsn0w_imageWithColor:(UIColor *)color;
/* 图片压缩到指定大小
 * image 要压缩的图片
 * apSize 压缩的制定尺寸 如：CGSizeMake(1440, 1080)
 *
 */
+(UIImage*)imageByScalingAndCroppingForSize:(UIImage *)image appointSize:(CGSize )apSize;

- (UIImage*)TransformtoSize:(CGSize)size;

+ (UIImage *)imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size;

@end
