//
//  WMGTextLayout.m
//  LYCoreTextApple
//
//  Created by 9tong on 2020/1/19.
//  Copyright © 2020 LY. All rights reserved.
//

#import "WMGTextLayout.h"
#import "WMGTextLayoutFrame.h"

@interface WMGTextLayout ()
{
    struct {
        unsigned int needsLayout: 1;
    } _flags;
    
}

@property (nonatomic, strong) WMGTextLayoutFrame *layoutFrame;

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
        [self setNeedsLayout];
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

-(WMGTextLayoutFrame *)layoutFrame {
    if (!_layoutFrame || _flags.needsLayout) {
        @synchronized (self) {
            _layoutFrame = [self _createLayoutFrame];
        }
        _flags.needsLayout = NO;
    }
    return _layoutFrame;
}

- (WMGTextLayoutFrame *)_createLayoutFrame {
    const NSAttributedString *attributedString = _attributeString;
    if (!attributedString) {
        return nil;
    }
    
    CTFrameRef ctFrame = NULL;
    
    {
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef) attributedString);
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, CGRectMake(0, 0, _size.width, _size.height));
        
        ctFrame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
        CFRelease(path);
        CFRelease(framesetter);
        
    }
    
    if (!ctFrame) {
        return  nil;
    }
    
    WMGTextLayoutFrame *layoutFrame = [[WMGTextLayoutFrame alloc] initWithCTFrame:ctFrame textLayout:self];
    CFRelease(ctFrame);
    return layoutFrame;
}

-(BOOL)layoutUpToDate {
    return !_flags.needsLayout || !_layoutFrame;
}


@end






CGFloat const WMGTextLayoutMaximumWidth = 2000;
CGFloat const WMGTextLayoutMaximumHeight = 10000000;
