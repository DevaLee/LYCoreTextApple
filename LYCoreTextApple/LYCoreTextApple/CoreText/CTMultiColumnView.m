//
//  CTMultiColumnView.m
//  LYCoreTextApple
//
//  Created by zhangxiaguang on 2020/1/15.
//  Copyright © 2020年 LY. All rights reserved.
//

#import "CTMultiColumnView.h"
#import <CoreText/CoreText.h>

@implementation CTMultiColumnView

-(void)drawRect:(CGRect)rect {
    CGContextRef context;
    context = UIGraphicsGetCurrentContext();
    
    // Flip the context coordinated, in ios only
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"Hello, World! I know nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine.nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine.nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine.nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine.nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine.nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine.nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine.nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine.nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine.nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine.nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine.nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine.nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine.nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine.nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine."];
    
    [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20 ] range:NSMakeRange(0, attr.string.length)];
    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 5)];
    
    // frameSetter
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attr);
    
    CFArrayRef columnPaths = [self createColumnWithColumnCount:3];
    CFIndex pathCount = CFArrayGetCount(columnPaths);
    CFIndex startIndex = 0;
    int column;
    
    for (column = 0; column < pathCount; column++) {
        
        // Get the path for this column.
        CGPathRef path = (CGPathRef)CFArrayGetValueAtIndex(columnPaths, column);
        
        // Create a frame for this column and draw it.
        CTFrameRef frame = CTFramesetterCreateFrame(
                                                    framesetter, CFRangeMake(startIndex, 0), path, NULL);
        CTFrameDraw(frame, context);
        
        // Start the next frame at the first character not visible in this frame.
        CFRange frameRange = CTFrameGetVisibleStringRange(frame);
        startIndex += frameRange.length;
        CFRelease(frame);
    }
    CFRelease(columnPaths);
    CFRelease(framesetter);
    
}
// 创建包含CGRect的数组
-(CFArrayRef)createColumnWithColumnCount:(int) columnCount {
    int column;
    CGRect *columnRects = (CGRect *)calloc(columnCount, sizeof(*columnRects));
    columnRects[0] = self.bounds;
    
    CGFloat columnWidth = CGRectGetWidth(self.bounds) / columnCount;
    
    for (column = 0; column < columnCount - 1; column++) {
        CGRectDivide(columnRects[column], &columnRects[column], &columnRects[column + 1], columnWidth, CGRectMinXEdge);
    }
    // Inset all columns by a few pixels of margin
    for (column = 0; column < columnCount; column++) {
        columnRects[column] = CGRectInset(columnRects[column], 8.0, 15.0);
    }
    
    CFMutableArrayRef array = CFArrayCreateMutable(kCFAllocatorDefault, columnCount, &kCFTypeArrayCallBacks);
    
    for (column = 0; column < columnCount; column++) {
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, columnRects[column]);
        CFArrayInsertValueAtIndex(array, column, path);
        CFRelease(path);
    }
    free(columnRects);
    return array;
}

@end
