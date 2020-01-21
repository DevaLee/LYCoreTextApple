//
//  UIImage+Graver.h
//  LYCoreTextApple
//
//  Created by 9tong on 2020/1/21.
//  Copyright © 2020 LY. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import <CoreGraphics/CoreGraphics.h>


/**
 WMGCornerRadius
 
 定义圆角的左上，右上，左下，右下四个位置的圆角半径值
 */
typedef struct WMGCornerRadius {
    CGFloat topLeft, topRight, bottomLeft, bottomRight;
} WMGCornerRadius;

//const WMGCornerRadius WMGCornerRadiusZero = {0.0, 0.0, 0.0, 0.0};

UIKIT_STATIC_INLINE WMGCornerRadius WMGCornerRadiusMake(CGFloat topLeft, CGFloat topRight, CGFloat bottomLeft, CGFloat bottomRight) {
    WMGCornerRadius radius = {topLeft, topRight, bottomLeft, bottomRight};
    return radius;
}
UIKIT_STATIC_INLINE BOOL WMGCornerRadiusEqual(WMGCornerRadius r1, WMGCornerRadius r2)
{
    return r1.topLeft == r2.topLeft && r1.topRight == r2.topRight && r1.bottomLeft == r2.bottomLeft && r1.bottomRight == r2.bottomRight;
}

UIKIT_STATIC_INLINE BOOL WMGCornerRadiusIsPerfect(WMGCornerRadius r)
{
    return r.topLeft == r.topRight && r.bottomLeft == r.bottomRight && r.topLeft == r.bottomLeft;
}

UIKIT_STATIC_INLINE WMGCornerRadius WMGCornerPerfectRadius(CGFloat r)
{
    return WMGCornerRadiusMake(r, r, r, r);
}

UIKIT_STATIC_INLINE BOOL WMGCornerRadiusIsValid(WMGCornerRadius r)
{
    return r.topLeft > 0.0 || r.topRight > 0.0 || r.bottomLeft > 0.0 || r.bottomRight > 0.0;
}

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Graver)

/**
 * 创建一张图片
 *
 * @param color         图片颜色
 * @param size          图片size
 * @param width         border宽度
 * @param borderColor   border颜色
 * @param radius        圆角半径 CGFloat
 *
 * @discussion          该方法可以创建一站矩形纯色图片，带边框、带圆角、底色透明，边框带线条的各种样式
 *
 * @return UIImage
 */
+ (UIImage *)wmg_imageWithColor:(UIColor *)color size:(CGSize)size borderWidth:(CGFloat)width borderColor:(UIColor *)borderColor cornerRadius:(CGFloat)radius;


/**
 * 图片裁剪
 *
 * @param croppedSize      裁剪size
 * @param contentMode      内容模式
 * @param quality          质量参数
 *
 * @return UIImage
 */
- (UIImage *)wmg_cropImageWithCroppedSize:(CGSize)croppedSize contentMode:(UIViewContentMode)contentMode interpolationQuality:(CGInterpolationQuality)quality;

- (UIImage *)wmg_blurImageWithBlurPercent:(CGFloat)percent;

- (UIImage *)wmg_roundedImageWithCornerRadius:(WMGCornerRadius)radius;

@end

NS_ASSUME_NONNULL_END
