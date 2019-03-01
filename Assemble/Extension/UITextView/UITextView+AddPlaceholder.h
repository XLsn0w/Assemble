//
//  UITextView+AddPlaceholder.h
//  Hoolink_IoT
//
//  Created by HL on 2018/6/12.
//  Copyright © 2018年 hoolink_IoT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (AddPlaceholder)

@property (nonatomic,strong) NSString *placeholder;//占位符
@property (copy, nonatomic) NSNumber *limitLength;//字数限制

@end
