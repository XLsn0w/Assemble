
#import "NSArray+Bounds.h"

@implementation NSArray (Bounds)

- (id)by_ObjectAtIndex:(NSUInteger)index {
    if (self.count > index) {
        return [self objectAtIndex:index];
    } else {
        return nil;
    }
}
@end
