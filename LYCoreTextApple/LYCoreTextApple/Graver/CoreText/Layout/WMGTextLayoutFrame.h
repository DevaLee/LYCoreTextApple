//
//  WMGTextLayoutFrame.h
//  LYCoreTextApple
//
//  Created by 9tong on 2020/1/19.
//  Copyright © 2020 LY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import <CoreGraphics/CoreGraphics.h>

@class WMGTextLayout;
@class WMGTextLayoutLine;

NS_ASSUME_NONNULL_BEGIN

@interface WMGTextLayoutFrame : NSObject<NSCopying, NSMutableCopying>

@property (nonatomic,strong,readonly) NSArray<WMGTextLayoutLine *> *arrayLines;
@property (nonatomic,assign, readonly) CGSize layoutSize;

/**
 *  根据一个CTFrameRef进行初始化
 *
 *  @param frameRef    CTFrameRef
 *  @param textLayout  WMGTextLayout
 *
 *  @return WMGTextLayoutFrame
 */
- (id)initWithCTFrame:(CTFrameRef)frameRef textLayout:(WMGTextLayout *)textLayout;

- (void)enumerateEnclosingRectsForCharacterRange:(NSRange)characterRange usingBlock:(void (^)(CGRect, NSRange, BOOL *))block;
@end

NS_ASSUME_NONNULL_END
