//
//  CTGraphicView.m
//  HQPLabelTest
//
//  Created by 9tong on 2020/1/15.
//  Copyright © 2020 hqp. All rights reserved.
//

#import "CTLineView.h"
#import <CoreText/CoreText.h>
@implementation CTLineView
//https://developer.apple.com/library/archive/documentation/StringsTextFonts/Conceptual/CoreText_Programming/LayoutOperations/LayoutOperations.html#//apple_ref/doc/uid/TP40005533-CH12-SW2

/*
 
 */

-(void)drawRect:(CGRect)rect {

    CGContextRef context;
    context = UIGraphicsGetCurrentContext();

    // Flip the context coordinated, in ios only
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);

    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"Hello, World! I know nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine."];

    [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20 ] range:NSMakeRange(0, attr.string.length)];
    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 5)];

    // 通过 AttributeString 获取 CTLine
    CTLineRef line = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)attr);
    // 设置CTLine的起始点
    CGContextSetTextPosition(context, 100.0, 200.0);
    // 绘制CTLine
    CTLineDraw(line, context);
    CFRelease(line);

}


@end
