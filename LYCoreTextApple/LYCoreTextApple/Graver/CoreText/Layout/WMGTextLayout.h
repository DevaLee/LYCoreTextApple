//
//  WMGTextLayout.h
//  LYCoreTextApple
//
//  Created by 9tong on 2020/1/19.
//  Copyright © 2020 LY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMGFontMetrics.h"

NS_ASSUME_NONNULL_BEGIN


extern CGFloat const WMGTextLayoutMaximumWidth;
extern CGFloat const WMGTextLayoutMaximumHeight;

@class WMGTextLayout;

@protocol WMGTextLayoutDelegate <NSObject>

/**
 * 当发生截断时，获取截断行的高度
 *
 * @param textLayout 排版模型
 * @param lineRef CTLineRef类型，截断行
 * @param index 截断行的行索引号
 *
 */
@optional
- (CGFloat)textLayout:(WMGTextLayout *)textLayout maximumWidthForTruncatedLine:(CTLineRef)lineRef atIndex:(NSUInteger)index;

@end

@interface WMGTextLayout : NSObject
// 待排版的AttributeString
@property (nonatomic,strong) NSAttributedString *attributeString;
// 可排版的区域
@property (nonatomic,assign) CGSize size;
// 最大排版数，默认为0，即不限制排版行数
@property (nonatomic,assign) NSUInteger maximumNumberOfLines;
// 是否自动获取画 baseLineMetrics, 如果为YES，将第一行的 fontMetrics 作为 baselineFontMetrics
@property (nonatomic,assign) BOOL retriveFontMetricsAutomatically;
// 待排版的AttributedString的基线FontMetrics，当retriveFontMetricsAutomatically=YES时，该值框架内部会自动获取
@property (nonatomic,assign) WMGFontMetrics baselineFontMetrics;
// 布局受高度限制，如自动截断超过高度的部分，默认为YES
@property (nonatomic,assign) BOOL heightSensitiveLayout;
// 如果发生截断，由truncationString指定截断显示内容，默认"..."
@property (nonatomic,strong) NSAttributedString *truncationString;
// 排版模型的代理
@property (nonatomic,weak) id<WMGTextLayoutDelegate> delegate;

// 标记当前排版结果需要更新
- (void)setNeedsLayout;

@end

NS_ASSUME_NONNULL_END
