//
//  CoreTextData.h
//  LYCoreTextApple
//
//  Created by 李玉臣 on 2020/1/16.
//  Copyright © 2020 LY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

/*
https://github.com/tangqiaoboy/iOS-Pro.git
 */

NS_ASSUME_NONNULL_BEGIN

@interface CoreTextData : NSObject

@property (assign, nonatomic) CTFrameRef ctFrame;
@property (assign, nonatomic) CGFloat height;
@property (strong, nonatomic) NSArray *imageArray;
@property (strong, nonatomic) NSArray *linkArray;
@property (strong, nonatomic) NSAttributedString *content;

@end

NS_ASSUME_NONNULL_END
