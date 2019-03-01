//
//  UITableViewCell+AddSeparatorLine.h
//  TimeForest
//
//  Created by TimeForest on 2018/12/6.
//  Copyright © 2018 TimeForest. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableViewCell (AddSeparatorLine)

@property (nonatomic, strong) UIView *line;
- (void)addLine;
- (void)removeLine;
- (void)remakeLineScreenWidth;
- (void)noneCellSelection;
- (void)addTopSeparatorLine;
- (void)addBottomSeparatorLine;

@end

NS_ASSUME_NONNULL_END
