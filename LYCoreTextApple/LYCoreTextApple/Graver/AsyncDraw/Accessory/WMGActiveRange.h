//
//  WMGActiveRange.h
//  LYCoreTextApple
//
//  Created by 9tong on 2020/1/21.
//  Copyright © 2020 LY. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, WMGActiveRangeType)
{
    WMGActiveRangeTypeUnknow         = 0,
    WMGActiveRangeTypeURL            = 1,
    WMGActiveRangeTypeEmail          = 2,
    WMGActiveRangeTypePhone          = 3,
    WMGActiveRangeTypeAttachment     = 4,
    WMGActiveRangeTypeText           = 5,
};

/*
 激活区，定义了混排图文中可相应点击的组件
 */
@protocol WMGActiveRange <NSObject>

// 激活区类型 现仅有Attachment使用
@property (nonatomic, assign) WMGActiveRangeType type;

// 标识激活区在AttributedString中的位置
@property (nonatomic, assign) NSRange range;

// 如果是可点击文本，代表该文本内容
@property (nonatomic, copy) NSString *text;

// 涉及处理的相关数据
@property (nonatomic, strong) id bindingData;

@end
