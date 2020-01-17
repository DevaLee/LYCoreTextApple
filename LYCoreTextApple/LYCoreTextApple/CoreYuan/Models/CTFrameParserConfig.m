//
//  CTFrameParserConfig.m
//  LYCoreTextApple
//
//  Created by 李玉臣 on 2020/1/17.
//  Copyright © 2020 LY. All rights reserved.
//

#import "CTFrameParserConfig.h"

@implementation CTFrameParserConfig
-(instancetype)init {
    if (self = [super init]) {
        _width = 200.0;
        _fontSize = 16.0;
        _lineSpace = 8.0;
        _textColor = [UIColor grayColor];
    }
    return self;
}
@end
