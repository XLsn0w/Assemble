//
//  BossSharePanel.h
//  GTSharePanel
//
//  Created by law on 2018/8/23.
//  Copyright © 2018年 Goldx4. All rights reserved.
//

#import <UIKit/UIKit.h>
#define device_iPhoneX         ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125.f, 2436.f), [[UIScreen mainScreen] currentMode].size) : NO)
#define kHomeIndicatorH (iPhoneX ? 34.f : 0)

/**
 *  rgb color
 */
#define rgb(r, g, b)    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

#import <Foundation/Foundation.h>

@protocol UmengShareViewDelegate <NSObject>

@required
- (void)shareFromBtnTag:(NSInteger)tag btnTitle:(NSString *)btnTitle;

@optional
- (void)sharePanelDidShow:(id)panel;
- (void)sharePanelDidDismiss:(id)panel;

@end

@interface UmengShareView : UIView

/// delegate
@property (nonatomic, weak) id<UmengShareViewDelegate> delegate;

- (void)show;
- (void)dismiss;

- (instancetype)initWithDelegate:(id<UmengShareViewDelegate>)delegate;

@end

