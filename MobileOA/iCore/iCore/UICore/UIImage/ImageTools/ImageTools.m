//
//  MTUImage.m
//  MTFoundation
//
//  Created by 任清阳 on 2016/9/7.
//  Copyright © 2016年 Mtime. All rights reserved.
//

#import "ImageTools.h"

@implementation ImageTools

#pragma mark - 预先生成圆角图片，直接渲染到UIImageView中去，相比直接在UIImageView.layer中去设置圆角，可以缩短渲染时间。
#pragma mark - 在原图的四周生成圆角，得到带圆角的图片

+ (UIImage *)i_getCornerImageAtOriginalImageCornerWithImage:(UIImage *)img
                                                cornerRadius:(CGFloat)radius
                                             backGroundColor:(UIColor *)backgroundColor
{
    UIGraphicsBeginImageContextWithOptions(img.size, NO, 0.0);

    CGRect bounds = CGRectMake(0, 0, img.size.width, img.size.height);

    CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);

    [backgroundColor set];

    UIRectFill(bounds);

    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius] addClip];

    [img drawInRect:bounds];

    UIImage *imageCorner = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return imageCorner;
}

#pragma mark - 根据Size生成圆角图片，图片会拉伸-变形

+ (UIImage *)i_getCornerImageFitSize:(CGSize)size
                                image:(UIImage *)img
                         cornerRadius:(CGFloat)radius
                      backGroundColor:(UIColor *)backgroundColor
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);

    CGRect bounds = CGRectMake(0, 0, size.width, size.height);

    CGRect rect = CGRectMake(0, 0, size.width, size.height);

    [backgroundColor set];

    UIRectFill(bounds);

    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius] addClip];

    [img drawInRect:bounds];


    UIImage *cornerImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return cornerImage;
}

#pragma mark - 根据Size生成圆角图片，图片会自适应填充，伸展范围以外的部分会被裁剪掉-不会变形

+ (UIImage *)i_getCornerImageFillSize:(CGSize)size
                                 image:(UIImage *)img
                          cornerRadius:(CGFloat)radius
                       backGroundColor:(UIColor *)backgroundColor
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);

    /// 图片宽高比
    CGFloat imageAspectRatio = img.size.width / img.size.height;

    /// 显示size的宽高比
    CGFloat sizeAspectRatio = size.width / size.height;

    CGRect bounds;

    /// 图片宽高比大于size的宽高比
    if (imageAspectRatio > sizeAspectRatio)
    {
        /// 获取需要剪裁比例，已高度比为准
        CGFloat heightRatio = size.height / img.size.height;

        /// 计算剪裁后的高度
        CGFloat height = img.size.height * heightRatio;

        CGFloat width = height * imageAspectRatio;

        CGFloat x = -(width - size.width) / 2;

        CGFloat y = 0;

        bounds = CGRectMake(x, y, width, height);
    }
    else
    {
        /// 获取需要剪裁比例，已宽度比为准
        CGFloat floatWidthRatio = size.width / img.size.width;

        /// 计算剪裁后的宽度
        CGFloat width = img.size.width * floatWidthRatio;

        CGFloat height = width / imageAspectRatio;

        CGFloat x = 0;

        CGFloat y = -(height - size.height) / 2;

        bounds = CGRectMake(x, y, width, height);
    }

    CGRect rect = CGRectMake(0, 0, size.width, size.height);

    [backgroundColor set];

    UIRectFill(bounds);

    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius] addClip];

    [img drawInRect:bounds];

    UIImage *imageCorner = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return imageCorner;
}

#pragma mark - 缩略图

+ (UIImage *)i_getThumbImageWithImage:(UIImage *)img
                                  size:(CGSize)size
                               isScale:(BOOL)isScale
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);

    CGRect rect = CGRectMake(0, 0, size.width, size.height);

    if (!isScale)
    {
        /// 图片宽高比
        CGFloat imageAspectRatio = img.size.width / img.size.height;

        /// 显示size的宽高比
        CGFloat sizeAspectRatio = size.width / size.height;

        /// 图片宽高比大于size的宽高比，做图片剪裁
        if (imageAspectRatio > sizeAspectRatio)
        {
            /// 获取需要剪裁比例，已高度比为准
            CGFloat heightRatio = size.height / img.size.height;

            /// 计算剪裁后的高度
            CGFloat height = img.size.height * heightRatio;

            CGFloat width = height * imageAspectRatio;

            CGFloat x = -(width - size.width) / 2;

            CGFloat y = 0;

            rect = CGRectMake(x, y, width, height);
        }
        else
        {
            /// 获取需要剪裁比例，已宽度比为准
            CGFloat floatWidthRatio = size.width / img.size.width;

            /// 计算剪裁后的宽度
            CGFloat width = img.size.width * floatWidthRatio;

            CGFloat height = width / imageAspectRatio;

            CGFloat x = 0;

            CGFloat y = -(height - size.height) / 2;

            rect = CGRectMake(x, y, width, height);
        }
    }

    [[UIColor clearColor] set];

    UIRectFill(rect);

    [img drawInRect:rect];

    UIImage *imageThumb = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return imageThumb;
}

