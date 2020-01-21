//
//  WMGImage.m
//  LYCoreTextApple
//
//  Created by 9tong on 2020/1/21.
//  Copyright © 2020 LY. All rights reserved.
//

#import "WMGImage.h"
#import "WMGraverMacroDefine.h"
#import "UIImage+Graver.h"



@implementation WMGImage
+ (WMGImage *)imageWithNamed:(NSString *)imgname {
    if (IsStrEmpty(imgname)) {
        return  nil;
    }
    
    WMGImage *ctImage = [[WMGImage alloc] init];
    ctImage.placeholderName = imgname;
    
    return ctImage;
}

+(WMGImage *)imageWithImage:(UIImage *)image {
    if (image == nil) {
        return nil;
    }
    
      WMGImage *ctImage = [[WMGImage alloc] init];
      ctImage.image = image;
      
      return ctImage;
}

+ (WMGImage *)imageWithUrl:(NSString *)imgUrl
{
    if (IsStrEmpty(imgUrl)) {
        return nil;
    }
    WMGImage *ctImage = [[WMGImage alloc] init];
    ctImage.downloadUrl = imgUrl;
    
    return ctImage;
}

- (void)wmg_loadImageWithUrl:(NSString *)urlStr options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDExternalCompletionBlock)completion
{
    NSURL *url = [NSURL URLWithString:urlStr];
    
    if (url) {
        __weak typeof(self) wself = self;
        [[SDWebImageManager sharedManager] loadImageWithURL:url options:options progress:progressBlock completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            
            void(^block)(UIImage *, NSError *, SDImageCacheType , BOOL , NSURL *) = ^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL){
                wself.downloadUrl = nil;
                if (!wself) return;
                if (image) {
                    wself.image = image;
                }
                if (completion && finished) {
                    completion(image, error, cacheType, url);
                }
            };
            
            CGFloat scale = [UIScreen mainScreen].scale;
            
            CGSize imageSize = CGSizeMake(self.size.width * scale, self.size.height * scale);
            UIViewContentMode contentMode = self.contentMode;
            
            CGFloat percent = self.blurPercent / 100.00;
            
            WMGCornerRadius radius = WMGCornerRadiusMake(self.radius.topLeft * scale, self.radius.topRight * scale, self.radius.bottomLeft * scale, self.radius.bottomRight * scale);
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                // 裁剪处理
                UIImage *newImage = [image wmg_cropImageWithCroppedSize:imageSize contentMode:contentMode interpolationQuality:kCGInterpolationHigh];
                
                // 模糊处理
                if (percent >= 0.01) {
                    newImage = [newImage wmg_blurImageWithBlurPercent:percent];
                }
                
                // 圆角处理
                WMGCornerRadius zero = {0, 0, 0, 0};
                if (!WMGCornerRadiusEqual(radius, zero)){
                    newImage = [newImage wmg_roundedImageWithCornerRadius:radius];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(newImage, error, cacheType, finished, imageURL);
                });
            });
            
        }];
    } else {
        self.downloadUrl = nil;
        NSError *error = [NSError errorWithDomain:SDWebImageErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey : @"Trying to load a nil url"}];
        if (completion) {
            completion(nil, error, SDImageCacheTypeNone, url);
        }
    }
}
@end
