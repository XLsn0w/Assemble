//
//  NSString+YCI.m
//  YCIVADemo
//
//  Created by yanchen on 16/6/21.
//  Copyright © 2016年 yanchen. All rights reserved.
//

#import "NSString+XLsn0wAppendString.h"

@implementation NSString (XLsn0wAppendString)

+ (NSString *)JoinedWithSubStrings:(NSString *)firstStr,...NS_REQUIRES_NIL_TERMINATION{
    
    NSMutableArray *array = [NSMutableArray new];
    
    va_list args;
    
    if(firstStr){
        
        [array addObject:firstStr];
        
        va_start(args, firstStr);
        
        id obj;
        
        while ((obj = va_arg(args, NSString* ))) {
            [array addObject:obj];
        }
        
        va_end(args);
    }
    
    
    return [array componentsJoinedByString:@""];
    
}

@end