#pragma mark - 水印

+ (UIImage *)i_getWaterPrintedImageWithBackImage:(UIImage *)backImg
                                       waterImage:(UIImage *)waterImg
                                           inRect:(CGRect)rect
                                            alpha:(CGFloat)alpha
                                     isWaterScale:(BOOL)isWaterScale
{
    /*
     在最后UIImageView转UIImage的时候，View属性的size会压缩成1倍像素的size,所以本方法内涉及到Size的地方需要乘以屏幕密度，才能保证最后的清晰度
     */

    UIImageView *backImageView = [[UIImageView alloc] init];

    backImageView.backgroundColor = [UIColor clearColor];

    backImageView.frame = CGRectMake(0, 0, backImg.size.width * [UIScreen mainScreen].scale, backImg.size.height * [UIScreen mainScreen].scale);

    backImageView.contentMode = UIViewContentModeScaleAspectFill;
    backImageView.image = backImg;

    UIImageView *waterImageView = [[UIImageView alloc] init];

    waterImageView.backgroundColor = [UIColor clearColor];

    waterImageView.frame = CGRectMake(rect.origin.x * [UIScreen mainScreen].scale,
                                      rect.origin.y * [UIScreen mainScreen].scale,
                                      rect.size.width * [UIScreen mainScreen].scale,
                                      rect.size.height * [UIScreen mainScreen].scale);

    /// 是否改变长宽比
    if (isWaterScale)
    {
        waterImageView.contentMode = UIViewContentModeScaleToFill;
    }
    else
    {
        waterImageView.contentMode = UIViewContentModeScaleAspectFill;
    }

    waterImageView.alpha = alpha;

    waterImageView.image = waterImg;

    [backImageView addSubview:waterImageView];

    UIImage *imageOut = [self i_imageWithUIView:backImageView];

    return imageOut;
}

#pragma mark - 裁剪

+ (UIImage *)i_cutImageWithImage:(UIImage *)img
                          atPoint:(CGPoint)point
                             size:(CGSize)size
                  backgroundColor:(UIColor *)backgroundColor
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);

    CGRect bounds = CGRectMake(0, 0, size.width, size.height);

    CGRect rect = CGRectMake(-point.x, -point.y, img.size.width, img.size.height);

    [backgroundColor set];

    UIRectFill(bounds);

    [img drawInRect:rect];

    UIImage *cutImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return cutImage;
}

#pragma mark - 根据遮罩图形状裁剪

+ (UIImage *)i_creatImageWithMaskImage:(UIImage *)maskImg
                              backImage:(UIImage *)backImg
{
    CGRect rect;

    /// 设置居中显示
    if (backImg.size.height > backImg.size.width)
    {
        rect = CGRectMake(0,
                          (backImg.size.height - backImg.size.width),
                          backImg.size.width,
                          backImg.size.width);
    }
    else
    {
        rect = CGRectMake((backImg.size.width - backImg.size.height),
                          0,
                          backImg.size.height,
                          backImg.size.height);
    }

    UIImage *cutImage = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([backImg CGImage], rect)];

    /// 遮罩图
    CGImageRef maskImageRef = maskImg.CGImage;
    /// 原图
    CGImageRef originImageRef = cutImage.CGImage;

    CGContextRef contentContext;

    CGColorSpaceRef colorSpace;

    colorSpace = CGColorSpaceCreateDeviceRGB();

    contentContext = CGBitmapContextCreate(NULL,
                                           rect.size.width,
                                           rect.size.height,
                                           8,
                                           0,
                                           colorSpace,
                                           kCGImageAlphaPremultipliedLast);

    CGColorSpaceRelease(colorSpace);

    if (contentContext == NULL)
    {
        NSLog(@"绘制上下文异常");
    }

    CGContextClipToMask(contentContext,
                        CGRectMake(0, 0, rect.size.width, rect.size.height),
                        maskImageRef);

    CGContextDrawImage(contentContext,
                       CGRectMake(0, 0, rect.size.width, rect.size.height),
                       originImageRef);

    CGImageRef bitmapContext = CGBitmapContextCreateImage(contentContext);

    CGContextRelease(contentContext);

    UIImage *imageOut = [UIImage imageWithCGImage:bitmapContext];

    CGImageRelease(bitmapContext);

    return imageOut;
}

#pragma mark - 生成阴影

