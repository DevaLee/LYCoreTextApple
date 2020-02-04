//
//  WMGTextDrawer+Coordinate.h
//  LYCoreTextApple
//
//  Created by 9tong on 2020/1/20.
//  Copyright © 2020 LY. All rights reserved.
//


#import "WMGTextDrawer.h"

NS_ASSUME_NONNULL_BEGIN

@interface WMGTextDrawer (Coordinate)

/**
 *  将坐标点从文字布局中转换到 TextDrawer 的绘制区域中
 *
 *  @param point 需要转换的坐标点
 *
 *  @return 转换过的坐标点
 */
- (CGPoint)convertPointFromLayout:(CGPoint)point offsetPoint:(CGPoint)offsetPoint;

/**
 *  将坐标点从 TextDrawer 的绘制区域转换到文字布局中
 *
 *  @param point 需要转换的坐标点
 *
 *  @return 转换过的坐标点
 */
- (CGPoint)convertPointToLayout:(CGPoint)point offsetPoint:(CGPoint)offsetPoint;

/**
 *  将一个 rect 从文字布局中转换到 TextDrawer 的绘制区域中
 *
 *  @param rect 需要转换的 rect
 *
 *  @return 转换后的 rect
 */
- (CGRect)convertRectFromLayout:(CGRect)rect offsetPoint:(CGPoint)offsetPoint;

/**
 *  将一个 rect 从 TextDrawer 的绘制区域转换到文字布局中
 *
 *  @param rect 需要转换的 rect
 *
 *  @return 转换后的 rect
 */
- (CGRect)convertRectToLayout:(CGRect)rect offsetPoint:(CGPoint)offsetPoint;
@end

NS_ASSUME_NONNULL_END
