
#import "CreateImageTool.h"

@implementation CreateImageTool

+ (UIImage*)createImageWithColor:(UIColor *) color andSize:(CGSize)imageSize {
    UIGraphicsBeginImageContext(imageSize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *getImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return getImage;
}

@end
