//
//  WMGTextDrawer.h
//  LYCoreTextApple
//
//  Created by 9tong on 2020/1/20.
//  Copyright © 2020 LY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

@class WMGTextLayout;
@class WMGTextAttachment;
@protocol WMGAttachment;
@protocol WMGActiveRange;



typedef BOOL (^WMGTextDrawerShouldInterruptBlock)(void);

@interface WMGTextDrawer : UIResponder

@property (nonatomic,assign) CGRect frame;

@end

@protocol WMGTextDrawerDelegate <NSObject>

@optional

/**
 *  textAttachment 渲染的回调方法，
 *  delegate 可以通过此方法定义 Attachment 的样式，具体显示的方式可以是绘制到 context 或者添加一个自定义 View
 *
 *  @param textDrawer   执行文字渲染的 textDrawer
 *  @param att          需要渲染的 TextAttachment
 *  @param frame        建议渲染到的 frame
 *  @param context      当前的 CGContext
 */
- (void)textDrawer:(WMGTextDrawer *)textDrawer replaceAttachment:(id <WMGAttachment>)att frame:(CGRect)frame context:(CGContextRef)context;

@end

@protocol WMGTextDrawerEventDelegate <NSObject>

@required
/**
 *  返回 textDrawer 处理事件时所基于的 view，用于确定坐标系等，必须
 *
 *  @param textDrawer 查询的 textDrawer
 *
 *  @return 处理事件时基于的 view
 */
- (UIView *)contextViewForTextDrawer:(WMGTextDrawer *)textDrawer;

/**
 *  返回定义 textDrawer 可点击区域的数组
 *
 *  @param textDrawer 查询的 textDrawer
 *
 *  @return 由 (id<WMGTextActiveRange>) 对象组成的数组
 */
- (NSArray *)activeRangesForTextDrawer:(WMGTextDrawer *)textDrawer;

/**
 *  响应对一个 activeRange 的点击事件
 *
 *  @param textDrawer 响应事件的 textDrawer
 *  @param activeRange  响应的 activeRange
 */
- (void)textDrawer:(WMGTextDrawer *)textDrawer didPressActiveRange:(id<WMGActiveRange>)activeRange;

@optional
/**
 *  activeRange点击的 高亮事件
 *
 *  @param textDrawer 响应事件的 textDrawer
 *  @param activeRange  响应的 activeRange
 */
- (void)textDrawer:(WMGTextDrawer *)textDrawer didHighlightedActiveRange:(id<WMGActiveRange>)activeRange rect:(CGRect)rect;

@optional
/**
 *  返回 textDrawer 是否要与一个 activeRange 进行交互，如点击操作
 *
 *  @param textDrawer 查询的 textDrawer
 *  @param activeRange  是否要与此 activeRange 进行交互
 *
 *  @return 是否与 activeRange 进行交互
 */
- (BOOL)textDrawer:(WMGTextDrawer *)textDrawer shouldInteractWithActiveRange:(id<WMGActiveRange>)activeRange;

@end



NS_ASSUME_NONNULL_END
