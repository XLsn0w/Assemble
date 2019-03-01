//
//  MethodGetName.m
//  Hoolink_IoT
//
//  Created by HL on 2018/7/3.
//  Copyright © 2018年 hoolink_IoT. All rights reserved.
//

#import "MethodGetName.h"
#import <objc/runtime.h>

@implementation MethodGetName

void DumpObjcMethods(Class currentClass) {
    unsigned int methodCount = 0;
    Method *methods = class_copyMethodList(currentClass, &methodCount);
    printf("类名: %s 有%d个方法如下: \n\n", class_getName(currentClass), methodCount);
    
    for (int i = 0; i < methodCount; i++) {
        Method method = methods[i];
        
        printf("方法名: '%s'\n", sel_getName(method_getName(method)));
        if (i == methodCount-1) {
            printf("\n");
        }
        ///从Objective-c的runtime 特性可以知道，所有运行时方法都依赖TypeEncoding，也就是method_getTypeEncoding返回的结果，他指定了方法的参数类型以及在函数调用时参数入栈所要的内存空间，没有这个标识就无法动态的压入参数
        ////（比如: Optional("v24@0:8@16") Optional("v")，表示此方法参数共需24个字节，返回值为void，第一个参数为id，第二个为selector，第三个为id）
//       HLLog(@"method_getTypeEncoding=== %s", method_getTypeEncoding(method));
    }
    free(methods);
}

+ (void)printf_method_getName_currentClass:(Class)currentClass {
    DumpObjcMethods(currentClass);
    
//    XLsn0wLog.
}

@end
