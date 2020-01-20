//
//  WMGTextLayout+Coordinate.h
//  LYCoreTextApple
//
//  Created by 9tong on 2020/1/20.
//  Copyright © 2020 LY. All rights reserved.
//



#import "WMGTextLayout.h"

NS_ASSUME_NONNULL_BEGIN

@interface WMGTextLayout (Coordinate)
/**
 * 将UIKit坐标系统的点转换到CoreText坐标系统的点
 *
 * @param point UIKit坐标系统的点
 *
 * @return CoreText坐标系统的点
 */
- (CGPoint)wmg_CTPointFromUIPoint:(CGPoint)point;

/**
 * 将CoreText坐标系统的点转换到UIKit坐标系统的点
 *
 * @param point CoreText坐标系统的点
 *
 * @return UIKit坐标系统的点
 */
- (CGPoint)wmg_UIPointFromCTPoint:(CGPoint)point;

/**
 * 将UIKit坐标系统的rect转换到CoreText坐标系统的rect
 *
 * @param rect UIKit坐标系统的rect
 *
 * @return CoreText坐标系统的rect
 */
- (CGRect)wmg_CTRectFromUIRect:(CGRect)rect;

/**
 * 将CoreText坐标系统的rect转换到UIKit坐标系统的rect
 *
 * @param rect CoreText坐标系统的rect
 *
 * @return UIKit坐标系统的rect
 */
- (CGRect)wmg_UIRectFromCTRect:(CGRect)rect;
@end

NS_ASSUME_NONNULL_END
