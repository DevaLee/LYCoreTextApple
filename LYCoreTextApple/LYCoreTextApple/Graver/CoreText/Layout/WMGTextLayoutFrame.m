//
//  WMGTextLayoutFrame.m
//  LYCoreTextApple
//
//  Created by 9tong on 2020/1/19.
//  Copyright © 2020 LY. All rights reserved.
//

#import "WMGTextLayoutFrame.h"
#import "WMGTextLayout.h"
#import "WMGTextLayoutLine.h"

extern NSString * const WMGTextDefaultForegroundColorAttributeName;
static NSString *WMGEllipsisCharacter = @"\u2026";

@interface WMGTextLayoutFrame ()
@property (nonatomic, weak) WMGTextLayout *textLayout;
@property (nonatomic, strong, readwrite) NSMutableArray <WMGTextLayoutLine *> *arrayLines;
@property (nonatomic, assign, readwrite) CGSize layoutSize;

@end

@implementation WMGTextLayoutFrame

-(id)initWithCTFrame:(CTFrameRef)frameRef textLayout:(WMGTextLayout *)textLayout {
    if (self = [super init]) {
        _textLayout = textLayout;
        if (frameRef) {
            [self setupWithCTFrame:frameRef];
        }
    }
    return self;
}

- (void)setupWithCTFrame:(CTFrameRef)frameRef {
    const NSUInteger maximumNumberOfLines = _textLayout.maximumNumberOfLines;
    
    NSArray *lines = (NSArray *)CTFrameGetLines(frameRef);
    NSUInteger lineCount = lines.count;
    CGPoint lineOrigins[lineCount];
    CTFrameGetLineOrigins(frameRef, CFRangeMake(0, lineCount), lineOrigins);
    
    _arrayLines = [[NSMutableArray alloc] init];
    
    // 1,处理截断文字
    for (NSInteger i = 0; i < lineCount; i++) {
        CTLineRef lineRef = (__bridge CTLineRef)lines[i];
        CTLineRef truncatedLineRef = NULL;
        
        if (maximumNumberOfLines) {
            
            if (i == maximumNumberOfLines - 1) {
                // lineCount < maximumNumberOfLines 最后一行需要截断
                BOOL truncated = NO;
                truncatedLineRef = (__bridge CTLineRef)[self _textLayout:_textLayout truncateLine:lineRef atIndex:i truncated:&truncated];
                if (!truncated) {
                    truncatedLineRef = NULL;
                }
            }else if (i >= maximumNumberOfLines){
                break;
            }
        }
        
        WMGTextLayoutLine *line = [[WMGTextLayoutLine alloc] initWithCTLine:lineRef truncatedLine:truncatedLineRef baselineOrigin:lineOrigins[i] textLayout:_textLayout];
        [_arrayLines addObject:line];
    }
    // 2,计算布局的size
    [self _updateLayoutSize];
}

- (void)_updateLayoutSize {
    CGFloat __block width = 0.0;
    CGFloat __block height = 0.0;
    NSUInteger lineCount = _arrayLines.count;
    
    [_arrayLines enumerateObjectsUsingBlock:^(WMGTextLayoutLine * _Nonnull line, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect fragmentRect = line.lineRect;
        if (idx == lineCount - 1) {
            height = CGRectGetMaxY(fragmentRect);
        }
        width  = MAX(width, CGRectGetMaxX(fragmentRect));
    }];
    
    _layoutSize = CGSizeMake(ceil(width), ceil(height));
    
}

