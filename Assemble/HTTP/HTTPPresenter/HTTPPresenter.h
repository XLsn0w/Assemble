//
//  HTTPPresenter.h
//  TimeForest
//
//  Created by TimeForest on 2018/10/15.
//  Copyright © 2018年 TimeForest. All rights reserved.
//

#import "BasePresenter.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTTPPresenter : BasePresenter <HTTPViewProtocol>

- (void)GET:(NSString *)url params:(NSDictionary *)params;
- (void)POST:(NSString *)url params:(NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
