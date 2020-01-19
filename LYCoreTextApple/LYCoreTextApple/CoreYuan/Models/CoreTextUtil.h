//
//  CoreTextUtil.h
//  LYCoreTextApple
//
//  Created by 9tong on 2020/1/17.
//  Copyright © 2020 LY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CoreTextData.h"
#import "CoreTextLinkData.h"
NS_ASSUME_NONNULL_BEGIN

@interface CoreTextUtil : NSObject

+ (CFIndex)touchContentOffsetInView:(UIView *)view
                            atPoint:(CGPoint)point
                               data:(CoreTextData *)data;

+ (CoreTextLinkData *)touchLinkInView:(UIView *)view atPoint:(CGPoint)point data:(CoreTextData *)data;
@end

NS_ASSUME_NONNULL_END
