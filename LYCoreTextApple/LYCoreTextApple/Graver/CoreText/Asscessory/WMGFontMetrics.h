//
//  WMGFontMetrics.h
//  LYCoreTextApple
//
//  Created by 9tong on 2020/1/19.
//  Copyright © 2020 LY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import <CoreGraphics/CoreGraphics.h>

struct WMGFontMetrics {
    CGFloat ascent;
    CGFloat descent;
    CGFloat leading; // 行距
    
    // lineHeight = ascent + |descent| + leading
};

typedef struct WMGFontMetrics WMGFontMetrics;

static inline WMGFontMetrics WMGFontMetricsMake(CGFloat a, CGFloat d, CGFloat l) {
    WMGFontMetrics metrics;
    metrics.ascent = a;
    metrics.descent = d;
    metrics.leading = l;
    return  metrics;
}

extern const WMGFontMetrics WMGFontMetricsZero;
extern const WMGFontMetrics WMGFontMetricsNull;

// UIFont -> WMGFontMetrics
static inline WMGFontMetrics WMGFontMetricsMakeFromUIFont(UIFont *font) {
    if (!font) {
        return WMGFontMetricsNull;
    }
    
    WMGFontMetrics metrics;
    metrics.ascent = ABS(font.ascender);
    metrics.descent = ABS(font.descender);
    metrics.leading = ABS(font.lineHeight) - metrics.ascent - metrics.descent;
    return metrics;
}

// CTFont -> WMGFontMetrics
static inline WMGFontMetrics WMGFontMetricsMakeFromCTFont(CTFontRef font) {
    
    return WMGFontMetricsMake(ABS(CTFontGetAscent(font)), ABS(CTFontGetDescent(font)), ABS(CTFontGetLeading(font)));
}

// 固定 descent, leading , targetLineHeight 决定 ascent -> WMGFontMetrics
static inline WMGFontMetrics WMGFontMetricsMakeWithTargetLineHeight(WMGFontMetrics metrics, CGFloat targetLineHeight) {
    return WMGFontMetricsMake(targetLineHeight - metrics.descent, metrics.descent, metrics.leading);
}

// 根据 WMGFontMetrics -> LineHeight
static inline CGFloat WMGFontMetricsGetLineHeight(WMGFontMetrics metrics) {
    return  ceil(metrics.descent) + ceil(metrics.ascent + metrics.leading);
}

static inline BOOL WMGFontMetricsEqual(WMGFontMetrics m1, WMGFontMetrics m2) {
    return m1.ascent == m2.ascent && m1.descent == m2.descent && m1.leading == m2.leading;
}

static inline NSInteger WMGFontMeticsHash(WMGFontMetrics metics) {
    CGRect concrete = CGRectMake(metics.ascent, metics.descent, metics.leading, 0);
    return [NSStringFromCGRect(concrete) hash];
}


extern WMGFontMetrics WMGFontDefaultMetrics(NSInteger pointSize);

