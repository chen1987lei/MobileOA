//
//  UINavigationBar+Extension.m
//  iCore 
//
//  Created by renqingyang on 2017/11/8.
//  Copyright © 2017年 ren. All rights reserved.
//

#import "UINavigationBar+Extension.h"

#import <objc/runtime.h>

@implementation UINavigationBar (Extension)

#pragma mark - ******************************Setter & Getter****************************************

// 设置 NavigationBarStyle
- (void)setNavigationBarStyle:(NavigationBarStyle)navigationBarStyle
{
    switch (navigationBarStyle)
    {
        case NavigationBarStyle_Default:
        {
            [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (![NSStringFromClass([obj class]) isEqualToString:@"_UINavigationBarBackIndicatorView"]) {
                    obj.alpha = 1;
                }
            }];
            break;
        }
        case NavigationBarStyle_OnlyItem:
        {
            [self i_setNavigationBarBackgroundAlpla:0];
            break;
        }
    }
    objc_setAssociatedObject(self, @selector(navigationBarStyle), @(navigationBarStyle), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NavigationBarStyle)navigationBarStyle
{
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}
- (void)setBarAlpha:(CGFloat)barAlpha
{
    switch (self.navigationBarStyle)
    {
        case NavigationBarStyle_Default:
        {
            self.alpha = barAlpha;
            break;
        }
        case NavigationBarStyle_OnlyItem:
        {
            [self i_setNavigationBarBackgroundAlpla:barAlpha];
            break;
        }
    }
    objc_setAssociatedObject(self, @selector(barAlpha), @(barAlpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CGFloat)barAlpha
{
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)i_setNavigationBarBackgroundAlpla:(CGFloat)alpha
{
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")]) {
            obj.alpha = alpha;
        }
    }];
    
}

@end
