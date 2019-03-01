
#import "PopMenuModel.h"

@implementation PopMenuModel

-(id)init {
    if (self = [super init]) {
        self.projectName = @"";
        self.projectId = @-1;
    }
    return self;
}

-(void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"projectId"] || [key isEqualToString:@"id"]) {
        self.projectId = [value isKindOfClass:[NSNumber class]] ? value:@-1;
    }
    if ([key isEqualToString:@"projectName"] || [key isEqualToString:@"name"]) {
        self.projectName = [NSString stringWithFormat:@"%@",![value isKindOfClass:[NSNull class]] ? value:@""];
    }
}

@end
