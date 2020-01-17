//
//  CTDisplayView.h
//  LYCoreTextApple
//
//  Created by 9tong on 2020/1/17.
//  Copyright © 2020 LY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreTextData.h"

NS_ASSUME_NONNULL_BEGIN

@interface CTDisplayView : UIView
@property (nonatomic,strong) CoreTextData *data;
@end

NS_ASSUME_NONNULL_END
