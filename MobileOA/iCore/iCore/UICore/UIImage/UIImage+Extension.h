//
//  UIImage+Extension.h
//  iCore 
//
//  Created by renqingyang on 2017/11/21.
//  Copyright © 2017年 ren. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 *  @author 任清阳, 2017-11-21  11:09:10
 *
 *  @brief  UIImage 基本扩展
 *
 *  @since  1.0
 */
@interface UIImage (Extension)

/*!
 *
 *  @brief 根据路径获取资源图片。
 *
 *  @discussion 根据路径获取资源图片.
 *
 *  @param path 需要加载的资源路径.
 *
 *  @return UIImage.
 *
 *  @since  1.0
 *
 */

/*!
 1.使用imageName：加载图片

 （1）加载内存当中之后，会一直停留在内存当中，不会随着对象的销毁而销毁。

 （2）加载进去图片之后，占用的内存归系统管理，我们无法管理。

 （3）相同的图片，图片不会重复加载。

 （4）加载到内存中后，占据内存空间较大。
 2、使用imageWithContentsofFile：加载图片

 （1）加载到内存当中后，占据内存空间较小。

 （2）相同的图片会被重复加载内存当中。

 （3）对象销毁的时候，加载到内存中图片会随着一起销毁
*/
+ (UIImage *)i_loadResourceDataWithPath:(NSString *)path;
@end
