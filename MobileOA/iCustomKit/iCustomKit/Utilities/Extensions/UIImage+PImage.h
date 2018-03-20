//
//  UIImage+PImage.h
//  PCustomKit
//
//  Created by user on 2017/11/14.
//  Copyright © 2017年 ren. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (PImage)

/**
 将颜色对象转换成一张图片

 @param color 颜色对象
 @param rect 将要生成的图片大小
 @param radius 圆角大小
 @return 返回一张图片 UIImage对象
 */
+ (UIImage *)i_createImageWithColor:(UIColor *)color rect:(CGRect)rect cornerRadius:(float)radius;

/**
 *  传入一个颜色返回一个UIImage对象
 *
 *  @param color 传入一个颜色值
 *
 *  @return 返回一个UIImage对象
 */
+ (UIImage *)i_createImageWithColor:(UIColor *) color;

@end
