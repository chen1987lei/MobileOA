//
//  UIFont+Extension.h
//  iCore 
//
//  Created by renqingyang on 2017/11/7.
//  Copyright © 2017年 ren. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 *  @author 任清阳, 2017-11-07  12:46:13
 *
 *  @brief  获取UI常用系统字体
 *
 *  @since  1.0 
 */

@interface UIFont (Extension)

// 获取 系统 细 字体
+ (UIFont *)i_getSystemLightFont:(NSInteger)fontSize;

// 获取 系统 中 字体
+ (UIFont *)i_getSystemRegularFont:(NSInteger)fontSize;

// 获取 系统 粗 字体
+ (UIFont *)i_getSystemMediumFont:(NSInteger)fontSize;

// 获取 系统 Bold 字体
+ (UIFont *)i_getSystemBoldFont:(NSInteger)fontSize;

// 获取 系统 Semibold 字体
+ (UIFont *)i_getSystemSemiboldFont:(NSInteger)fontSize;

@end
