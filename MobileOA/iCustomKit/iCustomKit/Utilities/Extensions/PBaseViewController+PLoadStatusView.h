//
//  PBaseViewController+PLoadStatusView.h
//  PCustomKit
//
//  Created by renqingyang on 2018/1/9.
//  Copyright © 2018年 . All rights reserved.
//

#import "PBaseViewController.h"

/// LoadStatusView状态枚举
typedef NSString *PE_LoadStatusViewStatus NS_STRING_ENUM;

FOUNDATION_EXPORT PE_LoadStatusViewStatus const PE_LoadStatusViewStatus_Loading;
FOUNDATION_EXPORT PE_LoadStatusViewStatus const PE_LoadStatusViewStatus_Empty;
FOUNDATION_EXPORT PE_LoadStatusViewStatus const PE_LoadStatusViewStatus_NoNetWork;
FOUNDATION_EXPORT PE_LoadStatusViewStatus const PE_LoadStatusViewStatus_LoadFailed;

/*!
 *  @author 任清阳, 2018-01-09  17:19:20
 *
 *  @brief  VC加载状态扩展，针对于页面级的加载状态
 *
 *  @since  1.0
 */

@interface PBaseViewController (PLoadStatusView)

/*!

 @brief 根据加载状态刷新loadStatusView。

 @discussion 根据加载状态刷新loadStatusView.

 @code [self i_reloadLoadStatusViewSet:PE_LoadStatusViewStatus_Normal offset:0.0];

 @encode

 @param  loadStatusViewStatus 显示的status枚举，默认偏移量为0.0.

 */
- (void)i_reloadLoadStatusViewSet:(PE_LoadStatusViewStatus)loadStatusViewStatus;

/*!

 @brief 根据加载状态刷新loadStatusView。

 @discussion 根据加载状态刷新loadStatusView.

 @code [self i_reloadLoadStatusViewSet:PE_LoadStatusViewStatus_Normal offset:0.0];

 @encode

 @param  loadStatusViewStatus 显示的status枚举，offsetY loadView距顶部的偏移量.

 */
- (void)i_reloadLoadStatusViewSet:(PE_LoadStatusViewStatus)loadStatusViewStatus
                            offset:(float)offsetY;

/// 隐藏LoadStatusView
- (void)i_hideLoadStatusViewSet;

@end
