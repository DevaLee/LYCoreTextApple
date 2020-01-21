//
//  UIImage+Graver.m
//  LYCoreTextApple
//
//  Created by 9tong on 2020/1/21.
//  Copyright © 2020 LY. All rights reserved.
//

#import "UIImage+Graver.h"
#import "UIBezierPath+Graver.h"
#import <QuartzCore/QuartzCore.h>
#import <Accelerate/Accelerate.h>
#import "WMGraverMacroDefine.h"




@implementation UIImage (Graver)

- (UIImage *)wmg_roundedImageWithCornerRadius:(WMGCornerRadius)radius
{
    if (!WMGCornerRadiusIsValid(radius)) {
        return self;
    }
    
    CGFloat w = self.size.width;
    CGFloat h = self.size.height;
    CGFloat scale = [UIScreen mainScreen].scale;
    
    UIImage *image = nil;
    CGRect rect = CGRectMake(0., 0., w, h);
    UIGraphicsBeginImageContextWithOptions(self.size, NO, scale);
    UIBezierPath *topLeftCornerPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerTopLeft cornerRadii:CGSizeMake(radius.topLeft, radius.topLeft)];
    [topLeftCornerPath addClip];
    
    UIBezierPath *topRightCornerPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerTopRight cornerRadii:CGSizeMake(radius.topRight, radius.topRight)];
    [topRightCornerPath addClip];
    
    UIBezierPath *bottomLeftCornerPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerBottomLeft cornerRadii:CGSizeMake(radius.bottomLeft, radius.bottomLeft)];
    [bottomLeftCornerPath addClip];
    
    UIBezierPath *bottomRightCornerPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerBottomRight cornerRadii:CGSizeMake(radius.bottomRight, radius.bottomRight)];
    [bottomRightCornerPath addClip];
    
    [self drawInRect:rect];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)wmg_blurImageWithBlurPercent:(CGFloat)percent
{
    // hack, helps w/ our colors when blurring
    NSData *imageData = UIImageJPEGRepresentation(self, 1); // convert to jpeg
    UIImage *destImage = [UIImage imageWithData:imageData];
    
    if (percent < 0.f || percent > 1.f) {
        percent = 0.5f;
    }
    
    int boxSize = (int)(percent * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = destImage.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    
    vImage_Error error;
    
    void *pixelBuffer;
    
    //create vImage_Buffer with data from CGImageRef
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    //create vImage_Buffer for output
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    if(pixelBuffer == NULL)
        WMGLog(@"No pixelbuffer");
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    // Create a third buffer for intermediate processing
    void *pixelBuffer2 = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    vImage_Buffer outBuffer2;
    outBuffer2.data = pixelBuffer2;
    outBuffer2.width = CGImageGetWidth(img);
    outBuffer2.height = CGImageGetHeight(img);
    outBuffer2.rowBytes = CGImageGetBytesPerRow(img);
    
    //perform convolution
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer2, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        WMGLog(@"error from convolution %ld", error);
    }
    error = vImageBoxConvolve_ARGB8888(&outBuffer2, &inBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        WMGLog(@"error from convolution %ld", error);
    }
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        WMGLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             (CGBitmapInfo)kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    free(pixelBuffer2);
    CFRelease(inBitmapData);
    
    CGImageRelease(imageRef);
    
    return returnImage;
}


+ (UIImage *)wmg_imageWithColor:(UIColor *)color size:(CGSize)size borderWidth:(CGFloat)width borderColor:(UIColor *)borderColor cornerRadius:(CGFloat)radius {
    
    return [self wmg_imageWithColor:color size:size borderWidth:width borderColor:borderColor borderRadius:WMGCornerPerfectRadius(radius)];
}


