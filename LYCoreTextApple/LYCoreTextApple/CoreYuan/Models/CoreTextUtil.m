//
//  CoreTextUtil.m
//  LYCoreTextApple
//
//  Created by 9tong on 2020/1/17.
//  Copyright © 2020 LY. All rights reserved.
//

#import "CoreTextUtil.h"

@implementation CoreTextUtil
+(CFIndex)touchContentOffsetInView:(UIView *)view atPoint:(CGPoint)point data:(CoreTextData *)data {
    CTFrameRef frameRef = data.ctFrame;
    CFArrayRef lines = CTFrameGetLines(frameRef);
    if (!lines) {
        return -1;
    }
    CFIndex count = CFArrayGetCount(lines);
    
    // 获取每一行的origin
    CGPoint origins[count];
    CTFrameGetLineOrigins(frameRef, CFRangeMake(0, 0), origins);
    
    // 反转坐标系
    CGAffineTransform transform = CGAffineTransformMakeTranslation(0, view.bounds.size.height);
    transform = CGAffineTransformScale(transform, 1.0f, -1.0f);
    
    CFIndex idx = -1;
    
    for (int i = 0; i < count; i++) {
        CGPoint linePoint = origins[i];
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        // 获得每一行的CGRect信息
        CGRect flippedRect = [self getLineBounds:line point:linePoint];
        CGRect rect = CGRectApplyAffineTransform(flippedRect, transform);
        
        if (CGRectContainsPoint(rect, point)) {
            // 将点击的坐标转换成相对于当前行的坐标
            CGPoint relativePoint = CGPointMake(point.x - CGRectGetMinX(rect),
                                                point.y - CGRectGetMinY(rect));
            // 获得当前点击坐标对应的字符串偏移
            idx = CTLineGetStringIndexForPosition(line, relativePoint);
        }
    }
    return idx;
}

+ (CGRect)getLineBounds:(CTLineRef)line point: (CGPoint)point {
    CGFloat ascent = 0.0f;
    CGFloat descent = 0.0f;
    CGFloat leading = 0.0f;
    // 计算CTLine的bounds
    CGFloat width = (CGFloat)CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    CGFloat height = ascent + descent;
    
    return CGRectMake(point.x, point.y - descent, width, height);
}

@end
