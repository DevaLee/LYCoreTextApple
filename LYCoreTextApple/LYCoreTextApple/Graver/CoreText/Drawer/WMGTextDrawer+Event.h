//
//  WMGTextDrawer+Event.h
//  LYCoreTextApple
//
//  Created by 9tong on 2020/1/21.
//  Copyright © 2020 LY. All rights reserved.
//
#import "WMGTextDrawer.h"

@protocol WMGActiveRange;
@protocol WMGTextDrawerEventDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface WMGTextDrawer ()
{
@protected
    __weak id<WMGTextDrawerEventDelegate> _eventDelegate;
    // 记录上次touch end时候的timestamp，否则调用2次touch ended
    NSTimeInterval _lastTouchEndedTimeStamp;
    
    struct {
        unsigned int placeAttachment: 1;
    } _delegateHas;
    
    struct {
        unsigned int contextView: 1;
        unsigned int activeRanges: 1;
        unsigned int didPressActiveRange: 1;
        unsigned int didHighlightedActiveRange: 1;
        unsigned int shouldInteractWithActiveRange: 1;
    } _eventDelegateHas;
    
    CGPoint _touchesBeginPoint;
}

// 正在响应点击的激活区，每一个可点击区域都被定义成了激活区
@property (nonatomic, strong, nullable) id<WMGActiveRange> pressingActiveRange;

// 已保存的点击激活区
@property (nonatomic, strong, nullable) id<WMGActiveRange> savedPressingActiveRange;

@end

NS_ASSUME_NONNULL_END

