//
//  WMGAsyncDrawView.m
//  LYCoreTextApple
//
//  Created by 李玉臣 on 2020/2/4.
//  Copyright © 2020 LY. All rights reserved.
//

#import "WMGAsyncDrawView.h"
#import "WMGContextAssisant.h"
#import "WMGraverMacroDefine.h"

@interface WMGAsyncDrawView ()

@property (nonatomic, weak) WMGAsyncDrawLayer *drawingLayer;

- (void)_displayLayer:(WMGAsyncDrawLayer *)layer
                 rect:(CGRect)rectToDraw
       drawingStarted:(WMGAsyncDrawCallback)startBlock
      drawingFinished:(WMGAsyncDrawCallback)finishBlock
   drawingInterrupted:(WMGAsyncDrawCallback)interruptBlock;

@end


@implementation WMGAsyncDrawView

static BOOL _globalAsyncDrawDisabled = NO;

+(void)initialize {
    _globalAsyncDrawDisabled = NO;
}

+ (BOOL)globalAsyncDrawingDisabled {
    return _globalAsyncDrawDisabled;
}

+ (void)setGlobalAsyncDrawingDisabled:(BOOL)disable {
    _globalAsyncDrawDisabled = disable;
}

-(void)dealloc {

    if (_dispatchDrawQueue) {
        _dispatchDrawQueue = NULL;
    }
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.drawingPolicy = WMGViewDrawingPolicyAsynchronouslyDrawWhenContentsChanged;
        self.opaque = NO;
        self.layer.contentsScale = [UIScreen mainScreen].scale;
        self.dispatchPriority = DISPATCH_QUEUE_PRIORITY_DEFAULT;

        // make overrides work
        self.drawingPolicy = self.drawingPolicy;
        self.fadeDuration = self.fadeDuration;

        self.contentsChangedAfterLastAsyncDrawing = self.contentsChangedAfterLastAsyncDrawing;
        self.reserveContentsBeforeNextDrawingComplete = self.reserveContentsBeforeNextDrawingComplete;

        if ([self.layer isKindOfClass:[WMGAsyncDrawLayer class]]) {
            _drawingLayer = (WMGAsyncDrawLayer *)self.layer;
        }
    }
    return self;
}

#pragma mark - Override From UIView

+ (Class)layerClass {
    return [WMGAsyncDrawLayer class];
}

- (void)didMoveToWindow {
    [super didMoveToWindow];

    // 没有window 说明View已经没有显示在界面上，此时应该终止绘制
    if (!self.window) {
        [self interruptDrawingWhenPossible];
    }else if(!self.layer.contents) {
        [self setNeedsDisplay];
    }
}

#pragma mark -

- (NSUInteger)drawingCount {

    return _drawingLayer.drawingCount;
}

//- (dispatch_queue_t)dispatchDrawQueue {
//    if (self.dispatchDrawQueue) {
//        return self.dispatchDrawQueue;
//    }
//
//    return dispatch_get_global_queue(self.dispatchPriority, 0);
//}
- (dispatch_queue_t)drawQueue {
    if (self.dispatchDrawQueue) {
        return self.dispatchDrawQueue;
    }

    return dispatch_get_global_queue(self.dispatchPriority, 0);
}

-(void)setDispatchDrawQueue:(dispatch_queue_t)dispatchDrawQueue {
    if (_dispatchDrawQueue) {
        _dispatchDrawQueue = NULL;
    }

    _dispatchDrawQueue = dispatchDrawQueue;
}


- (void)interruptDrawingWhenPossible {

    [_drawingLayer increaseDrawingCount];
}

-(BOOL)alwaysUsesOffscreenRendering {
    return YES;
}

-(NSTimeInterval)fadeDuration {

    return _drawingLayer.fadeDuration;
}

-(void)setFadeDuration:(NSTimeInterval)fadeDuration {

    _drawingLayer.fadeDuration  = fadeDuration;
}

-(WMGViewDrawingPolicy)drawingPolicy {

    return _drawingLayer.drawingPolicy;
}

-(void)setDrawingPolicy:(WMGViewDrawingPolicy)drawingPolicy {

    _drawingLayer.drawingPolicy = drawingPolicy;
}

-(BOOL)contentsChangedAfterLastAsyncDrawing {

    return _drawingLayer.contentsChangedAfterLastAsyncDrawing;
}

-(void)setContentsChangedAfterLastAsyncDrawing:(BOOL)contentsChangedAfterLastAsyncDrawing {
    _drawingLayer.contentsChangedAfterLastAsyncDrawing = contentsChangedAfterLastAsyncDrawing;
}

-(BOOL)reserveContentsBeforeNextDrawingComplete {

    return _drawingLayer.reserveContentsBeforeNextDrawingComplete;
}

-(void)setReserveContentsBeforeNextDrawingComplete:(BOOL)reserveContentsBeforeNextDrawingComplete {
    _drawingLayer.reserveContentsBeforeNextDrawingComplete = reserveContentsBeforeNextDrawingComplete;
}

#pragma mark - Drawing

-(void)redraw {

    [self  displayLayer:self.layer];
}

- (void)setNeedsDisplayAsync {
    self.contentsChangedAfterLastAsyncDrawing = YES;
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();

    if (!context) {
        WMGLog(@"may be memory warning");
    }

    [self drawInRect:self.bounds withContext:context asynchronously:NO userInfo:[self currentDrawingUserInfo]];
    [self drawingDidFinishAsynchronously:NO success:YES];
}

-(void)setNeedsDisplay {
    [self.layer setNeedsDisplay];
}

-(void)setNeedsDisplayInRect:(CGRect)rect {
    [self.layer setNeedsDisplayInRect:rect];
}

