//
//  NSMutableAttributedString+GTextProperty.h
//  LYCoreTextApple
//
//  Created by 9tong on 2020/1/20.
//  Copyright © 2020 LY. All rights reserved.
//


#import <Foundation/Foundation.h>
extern NSString * const WMGTextStrikethroughStyleAttributeName;
extern NSString * const WMGTextStrikethroughColorAttributeName;
extern NSString * const WMGTextDefaultForegroundColorAttributeName;

typedef NS_ENUM(NSUInteger, WMGTextAlignment)
{
    WMGTextAlignmentLeft = 0,
    WMGTextAlignmentCenter,
    WMGTextAlignmentRight,
    WMGTextAlignmentJustified,
};

typedef NS_ENUM(NSUInteger, WMGTextLigature)
{
    WMGTextLigatureProperRendering = 0,
    WMGTextLigatureDefault = 1,
    WMGTextLigatureAllAvailable = 2,
};

typedef NS_ENUM(NSUInteger, WMGTextUnderlineStyle)
{
    WMGTextUnderlineStyleNone = 0x00,
    WMGTextUnderlineStyleSingle = 0x01,
    WMGTextUnderlineStyleThick = 0x02,
    WMGTextUnderlineStyleDouble = 0x09
};

typedef NS_ENUM(NSUInteger, WMGTextStrikeThroughStyle)
{
    WMGTextStrikeThroughStyleNone = 0x00,
    WMGTextStrikeThroughStyleSingle = 0x01,
    WMGTextStrikeThroughStyleThick = 0x02,
};

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableAttributedString (GTextProperty)

@end

NS_ASSUME_NONNULL_END
