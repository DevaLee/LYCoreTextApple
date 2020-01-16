//
//  CTNonrectangularView.m
//  LYCoreTextApple
//
//  Created by 9tong on 2020/1/16.
//  Copyright © 2020 LY. All rights reserved.
//

#import "CTNonrectangularView.h"
#import <CoreText/CoreText.h>
/*
 不规则区域
 
 
 
 CTFrameSetter -> CTFrame -> CTFrameDraw
 */
@implementation CTNonrectangularView

-(void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    // flip coordinate
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    // set text matrix
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    
//    CFStringRef textString = CFSTR("Hello, World! I know nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine.");
    // 创建NSMutableAttributeString
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"Hello, World! I know nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine."];
    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 13)];
    
    // 创建 framesetter
    CTFramesetterRef ctFrameSetter =  CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attrString);
    
    // 创建path
    NSArray *paths = [self paths];
    
    CFIndex startIndex = 0;
    
#define GREEN_COLOR [UIColor greenColor]
#define YELLOW_COLOR [UIColor yellowColor]
#define BLACK_COLOR [UIColor blackColor]
    for (id object in paths) {
        CGPathRef path = (__bridge CGPathRef)object;
        // 设置背景色
        CGContextSetFillColorWithColor(context, YELLOW_COLOR.CGColor);
        
        CGContextAddPath(context, path);
        CGContextFillPath(context);
        
        CGContextDrawPath(context, kCGPathStroke);
        
        CTFrameRef ctFrame = CTFramesetterCreateFrame(ctFrameSetter, CFRangeMake(startIndex, 0), path, NULL);
        CTFrameDraw(ctFrame, context);
        
        CFRange fromRange = CTFrameGetStringRange(ctFrame);
        startIndex += fromRange.length;
        CFRelease(ctFrame);
    }
    
    CFRelease(ctFrameSetter);
    
    
}

static void AddSquashedDonutPath(CGMutablePathRef path,
                                 const CGAffineTransform *m, CGRect rect) {
    
       CGFloat width = CGRectGetWidth(rect);
       CGFloat height = CGRectGetHeight(rect);
    
       CGFloat radiusH = width / 3.0;
       CGFloat radiusV = height / 3.0;
    
       CGPathMoveToPoint( path, m, rect.origin.x, rect.origin.y + height - radiusV);
       CGPathAddQuadCurveToPoint( path, m, rect.origin.x, rect.origin.y + height,
                                  rect.origin.x + radiusH, rect.origin.y + height);
       CGPathAddLineToPoint( path, m, rect.origin.x + width - radiusH,
                                  rect.origin.y + height);
       CGPathAddQuadCurveToPoint( path, m, rect.origin.x + width,
                                  rect.origin.y + height,
                                  rect.origin.x + width,
                                  rect.origin.y + height - radiusV);
       CGPathAddLineToPoint( path, m, rect.origin.x + width,
                                  rect.origin.y + radiusV);
       CGPathAddQuadCurveToPoint( path, m, rect.origin.x + width, rect.origin.y,
                                  rect.origin.x + width - radiusH, rect.origin.y);
       CGPathAddLineToPoint( path, m, rect.origin.x + radiusH, rect.origin.y);
       CGPathAddQuadCurveToPoint( path, m, rect.origin.x, rect.origin.y,
                                  rect.origin.x, rect.origin.y + radiusV);
        // 从当前点增加一个到起点的连线
       CGPathCloseSubpath( path);
    
       // 增加一个椭圆
       CGPathAddEllipseInRect( path, m,
                               CGRectMake( rect.origin.x + width / 2.0 - width / 5.0,
                               rect.origin.y + height / 2.0 - height / 5.0,
                               width / 5.0 * 2.0, height / 5.0 * 2.0));
}


- (NSArray *)paths {
    CGMutablePathRef path = CGPathCreateMutable();
//    CGRect bounds = self.bounds;
//    bounds = CGRectInset(bounds, 10, 10);
    CGRect rect = CGRectMake(100, 100, 200, 200);
    AddSquashedDonutPath(path, NULL, rect);
    
    NSMutableArray *result = [NSMutableArray arrayWithObject:CFBridgingRelease(path)];
    return result;
}
@end
