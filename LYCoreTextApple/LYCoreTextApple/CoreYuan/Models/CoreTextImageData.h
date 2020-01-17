//
//  CoreTextImageData.h
//  LYCoreTextApple
//
//  Created by 李玉臣 on 2020/1/16.
//  Copyright © 2020 LY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface CoreTextImageData : NSObject

@property (strong, nonatomic) NSString *name;
// 图片的起始位置
@property (assign,nonatomic) int position;
// 此坐标是 CoreText 的坐标系，而不是UIKit的坐标系
@property (nonatomic) CGRect imagePosition;
@end

NS_ASSUME_NONNULL_END
