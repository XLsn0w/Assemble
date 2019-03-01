//
//  AppDelegate+GuidePage.m
//  TimeForest
//
//  Created by TimeForest on 2018/9/29.
//  Copyright © 2018年 TimeForest. All rights reserved.
//

#import "AppDelegate+GuidePage.h"
#import "GuidePageManager.h"

@implementation AppDelegate (GuidePage)

- (void)addGuidePage {
    GuidePager.images = @[[UIImage imageNamed:@"1.jpg"],
                              [UIImage imageNamed:@"2.jpg"],
                              [UIImage imageNamed:@"0.jpg"],
                              ];
    

//     CGSize size = [UIScreen mainScreen].bounds.size;
//     
//     GuidePager.dismissButtonImage = [UIImage imageNamed:@"dismissButtonImage"];
//     
////     GuidePager.dismissButtonCenter = CGPointMake(size.width / 2, size.height - 80);
//  
    
    //方式二:
//    GuidePager.shouldDismissWhenDragging = YES;
    
    [GuidePager begin];
}

@end
