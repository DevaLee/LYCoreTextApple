//
//  CTFrameParserConfig.h
//  LYCoreTextApple
//
//  Created by 李玉臣 on 2020/1/17.
//  Copyright © 2020 LY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CTFrameParserConfig : NSObject
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, assign) CGFloat lineSpace;
@property (nonatomic, strong) UIColor *textColor;


@end

NS_ASSUME_NONNULL_END
