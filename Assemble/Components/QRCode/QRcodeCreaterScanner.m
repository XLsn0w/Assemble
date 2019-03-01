//
//  HMScannerController.m
//  HMQRCodeScanner
//
//  Created by 刘凡 on 16/1/2.
//  Copyright © 2016年 itheima. All rights reserved.
//

#import "QRcodeCreaterScanner.h"
#import "HMScannerViewController.h"
#import "HMScanner.h"

@implementation QRcodeCreaterScanner

+ (void)QRcodeString:(NSString *)QRcodeString completion:(void (^)(UIImage *))completion {
    [HMScanner qrImageWithString:QRcodeString avatar:nil scale:1 completion:completion];
}

+ (void)cardImageWithCardName:(NSString *)cardName avatar:(UIImage *)avatar scale:(CGFloat)scale completion:(void (^)(UIImage *))completion {
    [HMScanner qrImageWithString:cardName avatar:avatar scale:scale completion:completion];
}

+ (instancetype)scannerWithCardName:(NSString *)cardName avatar:(UIImage *)avatar completion:(void (^)(NSString *))completion {
    NSAssert(completion != nil, @"必须传入完成回调");
    
    return [[self alloc] initWithCardName:cardName avatar:avatar completion:completion];
}

- (instancetype)initWithCardName:(NSString *)cardName avatar:(UIImage *)avatar completion:(void (^)(NSString *))completion {
    self = [super init];
    if (self) {
        HMScannerViewController *scanner = [[HMScannerViewController alloc] initWithCardName:cardName avatar:avatar completion:completion];
        
        [self setTitleColor:[UIColor whiteColor] tintColor:[UIColor greenColor]];
        
        [self pushViewController:scanner animated:NO];
    }
    return self;
}

- (void)setTitleColor:(UIColor *)titleColor tintColor:(UIColor *)tintColor {
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: titleColor}];
    self.navigationBar.tintColor = tintColor;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
