//
//  PBaseViewController+PHUD.h
//  PCustomKit
//
//  Created by renqingyang on 2017/11/22.
//  Copyright © 2017年 ren. All rights reserved.
//

#import "PBaseViewController.h"

#import "UIView+PHUD.h"

@interface PBaseViewController (PHUD)

#pragma mark - 提示框

// msg
- (void)i_showActivity;

// msg
- (void)i_showActivityWithMessage:(NSString*)msg;

// msg duration
- (void)i_showActivityWithMessage:(NSString*)msg
                          duration:(NSTimeInterval)duration;

// msg duration completion
- (void)i_showActivityWithMessage:(NSString*)msg
                          duration:(NSTimeInterval)duration
                  hiddenCompletion:(void(^)(void))completion;

#pragma mark - 自定义icon提示框

// msg type
- (void)i_showCustomIconMessage:(NSString *)msg iconType:(PE_HUDIconType)type;

// msg type duration
- (void)i_showCustomIconMessage:(NSString *)msg
                        iconType:(PE_HUDIconType)type
                        duration:(NSTimeInterval)duration;

// msg type duration completion
- (void)i_showCustomIconMessage:(NSString *)msg
                        iconType:(PE_HUDIconType)type
                        duration:(NSTimeInterval)duration
                hiddenCompletion:(void(^)(void))completion;

// 隐藏指示器,默认没有动画
- (void)i_hideHUD;
// 隐藏指示器
- (void)i_hideHUDWithAnimated:(BOOL)animated;

@end
