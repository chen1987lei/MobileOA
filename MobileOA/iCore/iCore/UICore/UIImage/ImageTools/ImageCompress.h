//
//  ImageCompress.h
//
//  Created by 任清阳 on 2016/9/7.
//  Copyright © 2016年 ren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^ResultImageBlock)(UIImage *resultImage);

typedef void (^ResultDataBlock)(NSData *resultData);


/*!
 *  @author renqingyang, 16-09-07 11:52:17
 *
 *  @brief  图片压缩工具
 *
 *  @since  1.0
 */
@interface ImageCompress : NSObject

#pragma mark - 前台压缩（可能比较慢，造成当前进程卡住）

/**
 *  压缩得到 目标大小的 图片Data
 *
 *  @param oldImage 原图
 *  @param size 将要显示的分辨率
 *  @param maxSize 文件大小限制
 *
 *  @return 压缩得到的图片Data
 */
+ (NSData *)i_compressToDataWithImage:(UIImage *)oldImage
                              showSize:(CGSize)size
                              fileSize:(NSInteger)maxSize;
/**
 *  压缩得到 目标大小的 UIImage
 *
 *  @param oldImage 原图
 *  @param size 将要显示的分辨率
 *  @param maxSize 文件大小限制
 *
 *  @return 压缩得到的UIImage
 */
+ (UIImage *)i_compressToImageWithImage:(UIImage *)oldImage
                                showSize:(CGSize)size
                                fileSize:(NSInteger)maxSize;

#pragma mark - 后台压缩（异步进行，不会卡住前台进程）

/**
 *  后台压缩得到 目标大小的 图片Data (使用block的结果，记得按需获取主线程)
 *
 *  @param oldImage  原图
 *  @param size  将要显示的分辨率
 *  @param maxSize  文件大小限制
 *  @param resultDataBlock 压缩成功后返回的block
 */
+ (void)i_compressToDataAtBackgroundWithImage:(UIImage *)oldImage
                                      showSize:(CGSize)size
                                      fileSize:(NSInteger)maxSize
                                         block:(ResultDataBlock)resultDataBlock;


/**
 *  后台压缩得到 目标大小的 UIImage (使用block的结果，记得按需获取主线程)
 *
 *  @param oldImage 原图
 *  @param size 将要显示的分辨率
 *  @param maxSize 文件大小限制
 *  @param resultImageBlock 压缩成功后返回的block
 */
+ (void)i_compressToImageAtBackgroundWithImage:(UIImage *)oldImage
                                       showSize:(CGSize)size
                                       fileSize:(NSInteger)maxSize
                                          block:(ResultImageBlock)resultImageBlock;

#pragma mark - 只压不缩 调用类方法  优点：不影响分辨率，不太影响清晰度 缺点：存在最小限制，可能压不到目标大小

/// 按UIImage大小压缩，返回UIImage
+ (UIImage *)i_onlyCompressToImageWithImage:(UIImage *)oldImage
                                    fileSize:(NSInteger)maxSize;

/// 按NSData大小压缩，返回NSData,默认PNG
+ (NSData *)i_onlyCompressToDataWithImage:(UIImage *)oldImage
                                  fileSize:(NSInteger)maxSize;

#pragma mark - 只缩不压 调用类方法  优点：可以大幅降低容量大小 缺点：影响清晰度

/**
 *  只缩不压 返回UIImage
 *
 *  @param isScale
 *         isScale为YES，则原图会根据Size进行拉伸-会变形; isScale为NO，则原图会根据Size进行填充-不会变形
 */
+ (UIImage *)i_resizeImageWithImage:(UIImage *)oldImage
                                size:(CGSize)size
                               scale:(BOOL)isScale;

@end
