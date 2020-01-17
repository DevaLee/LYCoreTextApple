//
//  CTFrameParser.m
//  LYCoreTextApple
//
//  Created by 李玉臣 on 2020/1/17.
//  Copyright © 2020 LY. All rights reserved.
//

#import "CTFrameParser.h"
#import <UIKit/UIKit.h>
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

    const CFIndex kNumberOfSetting = 3;
    CTParagraphStyleSetting theSettings[kNumberOfSetting] = {
        {kCTParagraphStyleSpecifierLineSpacingAdjustment, sizeof(CGFloat), &lineSpacing},
        {kCTParagraphStyleSpecifierMaximumLineHeight, sizeof(CGFloat),&lineSpacing},
        {kCTParagraphStyleSpecifierMinimumLineHeight, sizeof(CGFloat),&lineSpacing}
    };

    CTParagraphStyleRef theParagraphRef = CTParagraphStyleCreate(theSettings, kNumberOfSetting);


    UIColor *textColor = config.textColor;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[(id)kCTForegroundColorAttributeName] = (id)textColor.CGColor;
    dict[(id)kCTFontAttributeName] = (__bridge id)fontRef;
    dict[(id)kCTParagraphStyleAttributeName] = (__bridge id)theParagraphRef;

    CFRelease(theParagraphRef);
    CFRelease(fontRef);
    return dict;
}

@end
