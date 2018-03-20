//
//  UIView+PToast.m
//  PCustomKit
//
//  Created by renqingyang on 2017/11/8.
//  Copyright © 2017年 ren. All rights reserved.
//

#import "UIView+PToast.h"

#import "UIView+Toast.h"

static NSTimeInterval defaultToastDuration  = 2.0;

@implementation UIView (PToast)

+ (void)load
{
    // 设置toast只是支持点击消失
    [CSToastManager setTapToDismissEnabled:NO];

    // 支持toast显示队列
    [CSToastManager setQueueEnabled:YES];
}

#pragma mark - ******************************扩展方法************************************************

// 显示 toast msg
- (void)i_showToastWithMessage:(NSString *)msg
{
    if (kString_Is_Valid(msg))
    {
        [self makeToast:msg duration:defaultToastDuration position:CSToastPositionCenter];
    }
}

// 显示 toast msg 显示debug下错误信息
- (void)i_showToastWithErrMessage:(NSString *)errMsg
{
    if (kString_Is_Valid(errMsg)
        && [CoreConfigManager shared].showDebugToast)
    {
        [self makeToast:errMsg duration:defaultToastDuration position:CSToastPositionTop];
    }
}

// 显示 toast msg duration
- (void)i_showToastWithMessage:(NSString *)msg
                       duration:(NSTimeInterval)duration
{
    if (kString_Is_Valid(msg))
    {
        [self makeToast:msg duration:duration position:CSToastPositionCenter];
    }
}

// 显示 toast msg duration block 是否支持点击，统一由CoreConfigManager控制
- (void)i_showToastWithMessage:(NSString *)msg
                       duration:(NSTimeInterval)duration
                     completion:(void(^)(BOOL didTap))completion
{
    if (kString_Is_Valid(msg))
    {
        [self makeToast:msg
               duration:duration
               position:CSToastPositionCenter
                  title:nil
                  image:nil
                  style:nil
             completion:completion];
    }
}

// 显示 toast title msg
- (void)i_showToastWithMessage:(NSString *)msg title:(NSString *)title
{
    if (kString_Is_Valid(msg) && kString_Is_Valid(title))
    {
        [self makeToast:msg
               duration:defaultToastDuration
               position:CSToastPositionCenter
                  title:title
                  image:nil
                  style:nil
             completion:nil];
    }
    else if (kString_Is_Valid(msg))
    {
        [self i_showToastWithMessage:msg];
    }
    else if (kString_Is_Valid(title))
    {
        [self i_showToastWithMessage:title];
    }
}

// 显示 toast title msg duration
- (void)i_showToastWithMessage:(NSString *)msg
                          title:(NSString *)title
                       duration:(NSTimeInterval)duration
{
    if (kString_Is_Valid(msg) && kString_Is_Valid(title))
    {
        [self makeToast:msg
               duration:duration
               position:CSToastPositionCenter
                  title:title
                  image:nil
                  style:nil
             completion:nil];
    }
    else if (kString_Is_Valid(msg))
    {
        [self i_showToastWithMessage:msg duration:duration];
    }
    else if (kString_Is_Valid(title))
    {
        [self i_showToastWithMessage:title duration:duration];
    }
}

// 显示 toast title msg duration block 是否支持点击，统一由CoreConfigManager控制
- (void)i_showToastWithMessage:(NSString *)msg
                          title:(NSString *)title
                       duration:(NSTimeInterval)duration
                     completion:(void(^)(BOOL didTap))completion
{
    if (kString_Is_Valid(msg) && kString_Is_Valid(title))
    {
        [self makeToast:msg
               duration:duration
               position:CSToastPositionCenter
                  title:title
                  image:nil
                  style:nil
             completion:completion];
    }
    else if (kString_Is_Valid(msg))
    {
        [self i_showToastWithMessage:msg duration:duration completion:completion];
    }
    else if (kString_Is_Valid(title))
    {
        [self i_showToastWithMessage:title duration:duration completion:completion];
    }
}

@end
