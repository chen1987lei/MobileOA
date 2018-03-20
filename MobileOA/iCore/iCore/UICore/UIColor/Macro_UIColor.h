//
//  Macro_UIColor.h
//  iCore 
//
//  Created by renqingyang on 2017/11/6.
//  Copyright © 2017年 ren. All rights reserved.
//

#ifndef Macro_UIColor_h
#define Macro_UIColor_h

#pragma mark - ******************************************* 设置颜色值 ********************************

#pragma mark -自定义颜色 16位

// 自定义颜色 16位
#define kColor_RGB(rgb) kColor_RGB_A(rgb, 1.0)

// 自定义颜色 透明度 16位，如：kColor_RGB(0xAABBCC) 或 kColor_RGB_A(0xAABBCC, 0.5);
#define kColor_RGB_A(rgb, a) [UIColor colorWithRed:((float) ((rgb & 0xFF0000) >> 16)) / 255.0 \
                                               green:((float) ((rgb & 0xFF00) >> 8)) / 255.0    \
                                                blue:((float) (rgb & 0xFF)) / 255.0             \
                                               alpha:(a) / 1.0]

#pragma mark -自定义颜色 10位

// 自定义颜色 10位
#define kColor_R_G_B(r, g, b) kColor_R_G_B_A(r, g, b, 1.0)

// 自定义颜色 透明度，10位
#define kColor_R_G_B_A(r, g, b, a) [UIColor colorWithRed:(r) / 255.0 \
                                                     green:(g) / 255.0 \
                                                      blue:(b) / 255.0 \
                                                     alpha:(a) / 1.0]

#pragma mark -随机颜色 10位
// 随机颜色
#define kRandom_Color kRandom_Color_A(1.0)
// 随机颜色 透明度
#define kRandom_Color_A(a) [UIColor colorWithRed:arc4random_uniform(256.0) / 255.0 \
                                             green:arc4random_uniform(256) / 255.0 \
                                              blue:arc4random_uniform(256) / 255.0 \
                                             alpha:(a)]

#endif /* Macro_UIColor_h */
