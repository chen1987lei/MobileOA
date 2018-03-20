//
//  UIView+PToast.h
//  PCustomKit
//
//  Created by renqingyang on 2017/11/8.
//  Copyright © 2017年 ren. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (PToast)

// 显示 toast msg
- (void)i_showToastWithMessage:(NSString *)msg;

// 显示 toast msg 显示debug下错误信息
- (void)i_showToastWithErrMessage:(NSString *)errMsg;

// 显示 toast msg duration
- (void)i_showToastWithMessage:(NSString *)msg
                       duration:(NSTimeInterval)duration;

// 显示 toast msg duration block 是否支持点击，统一由CoreConfigManager控制
- (void)i_showToastWithMessage:(NSString *)msg
                       duration:(NSTimeInterval)duration
                     completion:(void(^)(BOOL didTap))completion;

// 显示 toast title msg
- (void)i_showToastWithMessage:(NSString *)msg title:(NSString *)title;

// 显示 toast title msg duration
- (void)i_showToastWithMessage:(NSString *)msg
                          title:(NSString *)title
                       duration:(NSTimeInterval)duration;

// 显示 toast title msg duration block 是否支持点击，统一由CoreConfigManager控制
- (void)i_showToastWithMessage:(NSString *)msg
                          title:(NSString *)title
                       duration:(NSTimeInterval)duration
                     completion:(void(^)(BOOL didTap))completion;

@end
