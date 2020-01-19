//
//  CTCustomView.h
//  LYCoreTextApple
//
//  Created by 9tong on 2020/1/19.
//  Copyright © 2020 LY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CTCustomViewDelegate <NSObject>

- (CGContextRef)currentContext;

@end


@interface CTCustomView : UIView

@end

NS_ASSUME_NONNULL_END
