//
//  HTTPPresenter.m
//  TimeForest
//
//  Created by TimeForest on 2018/10/15.
//  Copyright © 2018年 TimeForest. All rights reserved.
//

#import "HTTPPresenter.h"

@implementation HTTPPresenter

- (void)GET:(NSString *)url params:(NSDictionary *)params {
    [HTTPSharedManager GET:url Parameters:params Success:^(id responseObject) {
        if ([self->_view respondsToSelector:@selector(HTTPSuccess:url:params:)]) {
            [self->_view HTTPSuccess:responseObject url:url params:params];
        }
    } Failure:^(NSError *error) {
        [self handleHTTPFailureWithError:error];
    }];
}

- (void)POST:(NSString *)url params:(NSDictionary *)params {
    [HTTPSharedManager POST:url Parameters:params Success:^(id responseObject) {
        if ([self->_view respondsToSelector:@selector(HTTPSuccess:url:params:)]) {
            [self->_view HTTPSuccess:responseObject url:url params:params];
        }
    } Failure:^(NSError *error) {
        [self handleHTTPFailureWithError:error];
    }];
}

- (void)handleHTTPFailureWithError:(NSError*)error {
    if ([self->_view respondsToSelector:@selector(HTTPFailureShowNullDataView)]) {
        [self->_view HTTPFailureShowNullDataView];
    }
}

- (void)HTTPSuccess:(NSDictionary *)JSONDictionary url:(NSString *)url params:(NSDictionary *)params {
    
}

- (void)HTTPFailureShowNullDataView {
    
}

@end