+ (UIImage *)i_creatShadowImageWithOriginalImage:(UIImage *)img
                                     shadowOffset:(CGSize)shadowOffset
                                    blurAreaWidth:(CGFloat)blurAreaWidth
                                            alpha:(CGFloat)alpha
                                      shadowColor:(UIColor *)shadowColor
{
    CGFloat scale = [UIScreen mainScreen].scale;

    CGFloat width = (img.size.width + shadowOffset.width + blurAreaWidth * 2) * scale;
    CGFloat height = (img.size.height + shadowOffset.height + blurAreaWidth * 2) * scale;

    /// 如果偏一点的起始位置X小于0，重新计算宽度
    if (shadowOffset.width < 0)
    {
        width = (img.size.width - shadowOffset.width + blurAreaWidth * 4) * scale;
    }

    /// 如果偏一点的起始位置Y小于0，重新计算高度
    if (shadowOffset.height < 0)
    {
        height = (img.size.height - shadowOffset.height + blurAreaWidth * 4) * scale;
    }

    UIView *backImageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];

    backImageView.backgroundColor = [UIColor clearColor];

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(blurAreaWidth * scale,
                                                                           blurAreaWidth * scale,
                                                                           img.size.width * scale,
                                                                           img.size.height * scale)];
    if (shadowOffset.width < 0)
    {
        imageView.frame = CGRectMake((blurAreaWidth - shadowOffset.width) * scale,
                                     imageView.frame.origin.y,
                                     imageView.frame.size.width,
                                     imageView.frame.size.height);
    }

    if (shadowOffset.height < 0)
    {
        imageView.frame = CGRectMake(imageView.frame.origin.x,
                                     (blurAreaWidth - shadowOffset.height) * scale,
                                     imageView.frame.size.width,
                                     imageView.frame.size.height);
    }

    imageView.backgroundColor = [UIColor clearColor];

    imageView.layer.shadowOffset = CGSizeMake(shadowOffset.width * scale,
                                              shadowOffset.height * scale);
    imageView.layer.shadowRadius = blurAreaWidth * scale;
    imageView.layer.shadowOpacity = alpha;
    imageView.layer.shadowColor = shadowColor.CGColor;
    imageView.image = img;

    [backImageView addSubview:imageView];

    UIImage *outImage = [self i_imageWithUIView:backImageView];

    return outImage;
}

#pragma mark - 旋转

+ (UIImage *)i_getRotationImageWithImage:(UIImage *)img
                                    angle:(CGFloat)angle
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,
                                                                img.size.width,
                                                                img.size.height)];

    CGAffineTransform transformAngle = CGAffineTransformMakeRotation(angle * M_PI / 180);

    backView.transform = transformAngle;

    CGSize sizeRotated = backView.frame.size;

    UIGraphicsBeginImageContext(sizeRotated);

    CGContextRef context = UIGraphicsGetCurrentContext();


    CGContextTranslateCTM(context, sizeRotated.width / 2, sizeRotated.height / 2);
    CGContextRotateCTM(context, angle * M_PI / 180);
    CGContextScaleCTM(context, 1.0, -1.0);

    CGContextDrawImage(context,
                       CGRectMake(-img.size.width / 2,
                                  -img.size.height / 2,
                                  img.size.width,
                                  img.size.height),
                       [img CGImage]);

    UIImage *imageTransform = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return imageTransform;
}

#pragma mark - UIView转图片，提前渲染

+ (UIImage *)i_imageWithUIView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(view.bounds.size.width, view.bounds.size.height), NO, 0.0);

    CGContextRef ctx = UIGraphicsGetCurrentContext();

    [view.layer renderInContext:ctx];

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return image;
}

#pragma mark - 获取高斯模糊图片

+ (UIImage *)i_creatBlurBackgound:(UIImage *)img
                        blurRadius:(CGFloat)radius
{
    // 创建属性
    CIImage *cimage = [[CIImage alloc] initWithImage:img];
    // 滤镜效果 高斯模糊
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    // 指定过滤照片
    [filter setValue:cimage forKey:kCIInputImageKey];
    // 模糊值
    NSNumber *number = [NSNumber numberWithFloat:radius];
    // 指定模糊值
    [filter setValue:number forKey:kCIInputRadiusKey];

    // 生成图片
    CIContext *context = [CIContext contextWithOptions:nil];

    //得到处理后的图片
    CIImage *outImage = [filter valueForKey:kCIOutputImageKey];

    CGImageRef cgImage = [context createCGImage:outImage fromRect:[cimage extent]];

    //显示图片
    UIImage *blurImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);

    return blurImage;
}

#pragma mark - 改变图片亮度

+ (nonnull UIImage *)i_creatBrighterImage:(nonnull UIImage *)img
                                  brighter:(CGFloat)brighter
{
    // 创建属性
    CIImage *cimage = [[CIImage alloc] initWithImage:img];
    // 设置图片亮度
    CIFilter *filter = [CIFilter filterWithName:@"CIColorControls"];
    // 指定过滤照片
    [filter setValue:cimage forKey:kCIInputImageKey];

    // 亮度值
    NSNumber *number = [NSNumber numberWithFloat:brighter];
    // 指定亮度
    [filter setValue:number forKey:kCIInputBrightnessKey];

    // 生成图片
    CIContext *context = [CIContext contextWithOptions:nil];

    //得到处理后的图片
    CIImage *outImage = [filter valueForKey:kCIOutputImageKey];

    CGImageRef cgImage = [context createCGImage:outImage fromRect:[cimage extent]];

    //显示图片
    UIImage *brightImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);

    return brightImage;
}
@end
