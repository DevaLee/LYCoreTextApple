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

- (CGPoint) convertPointFromLayout:(CGPoint)point offsetPoint:(CGPoint)offsetPoint;
@end

NS_ASSUME_NONNULL_END