#pragma mark - Line Truncating
// 处理截断文字-> 返回新的带有截断文字的CTLineRef 对象
-(id)_textLayout:(WMGTextLayout *)textLayout truncateLine:(CTLineRef)lineRef atIndex:(NSUInteger)index truncated:(BOOL *)truncated {
    if (!lineRef) {
        if (truncated) {
            *truncated = NO;
        }
        return nil;
    }
    // @"是一种高效的UI渲染框架" -> 实际显示: @"是一种高效的UI渲染"
    // 一行可见文字的Range:
    const CFRange stringRange = CTLineGetStringRange(lineRef); // {0, 10}
    if (stringRange.length == 0) {
        if (truncated) {
            *truncated = NO;
        }
        return (__bridge id)lineRef;
    }
    
    CGFloat truncatedWidth = textLayout.size.width;
    
    const CGFloat delegateMaxWidth = [self textLayout:textLayout maximumWidthForTruncatedLine:lineRef atIndex:index];
    BOOL needsTruncate = NO;
    
    if ( delegateMaxWidth < truncatedWidth && delegateMaxWidth > 0 ) {
        // 获取CTLineRef 的宽度
        CGFloat lineWidth = CTLineGetTypographicBounds(lineRef, NULL, NULL, NULL);
        if (lineWidth > delegateMaxWidth) {// 如果设置的最大宽度小于 lineRef 实际的宽度，则需要截断
            truncatedWidth = delegateMaxWidth;
            needsTruncate = YES;
        }
    }
    if (!needsTruncate) {

        if (stringRange.location + stringRange.length < textLayout.attributeString.length) {
            // 没有显示全
            needsTruncate = YES;
        }
    }
    if (!needsTruncate) {
        // 依旧不需要截断
        if (truncated) {
            *truncated = NO;
        }
        return (__bridge id)lineRef;
    }
    
    // 需要 截断
    
    const NSAttributedString *attributedString = textLayout.attributeString;
    
    CTLineTruncationType truncationType = kCTLineTruncationEnd;
    // @"是一种高效的UI渲"
    NSUInteger truncationAttributePosition = stringRange.location + (stringRange.length - 1);
    
    NSDictionary *attrs = [attributedString attributesAtIndex:truncationAttributePosition effectiveRange:NULL];
    attrs = [attrs dictionaryWithValuesForKeys:@[(id)kCTFontAttributeName,(id)kCTParagraphStyleAttributeName,(id)kCTForegroundColorAttributeName,WMGTextDefaultForegroundColorAttributeName]];
    
    // Filter all NSNUll values
    NSMutableDictionary *tokenAttributes = [NSMutableDictionary dictionary];
    [attrs enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (![obj isKindOfClass:[NSNull class]]) {
            [tokenAttributes setObject:obj forKey:key];
        }
    }];
    CGColorRef cgColor = (__bridge CGColorRef)[tokenAttributes objectForKey:WMGTextDefaultForegroundColorAttributeName];
    if (cgColor) {
        [tokenAttributes setValue:(__bridge id)cgColor forKey:(NSString *)kCTForegroundColorAttributeName];
    }
    
    NSAttributedString *tokenString = [[NSAttributedString alloc] initWithString:WMGEllipsisCharacter attributes:tokenAttributes];
    // 如果设置了缺省文字，则用自定义
    if (textLayout.truncationString) {
        tokenString = _textLayout.truncationString;
    }
    
    CTLineRef truncationToken = CTLineCreateWithAttributedString((CFAttributedStringRef)tokenString);
    // 获取能够显示全的那部分文字
    NSMutableAttributedString *truncationString = [[attributedString attributedSubstringFromRange:NSMakeRange(stringRange.location, stringRange.length)] mutableCopy];
    if (stringRange.length > 0) {
        // Remove any newline at the end (we don't want newline space between the text and the truncation token). There can only be one, because the second would be on the next line.
        unichar lastCharacter = [[truncationString string] characterAtIndex:stringRange.length - 1];
        // 当前行是否包含最后一个字符
        if ([[NSCharacterSet newlineCharacterSet] characterIsMember:lastCharacter]) {
            // 删除当前行的最后一个字符
            [truncationString deleteCharactersInRange:NSMakeRange(stringRange.length - 1, 1)];
        }
    }
    // 拼接 截断文字
    [truncationString appendAttributedString:tokenString];
    // 创建新的CTLine
    CTLineRef truncationLine = CTLineCreateWithAttributedString((CFAttributedStringRef)truncationString);
    
    // Truncate the line in case it is too long
    CTLineRef truncatedLine;
    truncatedLine = CTLineCreateTruncatedLine(truncationLine, truncatedWidth, truncationType, truncationToken);
    
    CFRelease(truncationLine);
    
    if (!truncationLine) {
        // If the line is not as wide as the truncationToken, truncatedLine is NULL
        truncatedLine = CFRetain(truncationToken);
    }
    CFRelease(truncationToken);
    if (truncated) {
        *truncated = YES;
    }
    return  CFBridgingRelease(truncatedLine);

}

