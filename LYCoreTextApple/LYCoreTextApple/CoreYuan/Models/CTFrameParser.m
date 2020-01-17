//
//  CTFrameParser.m
//  LYCoreTextApple
//
//  Created by 李玉臣 on 2020/1/17.
//  Copyright © 2020 LY. All rights reserved.
//

#import "CTFrameParser.h"
#import <UIKit/UIKit.h>
#import "CoreTextImageData.h"
@implementation CTFrameParser
static CGFloat ascentCallback(void *ref) {
    return [(NSNumber *)[(__bridge NSDictionary *)ref objectForKey:@"height"] floatValue];
}

static CGFloat descentCallback(void *ref) {
    return 0;
}

static CGFloat widthCallback(void *ref) {
    return [(NSNumber *)[(__bridge NSDictionary *)ref objectForKey:@"width"] floatValue];
}
// 获取属性
+ (NSMutableDictionary *)attributesWithConfig:(CTFrameParserConfig *)config {
    CGFloat fontSize = config.fontSize;
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"ArialMT", fontSize, NULL);
    CGFloat lineSpacing = config.lineSpace;
    const CFIndex kNumberOfSettings = 3;
    CTParagraphStyleSetting theSettings[kNumberOfSettings] = {
        { kCTParagraphStyleSpecifierLineSpacingAdjustment, sizeof(CGFloat), &lineSpacing },
        { kCTParagraphStyleSpecifierMaximumLineSpacing, sizeof(CGFloat), &lineSpacing },
        { kCTParagraphStyleSpecifierMinimumLineSpacing, sizeof(CGFloat), &lineSpacing }
    };
    
    CTParagraphStyleRef theParagraphRef = CTParagraphStyleCreate(theSettings, kNumberOfSettings);
    
    UIColor * textColor = config.textColor;
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[(id)kCTForegroundColorAttributeName] = (id)textColor.CGColor;
    dict[(id)kCTFontAttributeName] = (__bridge id)fontRef;
    dict[(id)kCTParagraphStyleAttributeName] = (__bridge id)theParagraphRef;
    
    CFRelease(theParagraphRef);
    CFRelease(fontRef);
    return dict;
}
+ (CoreTextData *)parseTemplateFile:(NSString *)path
                             config:(CTFrameParserConfig *)config {
    NSMutableArray *imageArray = [NSMutableArray array];
    NSMutableArray *linkArray = [NSMutableArray array];
    NSAttributedString *content = [self loadTemplateFile:path config:config imageArray:imageArray linkArray:linkArray];
    
    CoreTextData *data = [self parseAttributedContent:content config:config];
    
    data.imageArray = imageArray;
    data.linkArray = linkArray;
    
    return  data;
}

+ (NSAttributedString *)loadTemplateFile:(NSString *)path
                                  config:(CTFrameParserConfig *)config
                              imageArray:(NSMutableArray *)imageArray
                               linkArray:(NSMutableArray *)linkArray {
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] init];
    if (data) {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        if ([array isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dict in array) {
                NSString *type = dict[@"type"];
                if ([type isEqualToString:@"txt"]) {
                    NSAttributedString *as = [self parseAttributedContentFromNSDictionary:dict config:config];
                    [result appendAttributedString:as];
                } else if ([type isEqualToString:@"img"]){
                    // 创建 CoreTextImageData
                    CoreTextImageData *imageData = [[CoreTextImageData alloc] init];
                    imageData.name = dict[@"name"];
                    imageData.position = (int)[result length];
                    [imageArray addObject:imageData];
                    // 创建空白占位符，并且设置它的CTRunDelegate信息
                    /*
                     dict:
                     {
                       "type" : "img",
                       "width" : 50,
                       "height" : 32,
                       "name" : "coretext-image-2.jpg"
                     }
                     */

                    // 得到一个含有空白占位符和图片信息的富文本
                    NSAttributedString *as = [self parseImageDataFromNSDictionary:dict config:config];
                    [result appendAttributedString:as];
                }
            }
        }
    }
    return result;
    
}

/*
    解析图片信息
 */
