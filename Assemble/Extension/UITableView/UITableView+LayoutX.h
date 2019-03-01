//
//  UITableView+LayoutX.h
//  Hoolink_IoT
//
//  Created by HL on 2018/7/2.
//  Copyright © 2018年 hoolink_IoT. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, UITableViewDirection){
    UITableViewDirectionNone,
    UITableViewDirectionUnData,
    UITableViewDirectionNetError,
    UITableViewDirectionUnPower
};

@protocol DefaultPageDelegate <NSObject>

- (void)reloadNetReqFromNetError;

@end

@interface UITableView ()
@property (nonatomic ) UITableViewDirection defaultPage;

@property (nonatomic, strong) UIView *footerView;

@property (nonatomic, weak) id<DefaultPageDelegate> reloadDelegate;

@end

@interface UITableView (LayoutX)

- (void)estimated_iPhone_X;
- (void)removeCellLine;

@end
