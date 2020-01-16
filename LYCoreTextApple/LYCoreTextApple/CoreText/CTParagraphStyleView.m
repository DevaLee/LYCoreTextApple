//
//  CTParagraphStyleView.m
//  LYCoreTextApple
//
//  Created by zhangxiaguang on 2020/1/15.
//  Copyright © 2020年 LY. All rights reserved.
//

#import "CTParagraphStyleView.h"
#import <CoreText/CoreText.h>

@implementation CTParagraphStyleView

-(void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    
    CFStringRef fontName = CFSTR("Didot-Italic");
    CGFloat pointSize = 24.0;
    
    CFStringRef string = CFSTR("Hello, World! I know nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine.");
    
    NSMutableAttributedString *attrString = applyParaStyle(fontName, pointSize,(__bridge NSString *) string, 8);
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attrString);
    CGRect drawRect = CGRectMake(100, 100, 200, 400);
    CGPathRef path = CGPathCreateWithRect(drawRect, NULL);
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    
    CTFrameDraw(frame, context);
    
    CFRelease(frame);
    CGPathRelease(path);
    CFRelease(framesetter);
}


NSMutableAttributedString *applyParaStyle(CFStringRef fontName,
                                          CGFloat pointSize,
                                          NSString *plainText,
                                          CGFloat lineSpaceInc){
    // 创建font
    CTFontRef font = CTFontCreateWithName(fontName, pointSize, NULL);
    // 设置lineSpacing
    CGFloat lineSpacing = (CTFontGetLeading(font) + lineSpaceInc) * 2;
    // 创建 paragraph style settings
    CTParagraphStyleSetting setting;
    setting.spec = kCTParagraphStyleSpecifierMinimumLineSpacing;
    setting.valueSize = sizeof(CGFloat);
    setting.value = &lineSpacing;
    
    // 创建 paragraph
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(&setting, 1);
    
    // 将Paragraph 添加到 dictionary中
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)font,(id)kCTFontNameAttribute, (__bridge id)paragraphStyle,(id)kCTParagraphStyleAttributeName,nil];
    
    CFRelease(font);
    CFRelease(paragraphStyle);
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:plainText attributes:attributes];
    
    return  attrString;
}



@end
