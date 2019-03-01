//
//  UITableView+LayoutX.m
//  Hoolink_IoT
//
//  Created by HL on 2018/7/2.
//  Copyright © 2018年 hoolink_IoT. All rights reserved.
//

#import "UITableView+LayoutX.h"
#import <objc/runtime.h>

@implementation UITableView (LayoutX)

static char reloadDelegateKey;
- (id<DefaultPageDelegate>)reloadDelegate{
    return objc_getAssociatedObject(self, &reloadDelegateKey);
}

- (void)setReloadDelegate:(id<DefaultPageDelegate>)reloadDelegate {
    objc_setAssociatedObject(self, &reloadDelegateKey, reloadDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)estimated_iPhone_X {
    self.estimatedRowHeight = 0;
    self.estimatedSectionHeaderHeight = 0;
    self.estimatedSectionFooterHeight = 0;
}

- (void)removeCellLine {
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)configureHeaderImageName:(NSString *)imageName promptTitle:(NSString *)title type:(UITableViewDirection)type {
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    imageView.center = CGPointMake(self.width/2.0, (self.height -imageView.height-24)/2.0);
    UILabel *titleLabel = [UILabel new];

    titleLabel.frame = CGRectMake(0, imageView.bottom+10, self.width, 14);
//    titleLabel.textColor = HLMyHexRGB(0x999999);
    titleLabel.font = FFont_13;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = title;
    
    [footerView addSubview:imageView];
    [footerView addSubview:titleLabel];
    
    if (type == UITableViewDirectionNetError) {
        [self addTapGestureRecognizerInView:footerView];
    }
    self.tableFooterView = footerView;
}

- (void)addTapGestureRecognizerInView:(UIView*)view {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reloadNetReq:)];
    tap.numberOfTouchesRequired = 1; //手指数
    tap.numberOfTapsRequired = 1; //tap次数
    [view addGestureRecognizer:tap];
}

- (void)reloadNetReq:(UITapGestureRecognizer*)tap {
    [self.reloadDelegate reloadNetReqFromNetError];
}

- (void)dealloc {
    self.tableFooterView = nil;
}

-(void)setDefaultPage:(UITableViewDirection)defaultPage {
    switch (defaultPage) {
        case UITableViewDirectionNone:
            self.tableFooterView = [UIView new];
            break;
            
        case UITableViewDirectionUnData:
            [self configureHeaderImageName:@"UITableViewDirectionUnData" promptTitle:@"暂无数据" type:UITableViewDirectionUnData];
            break;
            
        case UITableViewDirectionNetError:
            [self configureHeaderImageName:@"UITableViewDirectionNetError" promptTitle:@"网络不太给力，点击重新加载" type:UITableViewDirectionNetError];
            break;
            
        case UITableViewDirectionUnPower:
            [self configureHeaderImageName:@"UITableViewDirectionUnPower" promptTitle:@"抱歉，您没有查看权限" type:UITableViewDirectionUnPower];
            break;
            
        default:
            break;
    }
}

@end
