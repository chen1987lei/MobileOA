//
//  UIView+PHUD.m
//  PCustomKit
//
//  Created by renqingyang on 2017/11/22.
//  Copyright © 2017年 ren. All rights reserved.
//

#import "UIView+PHUD.h"

#import "MBProgressHUD.h"

@implementation UIView (PHUD)

#pragma mark - 提示框
- (void)i_showActivity
{
    [self i_showActivityWithMessage:nil duration:0];
}

// msg
- (void)i_showActivityWithMessage:(NSString*)msg
{
    [self i_showActivityWithMessage:msg duration:0];
}

// msg duration
- (void)i_showActivityWithMessage:(NSString*)msg
                          duration:(NSTimeInterval)duration
{
    [self i_showActivityWithMessage:msg duration:0 hiddenCompletion:nil];
}

// msg duration completion
- (void)i_showActivityWithMessage:(NSString*)msg
                          duration:(NSTimeInterval)duration
                  hiddenCompletion:(void(^)(void))completion
{
    // 隐藏之前的HUD
    [self i_hideHUD];

    MBProgressHUD *hud  =  [self createMBProgressHUDviewWithMessage:msg];

    hud.mode = MBProgressHUDModeIndeterminate;

    if (completion)
    {
        hud.completionBlock = completion;
    }
    if (duration > 0)
    {
        [hud hideAnimated:YES afterDelay:duration];
    }
}

#pragma mark - 自定义icon提示框

// msg type
- (void)i_showCustomIconMessage:(NSString *)msg iconType:(PE_HUDIconType)type
{
    [self i_showCustomIconMessage:msg iconType:type duration:0];
}

// msg type duration
- (void)i_showCustomIconMessage:(NSString *)msg
                        iconType:(PE_HUDIconType)type
                        duration:(NSTimeInterval)duration
{
    [self i_showCustomIconMessage:msg iconType:type duration:duration hiddenCompletion:nil];
}

// msg type duration completion
- (void)i_showCustomIconMessage:(NSString *)msg
                        iconType:(PE_HUDIconType)type
                        duration:(NSTimeInterval)duration
                hiddenCompletion:(void(^)(void))completion
{
    // 隐藏之前的HUD
    [self i_hideHUD];

    MBProgressHUD *hud  =  [self createMBProgressHUDviewWithMessage:msg];

    NSString *iconName = nil;

    switch (type) {
        case PE_HUDIconType_Success:
        {
            iconName = PkCustomKitBundlePath(@"i_activity_type_success");
        }
            break;
        case PE_HUDIconType_Error:
        {
            iconName = PkCustomKitBundlePath(@"i_activity_type_error");
        }
            break;
        case PE_HUDIconType_Info:
        {
            iconName = PkCustomKitBundlePath(@"i_activity_type_info");
        }
            break;
        case PE_HUDIconType_Warning:
        {
            iconName = PkCustomKitBundlePath(@"i_activity_type_warning");
        }
            break;
    }
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconName]];

    hud.mode = MBProgressHUDModeCustomView;

    if (completion)
    {
        hud.completionBlock = completion;
    }
    if (duration > 0)
    {
        [hud hideAnimated:YES afterDelay:duration];
    }
}

// 隐藏指示器
- (void)i_hideHUD
{
    [self i_hideHUDWithAnimated:NO];
}
// 隐藏指示器
- (void)i_hideHUDWithAnimated:(BOOL)animated
{
    [MBProgressHUD hideHUDForView:self animated:animated];
}

- (MBProgressHUD*)createMBProgressHUDviewWithMessage:(NSString*)message
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.label.text =  kString_Protect(message);
    hud.label.font = kFont_System_Regular(14.0);

    hud.removeFromSuperViewOnHide = YES;

    return hud;
}

@end
