//
//  WMGTextDrawer.m
//  LYCoreTextApple
//
//  Created by 9tong on 2020/1/20.
//  Copyright © 2020 LY. All rights reserved.
//

#import "WMGTextDrawer.h"
#import "WMGTextLayout.h"
#import "WMGraverMacroDefine.h"
#import "WMGTextDrawer+Event.h"


@interface WMGTextDrawer ()
{
    CGPoint _drawOrigin;
    BOOL drawing;
}

@property (nonatomic, assign) CGPoint drawOrigin;
@property (nonatomic,strong) WMGTextLayout *textLayout;
@end

@implementation WMGTextDrawer

-(void)setFrame:(CGRect)frame {
    if (drawing && !CGSizeEqualToSize(frame.size, self.textLayout.size)) {
        WMGLog(@"draw error");
    }
    _drawOrigin = frame.origin;
    if (self.textLayout.heightSensitiveLayout) {
        self.textLayout.size = frame.size;
    }else {
        CGFloat height = ceil((frame.size.height * 1.1) / 10000) * 10000;
        self.textLayout.size = CGSizeMake(frame.size.width, height);
    }
}

- (CGRect)frame {
    return CGRectMake(_drawOrigin.x, _drawOrigin.y, self.textLayout.size.width, self.textLayout.size.height);
}

-(WMGTextLayout *)textLayout {
    if (!_textLayout) {
        _textLayout = [[WMGTextLayout alloc] init];
        _textLayout.heightSensitiveLayout = YES;
    }
    return _textLayout;
}

- (void)setDelegate:(id<WMGTextDrawerDelegate>)delegate
{
    if (_delegate != delegate) {
        _delegate = delegate;
        
        _delegateHas.placeAttachment = [delegate respondsToSelector:@selector(textDrawer:replaceAttachment:frame:context:)];
    }
}

- (void)setEventDelegate:(id<WMGTextDrawerEventDelegate>)eventDelegate
{
    if ([eventDelegate conformsToProtocol:@protocol(WMGTextDrawerEventDelegate)]) {
        _eventDelegate = eventDelegate;
        
        _eventDelegateHas.contextView = [eventDelegate respondsToSelector:@selector(contextViewForTextDrawer:)];
        _eventDelegateHas.activeRanges = [eventDelegate respondsToSelector:@selector(activeRangesForTextDrawer:)];
        _eventDelegateHas.didPressActiveRange = [eventDelegate respondsToSelector:@selector(textDrawer:didPressActiveRange:)];
        _eventDelegateHas.shouldInteractWithActiveRange = [eventDelegate respondsToSelector:@selector(textDrawer:shouldInteractWithActiveRange:)];
        _eventDelegateHas.didHighlightedActiveRange = [eventDelegate respondsToSelector:@selector(textDrawer:didHighlightedActiveRange:rect:)];
    }
}


@end