-(void)displayLayer:(CALayer *)layer {
    if (!layer) {
        return;
    }

    NSAssert([layer isKindOfClass:[WMGAsyncDrawLayer class]], @"WMGAsyncDrawingView can only display WMGAsyncDrawLayer");
    if (layer != self.layer) {
        return;
    }
    [self _displayLayer:(WMGAsyncDrawLayer *)layer rect:self.bounds drawingStarted:^(BOOL drawInBackground) {
        [self drawingWillStartAsynchronously:drawInBackground];
    } drawingFinished:^(BOOL drawInBackground) {
        [self drawingDidFinishAsynchronously:drawInBackground success:YES];
    } drawingInterrupted:^(BOOL drawInBackground) {
        [self drawingDidFinishAsynchronously:drawInBackground success:NO];
    }];
}

-(void) _displayLayer:(WMGAsyncDrawLayer *)layer rect:(CGRect)rectToDraw drawingStarted:(WMGAsyncDrawCallback)startCallback drawingFinished:(WMGAsyncDrawCallback)finishCallback drawingInterrupted:(WMGAsyncDrawCallback)interruptCallback {

    BOOL drawInBackground = layer.isAsyncDrawsCurrentContent && ![[self class] globalAsyncDrawingDisabled];
    [layer increaseDrawingCount];

    NSUInteger targetDrawingCount = layer.drawingCount;
    NSDictionary *drawingUserInfo = [self currentDrawingUserInfo];
    void (^drawBlock)(void) = ^{
        void (^failedBlock)(void) = ^{
            if (interruptCallback) {
                interruptCallback(drawInBackground);
            }
        };

        if (layer.drawingCount != targetDrawingCount) {
            failedBlock();
            return ;
        }

        CGSize contextSize = layer.bounds.size;
        BOOL contextSizeValid = contextSize.width >= 1 && contextSize.height >= 1;
        CGContextRef context = NULL;
        BOOL drawingFinished = YES;

        if (contextSizeValid) {
            UIGraphicsBeginImageContextWithOptions(contextSize, layer.opaque, layer.contentsScale);

            context = UIGraphicsGetCurrentContext();

            if (!context) {
                WMGLog(@"may be memory warning");
            }

            CGContextSaveGState(context);
            if (rectToDraw.origin.x || rectToDraw.origin.y) {
                CGContextTranslateCTM(context, rectToDraw.origin.x, -rectToDraw.origin.y);
            }

            if (layer.drawingCount != targetDrawingCount) {
                drawingFinished = NO;
            }else {
                drawingFinished = [self drawInRect:rectToDraw withContext:context asynchronously:drawInBackground userInfo:drawingUserInfo];
            }
            CGContextRestoreGState(context);
        }
        // 所有耗时的操作都已完成，但仅在绘制过程中未发生重绘时，将结果显示出来
        if (drawingFinished && targetDrawingCount == layer.drawingCount) {
            CGImageRef CGImage = context ? CGBitmapContextCreateImage(context) : NULL;
            {
                // 让 UIImage 进行内存管理
                UIImage *image = CGImage ? [UIImage imageWithCGImage:CGImage] : nil;

                void (^finishBlock)(void) = ^{
                    if (targetDrawingCount != layer.drawingCount) {
                        failedBlock();
                        return ;
                    }
                    layer.contents = (id)image.CGImage;
                    [layer setContentsChangedAfterLastAsyncDrawing:NO];
                    [layer setReserveContentsBeforeNextDrawingComplete:NO];
                    if (finishCallback) {
                        finishCallback(drawInBackground);
                    }

                    if (drawInBackground && layer.fadeDuration > 0.0001) {
                        layer.opacity = 0.0;
                        [UIView animateWithDuration:layer.fadeDuration animations:^{
                            layer.opacity = 1.0;
                        } completion:NULL];
                    }
                };
                if (drawInBackground) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        finishBlock();
                    });
                }else {
                    finishBlock();
                }
            }
        }else {
            failedBlock();
        }
        UIGraphicsEndImageContext();
    };

    if (startCallback) {
        startCallback(drawInBackground);
    }

    if (drawInBackground) {
        // 清楚 layer的显示
        if (!layer.reserveContentsBeforeNextDrawingComplete) {
            layer.contents = nil;
        }

        dispatch_async([self drawQueue], drawBlock);
    }else {
        void(^block)(void) = ^{
            @autoreleasepool {
                drawBlock();
            }
        };

        if ([NSThread isMainThread]) {
            block();
        }else {
            dispatch_async(dispatch_get_main_queue(), block);
        }
    }
}

-(BOOL)respondsToSelector:(SEL)aSelector {
    if (!self.alwaysUsesOffscreenRendering) {
        if ([NSStringFromSelector(aSelector) isEqualToString:@"displayLayer:"]) {
            return  self.drawingPolicy != WMGViewDrawingPolicySynchronouslyDraw;
        }
    }
    return [super respondsToSelector:aSelector];
}

-(NSDictionary *)currentDrawingUserInfo {

    return nil;
}

- (void)drawingWillStartAsynchronously:(BOOL)asynchronously
{

}

-(BOOL)drawInRect:(CGRect)rect withContext:(CGContextRef)context asynchronously:(BOOL)asynchronously {

    return YES;
}

-(BOOL)drawInRect:(CGRect)rect withContext:(CGContextRef)context asynchronously:(BOOL)asynchronously userInfo:(nonnull NSDictionary *)userInfo {

    return [self drawInRect:rect withContext:context asynchronously:asynchronously];
}

- (void)drawingDidFinishAsynchronously:(BOOL)asynchronously success:(BOOL)success
{

}
@end
