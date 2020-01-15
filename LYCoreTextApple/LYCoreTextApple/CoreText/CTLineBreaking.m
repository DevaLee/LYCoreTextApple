//
//  CTLineBreaking.m
//  LYCoreTextApple
//
//  Created by zhangxiaguang on 2020/1/15.
//  Copyright © 2020年 LY. All rights reserved.
//

#import "CTLineBreaking.h"
#import <CoreText/CoreText.h>
@implementation CTLineBreaking

-(void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetTextMatrix(context,CGAffineTransformIdentity);
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"Hello, World! I know nothing in the world thawrite one, and I look at it, until it begins to shine.nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine."];
    
    [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20 ] range:NSMakeRange(0, attr.string.length)];
    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 5)];
    // 第一行的字符数
    double width = 20;
    // 开始绘制点
    CGPoint textPosition = CGPointMake(100, 200);
    CFAttributedStringRef attrString = (__bridge CFAttributedStringRef)attr;
    // 创建CTTypesetterRef
    CTTypesetterRef typesetter = CTTypesetterCreateWithAttributedString(attrString);
    // 由width和start 确定String的换行点
    CFIndex start = 0;
    
    CFIndex count = CTTypesetterSuggestLineBreak(typesetter, start, width);
    // 创建CTLine
    CTLineRef line = CTTypesetterCreateLine(typesetter, CFRangeMake(start, width));
    
    
    
    float flush = 1;// 0,0.5,1时分别显示的效果为左对齐，居中对齐，右对齐
    double penOffset = CTLineGetPenOffsetForFlush(line, flush, width);
    
    CGContextSetTextPosition(context, textPosition.x + penOffset
                             , textPosition.y);
    CTLineDraw(line, context);
    start += count;
}


@end
