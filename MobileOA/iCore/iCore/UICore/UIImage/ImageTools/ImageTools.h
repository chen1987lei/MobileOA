//
//  ImageTools.h
//
//  Created by 任清阳 on 2016/9/7.
//  Copyright © 2016年 ren. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ImageCompress.h"

/*!
 *  @author renqingyang, 16-09-07 14:34:28
 *
 *  @brief  图片工具类，包括加圆角，加阴影，图片剪裁，生成缩略图，加水印加遮罩，图片旋转
 *
 *  @since  1.0
 */
@interface ImageTools : NSObject

#pragma mark - 预先生成圆角图片，直接渲染到UIImageView中去，相比直接在UIImageView.layer中去设置圆角，可以缩短渲染时间。

/**
 *  在原图的四周生成圆角，得到带圆角的图片
 *
 *  @param img      原图
 *  @param radius           圆角大小
 *  @param backgroundColor 背景颜色
 *
 *  @return 新生成的图片
 */
+ (nonnull UIImage *)i_getCornerImageAtOriginalImageCornerWithImage:(nonnull UIImage *)img
                                                        cornerRadius:(CGFloat)radius
                                                     backGroundColor:(nullable UIColor *)backgroundColor;

/**
 *  根据Size生成圆角图片，图片会拉伸-变形
 *
 *  @param size            最终想要的图片的尺寸
 *  @param img           原图
 *  @param radius           圆角大小
 *  @param backgroundColor 背景颜色
 *
 *  @return 新生成的图片
 */
+ (nonnull UIImage *)i_getCornerImageFitSize:(CGSize)size
                                        image:(nonnull UIImage *)img
                                 cornerRadius:(CGFloat)radius
                              backGroundColor:(nullable UIColor *)backgroundColor;

/**
 *  根据Size生成圆角图片，图片会自适应填充，伸展范围以外的部分会被裁剪掉-不会变形
 *
 *  @param size            最终想要的图片的尺寸
 *  @param img           原图
 *  @param radius           圆角大小
 *  @param backgroundColor 背景颜色
 *
 *  @return 新生成的图片
 */
+ (nonnull UIImage *)i_getCornerImageFillSize:(CGSize)size
                                         image:(nonnull UIImage *)img
                                  cornerRadius:(CGFloat)radius
                               backGroundColor:(nullable UIColor *)backgroundColor;

#pragma mark - 缩略图

/**
 *  得到图片的缩略图
 *
 *  @param img 原图
 *  @param size  想得到的缩略图尺寸
 *  @param isScale Scale为YES：原图会根据Size进行拉伸-会变形，Scale为NO：原图会根据Size进行填充-不会变形
 *
 *  @return 新生成的图片
 */
+ (nonnull UIImage *)i_getThumbImageWithImage:(nonnull UIImage *)img
                                          size:(CGSize)size
                                       isScale:(BOOL)isScale;

#pragma mark - 水印

/**
 *  生成带水印的图片
 *
 *  @param backImage  背景图片
 *  @param waterImage 水印图片
 *  @param rect  水印位置及大小
 *  @param alpha      水印透明度
 *  @param isWaterScale 水印是否根据Rect改变长宽比
 *
 *  @return 新生成的图片
 */
+ (nonnull UIImage *)i_getWaterPrintedImageWithBackImage:(nonnull UIImage *)backImage
                                               waterImage:(nonnull UIImage *)waterImage
                                                   inRect:(CGRect)rect
                                                    alpha:(CGFloat)alpha
                                             isWaterScale:(BOOL)isWaterScale;

#pragma mark - 裁剪

/**
 *  裁剪图片
 注：若裁剪范围超出原图尺寸，则会用背景色填充缺失部位
 *
 *  @param img     原图
 *  @param point     坐标
 *  @param size      大小
 *  @param backgroundColor 背景色
 *
 *  @return 新生成的图片
 */
+ (nonnull UIImage *)i_cutImageWithImage:(nonnull UIImage *)img
                                  atPoint:(CGPoint)point
                                     size:(CGSize)size
                          backgroundColor:(nullable UIColor *)backgroundColor;

#pragma mark - 根据遮罩图形状裁剪

/**
 *  根据遮罩图片的形状，裁剪原图，并生成新的图片
 原图与遮罩图片宽高最好都是1：1。若比例不同，则会居中。
 若因比例问题达不到效果，可用下面的UIview转UIImage的方法，先制作1：1的UIview，然后转成UIImage使用此功能
 *
 *  @param maskImage 遮罩图片：遮罩图片最好是要显示的区域为纯黑色，不显示的区域为透明色。
 *  @param backImage 准备裁剪的图片
 *
 *  @return 新生成的图片
 */
+ (nonnull UIImage *)i_creatImageWithMaskImage:(nonnull UIImage *)maskImage
                                      backImage:(nonnull UIImage *)backImage;

#pragma mark - 生成阴影

/**
 *  生成带阴影的图片
 *
 *  @param img     原图
 *  @param shadowOffset    横纵方向的偏移
 *  @param blurAreaWidth 模糊区域宽度
 *  @param alpha     阴影透明度
 *  @param shadowColor     阴影颜色
 *
 *  @return 新生成的图片
 */
+ (nonnull UIImage *)i_creatShadowImageWithOriginalImage:(nonnull UIImage *)img
                                             shadowOffset:(CGSize)shadowOffset
                                            blurAreaWidth:(CGFloat)blurAreaWidth
                                                    alpha:(CGFloat)alpha
                                              shadowColor:(nullable UIColor *)shadowColor;

#pragma mark - 旋转

/**
 *  得到旋转后的图片
 *
 *  @param img 原图
 *  @param angle 角度（0~360）
 *
 *  @return 新生成的图片
 */
+ (nonnull UIImage *)i_getRotationImageWithImage:(nonnull UIImage *)img
                                            angle:(CGFloat)angle;

#pragma mark - UIView转图片，提前渲染

/**
 *  把UIView渲染成图片
 注：由于ios的编程像素和实际显示像素不同，在X2和X3的retina屏幕设备上，使用此方法生成的图片大小将会被还原成1倍像素，
 从而导致再次显示到UIImageView上显示时，清晰度下降。所以使用此方法前，请先将要转换的UIview及它的所有SubView
 的frame里的坐标和大小都根据需要X屏幕密度。
 *
 *  @param view 想渲染的UIView
 *
 *  @return 渲染出的图片
 */
+ (nonnull UIImage *)i_imageWithUIView:(nonnull UIView *)view;

#pragma mark - 获取高斯模糊图片

/**
 *  获取高斯模糊图片
 *
 *  @param img 要进行高斯模糊的UIImage
 *  @param radius 设置效果的半径，半径越大效果越明显
 *
 *  @return 高斯模糊渲染出的图片
 */
+ (nonnull UIImage *)i_creatBlurBackgound:(nonnull UIImage *)img
                                blurRadius:(CGFloat)radius;

#pragma mark - 改变图片亮度

/**
 *  改变图片亮度
 *
 *  @param img 要进行调节的UIImage
 *  @param brighter 设置亮度
 *
 *  @return 高斯模糊渲染出的图片
 */
+ (nonnull UIImage *)i_creatBrighterImage:(nonnull UIImage *)img
                                  brighter:(CGFloat)brighter;

@end
