//
//  WMGraverMacroDefine.h
//  LYCoreTextApple
//
//  Created by 9tong on 2020/1/21.
//  Copyright © 2020 LY. All rights reserved.
//

#ifndef WMGraverMacroDefine_h
#define WMGraverMacroDefine_h


#ifdef WMGraverDebug
#define WMGLog(fmt, ...) NSLog((@"[graver-log]" fmt), ##__VA_ARGS__);
#else
#define WMGLog(...)
#endif

//字符串是否为空
#define IsStrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref)isEqualToString:@""]))
//数组是否为空
#define IsArrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref) count] == 0))

// sample: Designer - #FF0000, We - HEXCOLOR(0xFF0000)
#define WMGHEXCOLOR(hexValue)              [UIColor colorWithRed : ((CGFloat)((hexValue & 0xFF0000) >> 16)) / 255.0 green : ((CGFloat)((hexValue & 0xFF00) >> 8)) / 255.0 blue : ((CGFloat)(hexValue & 0xFF)) / 255.0 alpha : 1.0]

#endif /* WMGraverMacroDefine_h */
