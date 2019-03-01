//
//  CALayer+XibConfiguration.m
//  Hoolink_IoT
//
//  Created by hoolink on 2018/5/23.
//  Copyright © 2018年 hoolink_IoT. All rights reserved.
//

#import "CALayer+XibConfiguration.h"

@implementation CALayer (XibConfiguration)
-(void)setBorderUIColor:(UIColor*)color {
    self.borderColor = color.CGColor;
}

-(UIColor *)borderUIColor {
    return [UIColor colorWithCGColor:self.borderColor];
}

-(void)setShadowUIColor:(UIColor*)color {
    self.shadowColor = color.CGColor;
}

-(UIColor *)shadowUIColor {
    return [UIColor colorWithCGColor:self.shadowColor];
}
@end
