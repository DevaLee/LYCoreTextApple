//
//  WMGTextAttachment.h
//  LYCoreTextApple
//
//  Created by 9tong on 2020/1/21.
//  Copyright © 2020 LY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMGAttachment.h"

// 组件插入到AttributedString中的Key标识
extern NSString * const WMGTextAttachmentAttributeName;
// "\uFFFC"
extern NSString * const WMGTextAttachmentReplacementCharacter;

NS_ASSUME_NONNULL_BEGIN

@interface WMGTextAttachment : NSObject<WMGAttachMent>
/**
*  构建一个文本组件的类方法
*
* @param contents  文本组件表达的内容、样式
* @param type 文本组件类型
* @param size  该组件占用大小
*
*/
+ (instancetype)textAttachmentWithContent:(nullable id) contents type:(WMGAttachmentType) type size:(CGSize) size;

// 给每个文本组件设定对应的FontMetrics，默认为YES。框架会自动获取各个插入组件的Metrics信息
@property (nonatomic,assign) BOOL retriveFontMetricsAutomatically;

// 框架内部会在合适时机设置文本组件的展示Frame，注意！我们不需要指定该值~
@property (nonatomic, assign) CGRect layoutFrame;

@end


@interface NSAttributedString (WMGTextAttachment)

/**
*  遍历AttributedString中的所有文本组件
*
* @param block 参数1 attachment 文本组件对象 参数2 range 该文本组件处于AtrributedString中的Range
*
*/
- (void)wmg_enumerateTextAttachmentsWithBlock:(nullable void(^)(WMGTextAttachment *attachment, NSRange range, BOOL *stop))block;

/**
 *  根据文本组件创建一个对应的AttributedString
 *
 * @param attachment 文本组件
 *
 */
+ (instancetype)wmg_attributedStringWithTextAttachment:(WMGTextAttachment *)attachment;

@end

NS_ASSUME_NONNULL_END