+ (NSAttributedString *)parseImageDataFromNSDictionary:(NSDictionary *)dict
                                                config:(CTFrameParserConfig *)config {
    CTRunDelegateCallbacks callbacks;
    // 初始化，分配空间
    memset(&callbacks, 0, sizeof(CTRunDelegateCallbacks));
    callbacks.version = kCTRunDelegateVersion1;
    callbacks.getAscent = ascentCallback; // 图片的高度
    callbacks.getDescent = descentCallback; // 图片的descent = 0
    callbacks.getWidth = widthCallback; // 图片的宽度
    
    
    // 将图片信息保存到CTRunDelegate中
    CTRunDelegateRef delegate = CTRunDelegateCreate(&callbacks,(__bridge void *)dict);
    
    // 使用0xFFFC作为空白的占位符,
    unichar objectReplacementChar = 0xFFFC;
    NSString *content = [NSString stringWithCharacters:&objectReplacementChar length:1];
    // 图片使用默认的文字属性
    NSDictionary *attributes = [self attributesWithConfig:config];
    NSMutableAttributedString *space = [[NSMutableAttributedString alloc] initWithString:content attributes:attributes];
    // 将 attributedString 与 CTRunDelegate 进行属性绑定
    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)space, CFRangeMake(0, 1), kCTRunDelegateAttributeName, delegate);
    CFRelease(delegate);
    
    return space;
}
/*
 解析文字信息
 */
+ (NSAttributedString *)parseAttributedContentFromNSDictionary:(NSDictionary *)dict
                                                        config:(CTFrameParserConfig*)config {
    NSMutableDictionary *attributes = [self attributesWithConfig:config];
    // set color
    UIColor *color = [self colorFromTemplate:dict[@"color"]];
    if (color) {
        attributes[(id)kCTForegroundColorAttributeName] = (id)color.CGColor;
    }
    // set font size
    CGFloat fontSize = [dict[@"size"] floatValue];
    if (fontSize > 0) {
        CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"ArialMT", fontSize, NULL);
        attributes[(id)kCTFontAttributeName] = (__bridge id)fontRef;
        CFRelease(fontRef);
    }
    NSString *content = dict[@"content"];
    return [[NSAttributedString alloc] initWithString:content attributes:attributes];
}

+ (UIColor *)colorFromTemplate:(NSString *)name {
    if ([name isEqualToString:@"blue"]) {
        return [UIColor blueColor];
    } else if ([name isEqualToString:@"red"]) {
        return [UIColor redColor];
    } else if ([name isEqualToString:@"black"]) {
        return [UIColor blackColor];
    }else {
        return nil;
    }
}

//通过config中的font，color等信息，生成CoreTextData(CTFrame,attributedString等信息)
+ (CoreTextData *)parseContent:(NSString *)content config:(CTFrameParserConfig *)config {
    
    NSDictionary *attributes = [self attributesWithConfig:config];
    NSAttributedString *contentString = [[NSAttributedString alloc] initWithString:content attributes:attributes];
    
    return [self parseAttributedContent:contentString config:config];
    
    
}


+ (CoreTextData *)parseAttributedContent:(NSAttributedString *)content
                                  config:(CTFrameParserConfig *)config {
    //创建CTFramesetter 实例
    CTFramesetterRef framesetter =  CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)content);
    // 获得要绘制区域的高度
    CGSize restrictSize = CGSizeMake(config.width, CGFLOAT_MAX);
    CGSize coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), nil, restrictSize, nil);
    CGFloat textHeight = coreTextSize.height;
    
    // 生成CTFrame 实例
    CTFrameRef ctFrame = [self createFrameWithFramesetter:framesetter config:config height:textHeight];
    // 将生成好的ctFrame实例和计算好的高度保存到CoreTextData中，并返回
    CoreTextData *textData =[[CoreTextData alloc] init];
    textData.ctFrame = ctFrame;
    textData.height = textHeight;
    textData.content = content;
    
    CFRelease(ctFrame);
    CFRelease(framesetter);
    
    return textData;
}


+ (CTFrameRef)createFrameWithFramesetter:(CTFramesetterRef) framesetter
                                  config:(CTFrameParserConfig *)config
                                  height:(CGFloat) height {
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, config.width, height));
    
    CTFrameRef ctFrame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    CFRelease(path);
    return ctFrame;
}





@end
