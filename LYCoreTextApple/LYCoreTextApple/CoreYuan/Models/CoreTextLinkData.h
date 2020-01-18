//
//  CoreTextLinkData.h
//  LYCoreTextApple
//
//  Created by 李玉臣 on 2020/1/17.
//  Copyright © 2020 LY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CoreTextLinkData : NSObject
@property(strong, nonatomic) NSString *title;
@property(strong, nonatomic) NSString *url;
@property(assign, nonatomic) NSRange range;
@end

NS_ASSUME_NONNULL_END
