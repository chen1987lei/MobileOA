//
//  ImageCompress.m
//  MTFoundation
//
//  Created by 任清阳 on 2016/9/7.
//  Copyright © 2016年 Mtime. All rights reserved.
//

#import "ImageCompress.h"

@implementation ImageCompress

#pragma mark - 前台压缩（可能比较慢，造成当前进程卡住）

#pragma mark - 压缩得到 目标大小的 图片Data

+ (NSData *)i_compressToDataWithImage:(UIImage *)oldImage
                              showSize:(CGSize)size
                              fileSize:(NSInteger)maxSize
{
    NSLog(@"正在压缩图片...");

    /// 获取缩略图
    UIImage *thumbnailImage = [self i_resizeImageWithImage:oldImage size:size scale:NO];

    /// 获取压缩后的NSData
    NSData *compressData = [self i_onlyCompressToDataWithImage:thumbnailImage fileSize:maxSize * 1024];

    //如果压缩后还是无法达到文件大小，则降低分辨率，继续压缩
    while (compressData.length > (maxSize * 1024))
    {
        size = CGSizeMake(size.width * 0.8, size.height * 0.8);

        thumbnailImage = [self i_resizeImageWithImage:oldImage size:size scale:NO];

        compressData = [self i_onlyCompressToDataWithImage:thumbnailImage
                                                   fileSize:maxSize * 1024];
    }

    NSLog(@"压缩完成");

    return compressData;
}

#pragma mark - 压缩得到 目标大小的 UIImage

+ (UIImage *)i_compressToImageWithImage:(UIImage *)oldImage
                                showSize:(CGSize)size
                                fileSize:(NSInteger)maxSize
{
    NSLog(@"正在压缩图片...");
    /// 获取缩略图
    UIImage *thumbnailImage = [self i_resizeImageWithImage:oldImage size:size scale:NO];

    /// 获取压缩后的Image
    UIImage *compressImage = [self i_onlyCompressToImageWithImage:thumbnailImage fileSize:maxSize * 1024];

    NSData *data = UIImageJPEGRepresentation(compressImage, 1);

    //如果压缩后还是无法达到文件大小，则降低分辨率，继续压缩
    while ([data length] > (maxSize * 1024))
    {
        size = CGSizeMake(size.width * 0.8, size.height * 0.8);

        thumbnailImage = [self i_resizeImageWithImage:compressImage size:size scale:NO];

        compressImage = [self i_onlyCompressToImageWithImage:thumbnailImage fileSize:maxSize * 1024];

        data = UIImageJPEGRepresentation(compressImage, 1);
    }

    NSLog(@"压缩完成");

    return compressImage;
}

#pragma mark - 后台压缩（异步进行，不会卡住前台进程）

#pragma mark - 后台压缩得到 目标大小的 图片Data (使用block的结果，记得按需获取主线程)

+ (void)i_compressToDataAtBackgroundWithImage:(UIImage *)oldImage
                                      showSize:(CGSize)size
                                      fileSize:(NSInteger)maxSize
                                         block:(ResultDataBlock)resultDataBlock
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{

        NSData *data = [ImageCompress i_compressToDataWithImage:oldImage
                                                          showSize:size
                                                          fileSize:maxSize];
        !resultDataBlock ? : resultDataBlock(data);
    });
}

#pragma mark - 后台压缩得到 目标大小的 UIImage (使用block的结果，记得按需获取主线程)

+ (void)i_compressToImageAtBackgroundWithImage:(UIImage *)oldImage
                                       showSize:(CGSize)size
                                       fileSize:(NSInteger)maxSize
                                          block:(ResultImageBlock)resultImageBlock
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *imageCompress = [ImageCompress i_compressToImageWithImage:oldImage
                                                                      showSize:size
                                                                      fileSize:maxSize];

        !resultImageBlock ? : resultImageBlock(imageCompress);
    });
}

#pragma mark - 只压不缩 调用类方法  优点：不影响分辨率，不太影响清晰度 缺点：存在最小限制，可能压不到目标大小

/// 按UIImage大小压缩，返回UIImage

+ (UIImage *)i_onlyCompressToImageWithImage:(UIImage *)oldImage
                                    fileSize:(NSInteger)maxSize
{
    CGFloat compression = 0.9f;
    CGFloat minCompression = 0.01f;

    NSData *data = UIImageJPEGRepresentation(oldImage, compression);

    //每次减少的比例
    float scale = 0.1;

    /// 压缩后UIImage的Data
    NSData *compressionImageData = UIImageJPEGRepresentation(oldImage, 1);

    //循环条件：没到最小压缩比例，且没压缩到目标大小
    while ((compression > minCompression) && (compressionImageData.length > maxSize))
    {
        data = UIImageJPEGRepresentation(oldImage, compression);

        UIImage *compressedImage = [UIImage imageWithData:data];

        compressionImageData = UIImageJPEGRepresentation(compressedImage, 1);

        compression -= scale;
    }

    UIImage *compressedImage = [UIImage imageWithData:compressionImageData];

    return compressedImage;
}

/// 按NSData大小压缩，返回NSData,默认PNG

+ (NSData *)i_onlyCompressToDataWithImage:(UIImage *)oldImage
                                  fileSize:(NSInteger)maxSize
{
    CGFloat compression = 0.9f;
    CGFloat minCompression = 0.01f;

    NSData *data = UIImageJPEGRepresentation(oldImage,
                                             compression);
    //每次减少的比例
    float floatScale = 0.1;

    //循环条件：没到最小压缩比例，且没压缩到目标大小
    while ((compression > minCompression) && (data.length > maxSize))
    {
        compression -= floatScale;
        data = UIImageJPEGRepresentation(oldImage,
                                         compression);
    }

    return data;
}

#pragma mark - 只缩不压 调用类方法  优点：可以大幅降低容量大小 缺点：影响清晰度

+ (UIImage *)i_resizeImageWithImage:(UIImage *)oldImage
                                size:(CGSize)size
                               scale:(BOOL)isScale
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);

    CGRect rect = CGRectMake(0, 0, size.width, size.height);

    if (!isScale)
    {
        /// 图片宽高比
        CGFloat imageAspectRatio = oldImage.size.width / oldImage.size.height;

        /// 显示size的宽高比
        CGFloat sizeAspectRatio = size.width / size.height;

        /// 图片宽高比大于size的宽高比，做图片剪裁
        if (imageAspectRatio > sizeAspectRatio)
        {
            /// 获取需要剪裁比例，已高度比为准
            CGFloat heightRatio = size.height / oldImage.size.height;

            /// 计算剪裁后的高度
            CGFloat height = oldImage.size.height * heightRatio;

            CGFloat width = height * imageAspectRatio;

            CGFloat x = -(width - size.width) / 2;

            CGFloat y = 0;

            rect = CGRectMake(x, y, width, height);
        }
        else
        {
            /// 获取需要剪裁比例，已宽度比为准
            CGFloat floatWidthRatio = size.width / oldImage.size.width;

            /// 计算剪裁后的宽度
            CGFloat width = oldImage.size.width * floatWidthRatio;

            CGFloat height = width / imageAspectRatio;

            CGFloat x = 0;

            CGFloat y = -(height - size.height) / 2;

            rect = CGRectMake(x, y, width, height);
        }
    }

    [[UIColor clearColor] set];

    UIRectFill(rect);

    [oldImage drawInRect:rect];

    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return newImage;
}

@end
