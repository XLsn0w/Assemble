
#import <Foundation/Foundation.h>

@interface NSArray (Bounds)
/**  数组类别，防止下标越界(越界时返回nil，需要单独处理) */
- (id)by_ObjectAtIndex:(NSUInteger)index;

@end
