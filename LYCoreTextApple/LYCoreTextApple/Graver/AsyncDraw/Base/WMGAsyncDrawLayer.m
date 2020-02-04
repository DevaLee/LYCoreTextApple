//
//  WMGAsyncDrawLayer.m
//  LYCoreTextApple
//
//  Created by 李玉臣 on 2020/2/4.
//  Copyright © 2020 LY. All rights reserved.
//

#import "WMGAsyncDrawLayer.h"

@implementation WMGAsyncDrawLayer

-(void)increaseDrawingCount {
    _drawingCount = (_drawingCount + 1) % 10000;
}


-(void)setNeedsDisplay {
    [self increaseDrawingCount];
    [super setNeedsDisplay];
}

- (void)setNeedsDisplayInRect:(CGRect)r {
    [self increaseDrawingCount];
    [super setNeedsDisplayInRect:r];
}

- (BOOL)isAsyncDrawsCurrentContent {
    switch (_drawingPolicy) {
        case WMGViewDrawingPolicyAsynchronouslyDrawWhenContentsChanged:
            return _contentsChangedAfterLastAsyncDrawing;
        case WMGViewDrawingPolicyAsynchronouslyDraw:
            return YES;
        case WMGViewDrawingPolicySynchronouslyDraw:
            return NO;
        default:
            return NO;
    }
}
@end
