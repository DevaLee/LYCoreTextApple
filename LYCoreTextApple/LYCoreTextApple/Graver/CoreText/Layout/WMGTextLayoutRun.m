//
//  WMGTextLayoutRun.m
//  LYCoreTextApple
//
//  Created by 9tong on 2020/1/19.
//  Copyright © 2020 LY. All rights reserved.
//

#import "WMGTextLayoutRun.h"
#import "WMGAttachment.h"

@implementation WMGTextLayoutRun

+ (CTRunDelegateRef)textLayoutRunWithAttachment:(id<WMGAttachMent>)att
{
    CTRunDelegateCallbacks callbacks;
    callbacks.version = kCTRunDelegateCurrentVersion;
    callbacks.dealloc = wmg_embeddedObjectDeallocCallback;
    callbacks.getAscent = wmg_embeddedObjectGetAscentCallback;
    callbacks.getDescent = wmg_embeddedObjectGetDescentCallback;
    callbacks.getWidth = wmg_embeddedObjectGetWidthCallback;
    return CTRunDelegateCreate(&callbacks, (void *)CFBridgingRetain(att));
}

void wmg_embeddedObjectDeallocCallback(void* context)
{
    CFBridgingRelease(context);
}


CGFloat wmg_embeddedObjectGetAscentCallback(void* context)
{
    
    // 询问是否有代理实现，默认是 20
    if ([(__bridge id)context conformsToProtocol:@protocol(WMGAttachMent)])
    {
        return [(__bridge id <WMGAttachMent>)context baselineFontMetrics].ascent;
    }
    return 20;
}

CGFloat wmg_embeddedObjectGetDescentCallback(void* context)
{
    if ([(__bridge id)context conformsToProtocol:@protocol(WMGAttachMent)])
    {
        return [(__bridge id <WMGAttachMent>)context baselineFontMetrics].descent;
    }
    return 5;
}

CGFloat wmg_embeddedObjectGetWidthCallback(void* context)
{
    if ([(__bridge id)context conformsToProtocol:@protocol(WMGAttachMent)])
    {
        return [(__bridge id <WMGAttachMent>)context placeholderSize].width;
    }
    return 25;
}

@end
