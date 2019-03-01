
#import <Foundation/Foundation.h>

typedef void(^UploadSuccessBlock)(NSString *appendString);
typedef void(^UploadFailureBlock)(NSString *error);
           
@interface QiniuUpload : NSObject

+ (void)uploadImage:(UIImage*)image;

+ (void)uploadImages:(NSArray *)imageArray
             success:(UploadSuccessBlock)success
             failure:(UploadFailureBlock)failure;

@end
