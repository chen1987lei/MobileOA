//
//  Macro_UIFont.h
//  iCore 
//
//  Created by renqingyang on 2017/11/7.
//  Copyright © 2017年 ren. All rights reserved.
//

#ifndef Macro_UIFont_h
#define Macro_UIFont_h

#pragma mark - ******************************************* 设置字体值 ********************************

#pragma mark - Font 细 字体

#define kFont_System_Light(fontSize) [UIFont i_getSystemLightFont:(fontSize)]

#pragma mark - Font 中 字体

#define kFont_System_Regular(fontSize) [UIFont i_getSystemRegularFont:(fontSize)]

#pragma mark - Font 粗 字体

#define kFont_System_Medium(fontSize) [UIFont i_getSystemMediumFont:(fontSize)]

#pragma mark - 获取 系统 Bold 字体

#define kFont_System_Bold(fontSize) [UIFont i_getSystemBoldFont:(fontSize)]

#pragma mark - 获取 系统 Semibold 字体

#define kFont_System_Semibold(fontSize) [UIFont i_getSystemSemiboldFont:(fontSize)]

#endif /* Macro_UIFont_h */
