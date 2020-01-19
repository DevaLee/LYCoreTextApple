//
//  WMGFontMetrics.m
//  LYCoreTextApple
//
//  Created by 9tong on 2020/1/19.
//  Copyright © 2020 LY. All rights reserved.
//

#import "WMGFontMetrics.h"

const WMGFontMetrics WMGFontMetricsZero = {0, 0, 0};
const WMGFontMetrics WMGFontMetricsNull = {NSNotFound, NSNotFound, NSNotFound};

static WMGFontMetrics WMGCachedFontMetrics[13];

//WMGFontMetrics WMGFontDefaultMetrics(NSInteger pointSize) {
//    if (pointSize < 8 || pointSize > 20) {
//        UIFont *font = [UIFont systemFontOfSize:pointSize];
//    
//    }
//}

