//
//  NSString+YCI.h
//  YCIVADemo
//
//  Created by yanchen on 16/6/21.
//  Copyright © 2016年 yanchen. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XLsn0wAppendString(firstStr,...) [NSString JoinedWithSubStrings:firstStr,__VA_ARGS__,nil]

#define AppendText(firstStr,...)         [NSString JoinedWithSubStrings:firstStr,__VA_ARGS__,nil]

@interface NSString (XLsn0wAppendString)

+ (NSString *)JoinedWithSubStrings:(NSString *)firstStr,...NS_REQUIRES_NIL_TERMINATION;

@end
