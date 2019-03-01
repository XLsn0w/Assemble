//
//  AppDelegate+LaunchAD.m
//  TimeForest
//
//  Created by TimeForest on 2018/9/29.
//  Copyright © 2018年 TimeForest. All rights reserved.
//

#import "AppDelegate+LaunchAD.h"
#import "LaunchADManager.h"
#import "AppDelegate+GuidePage.h"

@implementation AppDelegate (LaunchAD)

- (void)addLaunchAD {
    NSString *imageURL = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1538215715514&di=c4cc2b6731b661abe2c978b84d3ba341&imgtype=0&src=http%3A%2F%2Fb.zol-img.com.cn%2Fsjbizhi%2Fimages%2F8%2F1080x1920%2F1423039444126.jpg";
    if ([imageURL isEqualToString:@""] || imageURL.length == 0 || imageURL == nil) {

    } else {
        [LaunchADManager launchADWithFrame:[UIScreen mainScreen].bounds
                                aDduration:3.0
                                aDImageUrl:imageURL
                            hideSkipButton:NO
                        launchAdClickBlock:^{
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.baidu.com"]];
                        }];
    }
}

@end