// 获取展示文字的最大宽度
- (CGFloat)textLayout:(WMGTextLayout *)textLayout maximumWidthForTruncatedLine:(CTLineRef)lineRef atIndex:(NSUInteger)index {
    if ([textLayout.delegate respondsToSelector:@selector(textLayout:maximumWidthForTruncatedLine:atIndex:)]) {
        CGFloat width = [textLayout.delegate textLayout:textLayout maximumWidthForTruncatedLine:lineRef atIndex:index];
        return floor(width);
    }
    return textLayout.size.width;
}

#pragma mark - Results

- (void)enumerateEnclosingRectsForCharacterRange:(NSRange)characterRange usingBlock:(void (^)(CGRect, NSRange, BOOL *))block
{
    if (!block) {
        return;
    }

    const NSUInteger lineCount = [self.arrayLines count];
    [self.arrayLines enumerateObjectsUsingBlock:^(WMGTextLayoutLine *line, NSUInteger idx, BOOL *stop) {

        const NSRange lineRange = line.originStringRange;
        const CGRect lineRect = line.lineRect;

        const NSUInteger lineStartIndex = lineRange.location;
        const NSUInteger lineEndIndex = NSMaxRange(lineRange);

        NSUInteger characterStartIndex = characterRange.location;
        NSUInteger characterEndIndex = NSMaxRange(characterRange);

        // 如果请求的 range 在当前行之后，直接结束
        if (characterStartIndex >= lineEndIndex) {
            return;
        }

        // 如果是最后一行，防止越界
        if (idx == lineCount - 1) {
            characterEndIndex = MIN(lineEndIndex, characterEndIndex);
        }

        const BOOL containsStartIndex = WMRangeContainsIndex(lineRange, characterStartIndex);
        const BOOL containsEndIndex = WMRangeContainsIndex(lineRange, characterEndIndex);

        // 一共只有一行
        if (containsStartIndex && containsEndIndex)
        {
            if (characterStartIndex != characterEndIndex)
            {
                CGFloat startOffset = [line offsetXForCharacterAtIndex:characterStartIndex];
                CGFloat endOffset = [line offsetXForCharacterAtIndex:characterEndIndex];
                CGRect rect = lineRect;
                rect.origin.x += startOffset;
                rect.size.width = endOffset - startOffset;

                block(rect, NSMakeRange(characterStartIndex, characterEndIndex - characterStartIndex), stop);
            }
            *stop = YES;
        }
        // 多行时的第一行
        else if (containsStartIndex)
        {
            if (characterStartIndex != NSMaxRange(lineRange))
            {
                CGFloat startOffset = [line offsetXForCharacterAtIndex:characterStartIndex];
                CGRect rect = lineRect;
                rect.origin.x += startOffset;
                rect.size.width -= startOffset;

                block(rect, NSMakeRange(characterStartIndex, lineEndIndex - characterStartIndex), stop);
            }
        }
        // 多行时的最后一行
        else if (containsEndIndex)
        {
            CGFloat endOffset = [line offsetXForCharacterAtIndex:characterEndIndex];
            CGRect rect = lineRect;
            rect.size.width = endOffset;

            block(rect, NSMakeRange(lineStartIndex, characterEndIndex - lineStartIndex), stop);
        }
        // 多行时的中间行
        else if (WMRangeContainsIndex(characterRange, lineRange.location))
        {
            block(lineRect, lineRange, stop);
        }

        // nothing more
        if (containsEndIndex)
        {
            *stop = YES;
        }
    }];
}


#pragma mark - NSCopying & NSMutableCopying

- (id)copyWithZone:(NSZone *)zone
{
    WMGTextLayoutFrame *copy = [[[self class] allocWithZone:zone] init];
    copy.textLayout = self.textLayout;
    copy.arrayLines = [self.arrayLines copy];
    copy.layoutSize = CGSizeMake(_layoutSize.width, _layoutSize.height);
    return copy;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    WMGTextLayoutFrame *copy = [WMGTextLayoutFrame allocWithZone:zone];
    return copy;
}

#pragma mark - Private

BOOL WMRangeContainsIndex(NSRange range, NSUInteger index)
{
    BOOL a = (index >= range.location);
    BOOL b = (index <= (range.location + range.length));
    return (a && b);
}
@end
