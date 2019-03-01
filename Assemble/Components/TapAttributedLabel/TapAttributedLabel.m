//
//  CLLabel.m
//  coreTextClick
//
//  Created by zyyt on 17/1/10.
//  Copyright © 2017年 conglei. All rights reserved.
//

#import "TapAttributedLabel.h"
#import <CoreText/CoreText.h>
@interface TapAttributedLabel ()
{
    CTFrameRef _frame;
    NSInteger _length;
    NSMutableArray * arrText;
    BOOL isSelect;
    NSValue *_rectV;
}
@end
@implementation TapAttributedLabel
#pragma mark - 懒加载
- (void)setText:(NSString *)text{
    _text = text;
}
- (void)setTextColor:(UIColor *)textColor{
    _textColor = textColor;
}
- (void)setTouchBackColor:(UIColor *)touchBackColor{
    _touchBackColor = touchBackColor;
}
- (void)setTouchColor:(UIColor *)touchColor{
    _touchColor = touchColor;
}
- (void)setTouchString:(NSString *)touchString{
    _touchString = touchString;
}
- (void)willMoveToSuperview:(UIView *)newSuperview{
    if (!_textColor) {
        _textColor = [UIColor blackColor];

    }
    if (!_touchColor) {
        _touchColor = [UIColor colorWithRed:0.161 green:0.467 blue:0.988 alpha:1.000];

    }
    if (!_touchBackColor) {
        _touchBackColor = [UIColor colorWithRed:201/255.0 green:229/255.0 blue:242/255.0 alpha:1];
    }
    [self setNeedsDisplay];
}
-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    arrText = [NSMutableArray array];
    NSMutableAttributedString * attributeStr = [[NSMutableAttributedString alloc] initWithString:self.text];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:self.textColor range:NSMakeRange(0, attributeStr.length)];
    NSDictionary * activeAttr = @{NSForegroundColorAttributeName:self.touchColor,@"YJClickBTN":NSStringFromSelector(@selector(YJClickBTN))};
    NSRange range = [self.text rangeOfString:self.touchString];
    [attributeStr addAttributes:activeAttr range:range];
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributeStr);
    UIBezierPath * path = [UIBezierPath bezierPathWithRect:self.bounds];
    _length = attributeStr.length;
    _frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, _length), path.CGPath, NULL);
    [self handleActiveRectWithFrame:_frame];
    if (isSelect) {
        CGContextSaveGState(context);
        [self.touchBackColor setFill];
        CGRect selectedRect=[_rectV CGRectValue];
        CGContextFillRect(context, selectedRect);
        CGContextRestoreGState(context);
    }else{
        CGContextSaveGState(context);
        [[UIColor clearColor] setFill];
        CGRect selectedRect=[_rectV CGRectValue];
        CGContextFillRect(context, selectedRect);
        CGContextRestoreGState(context);
    }
    CTFrameDraw(_frame, context);
    CFRelease(_frame);
    CFRelease(frameSetter);
}
-(void)handleActiveRectWithFrame:(CTFrameRef)frame
{
    NSArray * arrLines = (NSArray *)CTFrameGetLines(frame);
    NSInteger count = [arrLines count];
    CGPoint points[count];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), points);
    for (int i = 0; i < count; i ++) {
        CTLineRef line = (__bridge CTLineRef)arrLines[i];
        NSArray * arrGlyphRun = (NSArray *)CTLineGetGlyphRuns(line);
        for (int j = 0; j < arrGlyphRun.count; j ++) {
            CTRunRef run = (__bridge CTRunRef)arrGlyphRun[j];
            NSDictionary * attributes = (NSDictionary *)CTRunGetAttributes(run);
            CGPoint point = points[i];
            NSString * string = attributes[@"YJClickBTN"];
            if (string) {
                [arrText addObject:[NSValue valueWithCGRect:[self getLocWithFrame:frame CTLine:line CTRun:run origin:point]]];
            }
            continue;
        }
    }
}

-(CGRect)getLocWithFrame:(CTFrameRef)frame CTLine:(CTLineRef)line CTRun:(CTRunRef)run origin:(CGPoint)origin
{
    CGFloat ascent;
    CGFloat descent;
    CGRect boundsRun;
    boundsRun.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL);
    boundsRun.size.height = ascent + descent;
    CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
    boundsRun.origin.x = origin.x + xOffset;
    boundsRun.origin.y = origin.y - descent;
    CGPathRef path = CTFrameGetPath(frame);
    CGRect colRect = CGPathGetBoundingBox(path);
    CGRect deleteBounds = CGRectOffset(boundsRun, colRect.origin.x, colRect.origin.y);
    return deleteBounds;
}

-(CGRect)convertRectFromLoc:(CGRect)rect
{
    return CGRectMake(rect.origin.x, self.bounds.size.height - rect.origin.y - rect.size.height, rect.size.width, rect.size.height);
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    [arrText enumerateObjectsUsingBlock:^(NSValue * rectV, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect textFrmToScreen = [self convertRectFromLoc:[rectV CGRectValue]];
        
        if (CGRectContainsPoint(textFrmToScreen, location)) {
            self->isSelect = YES;
            self->_rectV = rectV;
            [self setNeedsDisplay];
            [self YJClickBTN];
            *stop = YES;
        }
    }];
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t) (delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self->isSelect = NO;
        [self setNeedsDisplay];
    });
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    isSelect = NO;
    [self setNeedsDisplay];
}
-(void)YJClickBTN{
    if ([self.delegate respondsToSelector:@selector(tapAttributedProtocolToPushWebPage)]) {
        [self.delegate tapAttributedProtocolToPushWebPage];
    }
}


@end
