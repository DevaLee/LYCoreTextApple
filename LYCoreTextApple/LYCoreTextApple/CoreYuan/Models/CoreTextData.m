//
//  CoreTextData.m
//  LYCoreTextApple
//
//  Created by 李玉臣 on 2020/1/16.
//  Copyright © 2020 LY. All rights reserved.
//

#import "CoreTextData.h"
#import "CoreTextImageData.h"

@implementation CoreTextData

-(void)setCtFrame:(CTFrameRef)ctFrame {
    if (_ctFrame != ctFrame) {
        if (_ctFrame != nil) {
            CFRelease(_ctFrame);
        }
        CFRetain(ctFrame);
        _ctFrame = ctFrame;
    }
}

-(void)dealloc {
    if (_ctFrame != nil) {
        CFRelease(_ctFrame);
        _ctFrame = nil;
    }
}

-(void)setImageArray:(NSArray *)imageArray {
    _imageArray = imageArray;
//    [self fillImagePosition];
}
// 计算图片的坐标
- (void)fillImagePosition {
    if (self.imageArray.count == 0) {
        return;
    }

    NSArray *lines = (NSArray *)CTFrameGetLines(_ctFrame);
    NSUInteger lineCount = [lines count];
    
    // 获取每一行的origin（起点）
    CGPoint lineOrigins[lineCount];
    CTFrameGetLineOrigins(self.ctFrame, CFRangeMake(0, 0), lineOrigins);

    int imgIndex = 0;
    CoreTextImageData *imageData = self.imageArray[0];

    for (int i = 0; i < lineCount; ++i) {
        if (imageData == nil) {
            break;
        }

        CTLineRef line = (__bridge CTLineRef)lines[i];
        // 获取CTLine中的CTRun
        NSArray *runObjArray = (NSArray *)CTLineGetGlyphRuns(line);
        NSLog(@"runObjArrayCount: %ld", runObjArray.count); // 2,1,4,2,3,1,1,3
        for (id runObj in runObjArray) {
            CTRunRef run = (__bridge CTRunRef)runObj;
            NSDictionary *runAttributes = (NSDictionary *)CTRunGetAttributes(run);
            
            //如果不是图片 则继续遍历
            CTRunDelegateRef delegate = (__bridge CTRunDelegateRef)[runAttributes valueForKey:(id)kCTRunDelegateAttributeName];
            if (delegate == nil) {
                continue;
            }
            // 取出图片信息
            NSDictionary *metaDic = CTRunDelegateGetRefCon(delegate);
            if (![metaDic isKindOfClass:[NSDictionary class]]) {
                continue;
            }

            CGRect runBounds;
            CGFloat ascent;
            CGFloat descent;

            runBounds.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL);
            runBounds.size.height = ascent + descent;

            CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
            runBounds.origin.x = lineOrigins[i].x + xOffset;
            runBounds.origin.y = lineOrigins[i].y;
            runBounds.origin.y -= descent;

            CGPathRef pathRef = CTFrameGetPath(self.ctFrame);
            CGRect colRect = CGPathGetBoundingBox(pathRef);

            CGRect delegateBounds = CGRectOffset(runBounds, colRect.origin.x, colRect.origin.y);

            imageData.imagePosition = delegateBounds;
            imgIndex++;

            if (imgIndex == self.imageArray.count) {
                imageData = nil;
                break;
            } else {
                imageData = self.imageArray[imgIndex];
            }

        }
    }

    
}
@end
