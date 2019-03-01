//
//  TapView.h
//  TimeForest
//
//  Created by TimeForest on 2018/10/30.
//  Copyright © 2018 TimeForest. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^TapViewAction)(void);

@interface TapView : UIImageView

@property (nonatomic, copy) TapViewAction tapViewAction;

- (void)clipRoundCornersFromView:(UIView*)view;

@end

NS_ASSUME_NONNULL_END
