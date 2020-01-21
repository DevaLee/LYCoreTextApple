//
//  WMGTextDrawer+Private.h
//  LYCoreTextApple
//
//  Created by 9tong on 2020/1/21.
//  Copyright © 2020 LY. All rights reserved.
//

#import "WMGTextDrawer.h"

NS_ASSUME_NONNULL_BEGIN

@interface WMGTextDrawer ()
// 绘制原点，一般情况下，经过预排版之后，通过WMGTextDrawer的Frame设置，仅供框架内部使用，请勿直接操作
@property (nonatomic, assign) CGPoint drawOrigin;
@end

NS_ASSUME_NONNULL_END
