//
//  WMGTextLayoutRun.h
//  LYCoreTextApple
//
//  Created by 9tong on 2020/1/19.
//  Copyright © 2020 LY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMGAttachment.h"
NS_ASSUME_NONNULL_BEGIN

@interface WMGTextLayoutRun : NSObject

+ (CTRunDelegateRef)textLayoutRunWithAttachment:(id<WMGAttachMent>)att;
@end

NS_ASSUME_NONNULL_END
