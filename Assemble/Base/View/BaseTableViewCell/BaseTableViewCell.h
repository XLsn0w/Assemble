//
//  BaseTableViewCell.h
//  TimeForest
//
//  Created by TimeForest on 2018/10/8.
//  Copyright © 2018年 TimeForest. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseTableViewCell : UITableViewCell

- (void)addData:(id)model;
- (void)clipRoundCornersFromView:(UIView*)view;
- (void)addDataFromModel:(id)model;
- (void)clipRoundCornersFromViewBottomLeft:(UIView*)view;

@end

NS_ASSUME_NONNULL_END
