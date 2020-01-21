//
//  WMGContextAssisant.h
//  LYCoreTextApple
//
//  Created by 9tong on 2020/1/21.
//  Copyright © 2020 LY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import <CoreGraphics/CoreGraphics.h>
/**
 * 为上下文添加圆角区域
 *
 * @param context 上下文
 * @param rect 指定区域
 * @param radius 指定圆角
 *
 */
extern void wmg_context_add_round_rect(CGContextRef context, CGRect rect, CGFloat radius);

/**
 * 对上下文绘制区域进行圆角裁剪
 *
 * @param context 上下文
 * @param rect 指定区域
 * @param radius 指定圆角
 *
 */
extern void wmg_context_clip_to_round_rect(CGContextRef context, CGRect rect, CGFloat radius);

/**
 * 在指定区域进行圆角绘制
 *
 * @param context 上下文
 * @param rect 指定区域
 * @param radius 期望的圆角值
 *
 */
extern void wmg_context_fill_round_rect(CGContextRef context, CGRect rect, CGFloat radius);

/**
 * 梯度绘制
 */
extern void wmg_context_draw_linear_gradient_between_points(CGContextRef context, CGPoint a, CGFloat color_a[4], CGPoint b, CGFloat color_b[4]);

/**
 * 根据绘制区域、是否不透明创建一个图形上下文
 *
 * @param size 绘制区域的size
 * @param isOpaque 同系统CALayer的同名属性
 *
 * @return CGContextRef 上下文
 */
extern CGContextRef wmg_create_graphics_context(CGSize size, BOOL isOpaque);

/**
 * 获取位图上下文的Size
 *
 * @param ctx  上下文
 *
 * @return size
 */
extern CGSize wmg_bitmap_context_get_point_size(CGContextRef ctx);
