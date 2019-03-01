//
//  UIImageView+WebImage.h
//  TimeForest
//
//  Created by TimeForest on 2018/10/24.
//  Copyright © 2018 TimeForest. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (WebImage)

- (void)setImageFromURLString:(NSString *)url
         placeholderImageName:(NSString *)placeholderImageName;

- (void)setImageFromURLString:(NSString *)url;

- (void)centerClip;

@end

NS_ASSUME_NONNULL_END
