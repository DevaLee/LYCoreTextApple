//
//  WMGAsyncDrawLayer.h
//  LYCoreTextApple
//
//  Created by 李玉臣 on 2020/2/4.
//  Copyright © 2020 LY. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, WMGViewDrawingPolicy) {
    // 当 contentsChangedAfterLastAsyncDrawing 为 YES 时异步绘制
    WMGViewDrawingPolicyAsynchronouslyDrawWhenContentsChanged,
    // 同步绘制
    WMGViewDrawingPolicySynchronouslyDraw,
    // 异步绘制
    WMGViewDrawingPolicyAsynchronouslyDraw,
};


@interface WMGAsyncDrawLayer : CALayer

// 绘制完成后，内容经过此时间的渐变显示出来，默认为 0.0
@property (nonatomic, assign) NSTimeInterval fadeDuration;

// 绘制逻辑，定义同步绘制或异步，详细见枚举定义，默认为 WMGViewDrawingPolicyAsynchronouslyDrawWhenContentsChanged
@property (nonatomic, assign) WMGViewDrawingPolicy drawingPolicy;

// 在drawingPolicy 为 WMGViewDrawingPolicyAsynchronouslyDrawWhenContentsChanged 时使用
// 需要异步绘制时设置一次 YES，默认为NO
@property (nonatomic, assign) BOOL contentsChangedAfterLastAsyncDrawing;

// 下次AsyncDrawing完成前保留当前的contents
@property (nonatomic, assign) BOOL reserveContentsBeforeNextDrawingComplete;

// 绘制次数
@property (nonatomic, assign, readonly) NSInteger drawingCount;

/**
 * 增加异步绘制次数
 */
- (void)increaseDrawingCount;

/**
 * 当前内容是否异步绘制
 */
- (BOOL)isAsyncDrawsCurrentContent;

@end

NS_ASSUME_NONNULL_END
