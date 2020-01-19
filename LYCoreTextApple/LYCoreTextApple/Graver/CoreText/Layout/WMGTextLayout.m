//
//  WMGTextLayout.m
//  LYCoreTextApple
//
//  Created by 9tong on 2020/1/19.
//  Copyright © 2020 LY. All rights reserved.
//

#import "WMGTextLayout.h"

@interface WMGTextLayout ()
{
    struct {
        unsigned int needsLayout: 1;
    } _flags;
    
}

@end


@implementation WMGTextLayout


-(instancetype)init {
    if (self = [super init]) {
        _flags.needsLayout = YES;
        _heightSensitiveLayout = YES;
        _baselineFontMetrics = WMGFontMetricsNull;
    }
    return self;
}

- (void)setAttributeString:(NSAttributedString *)attributeString
{
    if (_attributeString != attributeString) {
        @synchronized(self) {
            _attributeString = attributeString;
        }
        [self setNeedsLayout];
    }
}

- (void)setSize:(CGSize)size
{
    if (!CGSizeEqualToSize(_size, size)) {
        _size = size;
        _flags.needsLayout = YES;
    }
}

- (void)setMaximumNumberOfLines:(NSUInteger)maximumNumberOfLines
{
    if (_maximumNumberOfLines != maximumNumberOfLines) {
        _maximumNumberOfLines = maximumNumberOfLines;
        [self setNeedsLayout];
    }
}

- (void)setBaselineFontMetrics:(WMGFontMetrics)baselineFontMetrics
{
    if (!WMGFontMetricsEqual(_baselineFontMetrics, baselineFontMetrics)) {
        _baselineFontMetrics = baselineFontMetrics;
        [self setNeedsLayout];
    }
}

- (void)setNeedsLayout
{
    _flags.needsLayout = YES;
}


@end
