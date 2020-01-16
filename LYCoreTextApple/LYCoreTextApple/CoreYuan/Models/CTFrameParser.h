//
//  CTFrameParser.h
//  LYCoreTextApple
//
//  Created by 李玉臣 on 2020/1/17.
//  Copyright © 2020 LY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreTextData.h"
#import "CTFrameParserConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface CTFrameParser : NSObject
+ (NSMutableDictionary *)attributesWithConfig:(CTFrameParserConfig *)config;

@end

NS_ASSUME_NONNULL_END
