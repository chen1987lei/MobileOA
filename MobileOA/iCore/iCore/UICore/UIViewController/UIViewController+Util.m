//
//  UIViewController+Util.m
//  iCore 
//
//  Created by renqingyang on 2017/12/27.
//  Copyright © 2017年 ren. All rights reserved.
//

#import "UIViewController+Util.h"

@implementation UIViewController (Util)

//获取当前屏幕显示的viewcontroller
+ (UIViewController *)i_getCurrentVC
{
    UIViewController *result = nil;

    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }

    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];

    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;

    return result;
}

@end
