//
//  HLTransition.h
//  Hoolink_IoT
//
//  Created by hoolink on 2018/5/16.
//  Copyright © 2018年 hoolink_IoT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HLTransition : NSObject<UIViewControllerAnimatedTransitioning>

@property(nonatomic,assign) BOOL isPush;//是否是push，反之则是pop
@property (nonatomic, assign) NSTimeInterval animationDuration;//动画时长

@end
