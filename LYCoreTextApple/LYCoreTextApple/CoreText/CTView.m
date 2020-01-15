//
//  CTView.m
//  HQPLabelTest
//
//  Created by 9tong on 2020/1/15.
//  Copyright © 2020 hqp. All rights reserved.
//

#import "CTView.h"
#import <CoreText/CoreText.h>

@implementation CTView

/*
 1,反转坐标系
 2,创建NSMutableAttributeString
 3,通过NSMutableAttributeString 获取CTFrameSetter: CTFramesetterCreateWithAttributedString()
 4,通过CTFrameSetter获取CTFrame: CTFramesetterCreateFrame
 5,CTFrameDraw()
 */

-(void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    // Flip the context coordinated, in ios only
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    
    // 创建 绘制的区域
    CGMutablePathRef path = CGPathCreateMutable();
    CGRect bounds = CGRectMake(10.0, 10.0, 200.0, 200.0);
    CGPathAddRect(path, NULL, bounds);
    
    // 创建NSMutableString
    CFStringRef textString = CFSTR("Hello, World! I know nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine.");
    
    CFMutableAttributedStringRef attrString = CFAttributedStringCreateMutable(kCFAllocatorDefault, 0);
    // 将 textString 复制到 attrString中
    CFAttributedStringReplaceString(attrString, CFRangeMake(0, 0), textString);
    
    // 创建Color
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat components[] = {1.0,0.0,0.0,0.8};
    CGColorRef red = CGColorCreate(rgbColorSpace, components);
    CGColorSpaceRelease(rgbColorSpace);
    
    // 设置前12位的颜色
    CFAttributedStringSetAttribute(attrString, CFRangeMake(0, 12), kCTForegroundColorAttributeName, red);
    
    
    
    // 使用attrString 创建 framesetter
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(attrString);
    CFRelease(attrString);
    
    // 创建ctframe
    CTFrameRef ctframe = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    // 在当前context 绘制ctframe
    CTFrameDraw(ctframe, context);
    
    
    CFRelease(ctframe);
    CFRelease(path);
    CFRelease(framesetter);
    
}

@end
