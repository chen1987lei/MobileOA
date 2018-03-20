//
//  PBaseViewController+PHUD.m
//  PCustomKit
//
//  Created by renqingyang on 2017/11/22.
//  Copyright © 2017年 ren. All rights reserved.
//

#import "PBaseViewController+PHUD.h"

@implementation PBaseViewController (PHUD)

#pragma mark - 提示框

// msg
- (void)i_showActivity
{
    [self.view i_showActivity];
}

// msg
- (void)i_showActivityWithMessage:(NSString*)msg
{
    [self.view i_showActivityWithMessage:msg];
}

// msg duration
- (void)i_showActivityWithMessage:(NSString*)msg
                          duration:(NSTimeInterval)duration
{
    [self.view i_showActivityWithMessage:msg duration:duration];
}

// msg duration completion
- (void)i_showActivityWithMessage:(NSString*)msg
                          duration:(NSTimeInterval)duration
                  hiddenCompletion:(void(^)(void))completion
{
    [self.view i_showActivityWithMessage:msg duration:duration hiddenCompletion:completion];
}

#pragma mark - 自定义icon提示框

// msg type
- (void)i_showCustomIconMessage:(NSString *)msg iconType:(PE_HUDIconType)type
{
    [self.view i_showCustomIconMessage:msg iconType:type];
}

// msg type duration
- (void)i_showCustomIconMessage:(NSString *)msg
                        iconType:(PE_HUDIconType)type
                        duration:(NSTimeInterval)duration
{
    [self.view i_showCustomIconMessage:msg iconType:type duration:duration];
}

// msg type duration completion
- (void)i_showCustomIconMessage:(NSString *)msg
                        iconType:(PE_HUDIconType)type
                        duration:(NSTimeInterval)duration
                hiddenCompletion:(void(^)(void))completion
{
    [self.view i_showCustomIconMessage:msg iconType:type duration:duration hiddenCompletion:completion];
}

// 隐藏指示器
- (void)i_hideHUD
{
    [self.view i_hideHUDWithAnimated:NO];
}
// 隐藏指示器
- (void)i_hideHUDWithAnimated:(BOOL)animated
{
    [self.view i_hideHUDWithAnimated:animated];
}

@end
