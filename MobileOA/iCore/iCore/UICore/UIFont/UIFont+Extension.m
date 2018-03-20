//
//  UIFont+Extension.m
//  iCore 
//
//  Created by renqingyang on 2017/11/7.
//  Copyright © 2017年 ren. All rights reserved.
//

#import "UIFont+Extension.h"

@implementation UIFont (Extension)

#pragma mark - ******************************************* 私有方法 **********************************


#pragma mark - ******************************************* 对外方法 **********************************


#pragma mark - ******************************************* 类方法 ***********************************

#pragma mark - 获取 系统 细 字体

+ (UIFont *)i_getSystemLightFont:(NSInteger)fontSize
{
    return [UIFont systemFontOfSize:(fontSize) weight:UIFontWeightLight];
}

#pragma mark - 获取 系统 中 字体

+ (UIFont *)i_getSystemRegularFont:(NSInteger)fontSize
{
    return [UIFont systemFontOfSize:(fontSize) weight:UIFontWeightRegular];
}

#pragma mark - 获取 系统 粗 字体

+ (UIFont *)i_getSystemMediumFont:(NSInteger)fontSize
{
    return [UIFont systemFontOfSize:(fontSize) weight:UIFontWeightMedium];
}

#pragma mark - 获取 系统 Bold 字体

+ (UIFont *)i_getSystemBoldFont:(NSInteger)fontSize
{
    return [UIFont systemFontOfSize:(fontSize) weight:UIFontWeightBold];
}

#pragma mark - 获取 系统 Semibold 字体

+ (UIFont *)i_getSystemSemiboldFont:(NSInteger)fontSize
{
    return [UIFont systemFontOfSize:(fontSize) weight:UIFontWeightSemibold];
}
@end
