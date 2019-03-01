//  其他分享方法配置 参考: https://developer.umeng.com/docs/66632/detail/66825

#import <Foundation/Foundation.h>
#import <UMShare/UMShare.h>
#import <UShareUI/UShareUI.h>

#define UmengSharedManager [UmengManager shared]

typedef NS_ENUM(NSUInteger, SocialType) {
	SType_sina_wx_qq,
    SType_wx,
	SType_all
};
typedef NS_ENUM(NSUInteger, ShareType) {
	ShareText,
	SharePictures,
	SharePicturesAndText_sina,
	ShareWebPages,
	ShareMusic,
	ShareVideo,
	ShareWeChatExpression,
	ShareWeChatPrograms
};
@interface UmengManager : NSObject

+ (instancetype)shared;

- (void)shareWebToPlatform:(UMSocialPlatformType)platformType
                     title:(NSString*)title
                     descr:(NSString*)descr
              thumImageUrl:(NSString*)thumImageUrl
                webpageUrl:(NSString*)webpageUrl
                        vc:(UIViewController*)vc;

@end