+ (UIImage *)wmg_imageWithColor:(UIColor *)color size:(CGSize)size borderWidth:(CGFloat) width borderColor:(UIColor *)borderColor borderRadius:(WMGCornerRadius)radius {
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (!context) {
        return nil;
    }
    
   if (!WMGCornerRadiusIsValid(radius))
    {
        CGContextSetFillColorWithColor(context, [color CGColor]);
        CGContextFillRect(context, rect);
        
        if(width > 0)
        {
            UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
            CGContextAddPath(context, path.CGPath);
            CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
            CGContextSetLineWidth(context, width);
            CGContextDrawPath(context, kCGPathFillStroke);
        }
    }
    else
    {
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        CGContextFillRect(context, rect);
        
        UIBezierPath *path = [UIBezierPath wmg_bezierPathWithRect:rect cornerRadius:radius lineWidth:width];
        [path setUsesEvenOddFillRule:YES];
        [path addClip];
        CGContextAddPath(context, path.CGPath);
        
        CGContextSetFillColorWithColor(context, [color CGColor]);
        CGContextFillRect(context, rect);
        
        CGContextAddPath(context, path.CGPath);
        
        if (width > 0.0)
        {
            CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
            CGContextSetLineWidth(context, width);
            CGContextDrawPath(context, kCGPathFillStroke);
        }
        else
        {
            CGContextDrawPath(context, kCGPathFill);
        }
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
    
}

- (UIImage *)wmg_cropImageWithCroppedSize:(CGSize)croppedSize contentMode:(UIViewContentMode)contentMode interpolationQuality:(CGInterpolationQuality)quality
{
    UIImage *resizedImage = [self wmg_resizedImageWithContentMode:contentMode
                                                            bounds:croppedSize
                                              interpolationQuality:quality];
    
    // Crop out any part of the image that's larger than the thumbnail size
    // The cropped rect must be centered on the resized image
    // Round the origin points so that the size isn't altered when CGRectIntegral is later invoked
    CGRect cropRect = CGRectMake(round((resizedImage.size.width - croppedSize.width) / 2),
                                 round((resizedImage.size.height - croppedSize.height) / 2),
                                 croppedSize.width,
                                 croppedSize.height);
    UIImage *croppedImage = [resizedImage wmg_croppedImage:cropRect];
    
    return croppedImage;
}

// Returns a copy of this image that is cropped to the given bounds.
// The bounds will be adjusted using CGRectIntegral.
// This method ignores the image's imageOrientation setting.
- (UIImage *)wmg_croppedImage:(CGRect)bounds
{
    bounds = CGRectMake(bounds.origin.x * self.scale, bounds.origin.y * self.scale, bounds.size.width * self.scale, bounds.size.height * self.scale);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], bounds);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return croppedImage;
}

- (UIImage *)wmg_resizedImageWithContentMode:(UIViewContentMode)contentMode
                                       bounds:(CGSize)bounds
                         interpolationQuality:(CGInterpolationQuality)quality
{
    CGFloat horizontalRatio = bounds.width / self.size.width;
    CGFloat verticalRatio = bounds.height / self.size.height;
    CGFloat ratio;
    
    CGSize newSize ;
    if (contentMode == UIViewContentModeScaleAspectFill) {
        ratio = MAX(horizontalRatio, verticalRatio);
        newSize = CGSizeMake(roundf(self.size.width * ratio), roundf(self.size.height * ratio));
    }
    else if (contentMode == UIViewContentModeScaleAspectFit){
        ratio = MIN(horizontalRatio, verticalRatio);
        newSize = CGSizeMake(roundf(self.size.width * ratio), roundf(self.size.height * ratio));
    }
    else if (contentMode == UIViewContentModeScaleToFill){
        newSize = CGSizeMake(roundf(self.size.width * horizontalRatio), roundf(self.size.height * verticalRatio));
    }
    else{
        return self;
    }
    
    return [self wmg_resizedImage:newSize interpolationQuality:quality];
}


- (UIImage *)wmg_resizedImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality
{
    BOOL drawTransposed;
    
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            drawTransposed = YES;
            break;
            
        default:
            drawTransposed = NO;
    }
    
    return [self wmg_resizedImage:newSize
                         transform:[self wmg_transformForOrientation:newSize]
                    drawTransposed:drawTransposed
              interpolationQuality:quality];
}

- (CGAffineTransform)wmg_transformForOrientation:(CGSize)newSize
{
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:           // EXIF = 3
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, newSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:           // EXIF = 6
        case UIImageOrientationLeftMirrored:   // EXIF = 5
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:          // EXIF = 8
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, 0, newSize.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
            
        default:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:     // EXIF = 2
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:   // EXIF = 5
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, newSize.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        default:
            break;
    }
    
    return transform;
}


- (UIImage *)wmg_resizedImage:(CGSize)newSize
           transform:(CGAffineTransform)transform
      drawTransposed:(BOOL)transpose
         interpolationQuality:(CGInterpolationQuality)quality {
    
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGRect transposedRect = CGRectMake(0, 0, newRect.size.height, newRect.size.width);
    CGImageRef imageRef = self.CGImage;
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                newRect.size.width,
                                                newRect.size.height,
                                                8, newRect.size.width * 4,
                                                rgbColorSpace,
                                                (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(rgbColorSpace);
    
    CGRect rect = CGRectMake(0, 0, newRect.size.width, newRect.size.height);
    CGContextSetFillColorWithColor(bitmap, [UIColor whiteColor].CGColor);
    CGContextFillRect(bitmap, rect);
    
    CGContextConcatCTM(bitmap, transform);
    
    CGContextSetInterpolationQuality(bitmap, quality);
    
    CGContextDrawImage(bitmap, transpose ? transposedRect : newRect, imageRef);
    
    CGImageRef newImageRef = CGBitmapContextCreateImage(bitmap);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    CGContextRelease(bitmap);
    CGImageRelease(newImageRef);
    
    return newImage;
}

@end
